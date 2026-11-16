//
//  BasketViewModel.swift
//  todochef
//
//  Created by 이상민 on 11/2/26.
//

import Combine
import Foundation

final class BasketViewModel: ViewModelType {

    private let repository: TaskRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    var input = Input()
    @Published var output = Output()

    struct Input {
        var todoInputText = PassthroughSubject<String, Never>()
        let createTodoTaskButtonTapped = PassthroughSubject<String, Never>()
        let deleteTodoButtonTapped = PassthroughSubject<Task, Never>()
        let onAppear = PassthroughSubject<Void, Never>()
        
        let confirmTaskSize = PassthroughSubject<(task: Task, level: SizeLevel), Never>()
        
        //선택 관련
        let selectionModeButtonTapped = PassthroughSubject<Void, Never>()
        let taskSelectionTapped = PassthroughSubject<UUID, Never>()
        let selectedAllButtonTapped = PassthroughSubject<Void, Never>()
        let batchSizeConfirmed = PassthroughSubject<SizeLevel, Never>()
    }

    struct Output {
        var todoInputText: String = ""
        var showTodoLengthLimitMessage: Bool = false
        var canCreateTodo: Bool = false
        
        var basketResult: [Task] = []
        var fridgeResult: [Task] = []
        var isSaving: Bool = false
        
        //선택 관련
        var isSelectionMode: Bool = false
        var selectedTaskIDs: Set<UUID> = []
        
        var selectionCount: Int {
            selectedTaskIDs.count
        }
        
        var basketTaskIDs: Set<UUID> {
            Set(
                basketResult
                    .map(\.id)
            )
        }
        
        var isAllBasketSelected: Bool {
            !basketTaskIDs.isEmpty && basketTaskIDs.isSubset(of: selectedTaskIDs)
        }
    }

    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
        transform()
    }

    func transform() {
        input.todoInputText
            .sink { [weak self] inputText in
                guard let self else { return }
                
                let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
                
                output.todoInputText = trimmedText
                output.showTodoLengthLimitMessage = inputText.count > 20
                output.canCreateTodo = !trimmedText.isEmpty && inputText.count <= 20
            }
            .store(in: &cancellables)
        
        input.onAppear
            .sink { [weak self] _ in
                do {
                    try self?.fetchTodoTask()
                } catch {
                    print("불러오기 실패: \(error)")
                }
            }
            .store(in: &cancellables)

        input.createTodoTaskButtonTapped
            .throttle(
                for: .milliseconds(500),
                scheduler: RunLoop.main,
                latest: false
            )
            .sink { [weak self] todoText in
                guard let self else { return }
                self.createTodoTask(todoText)
            }
            .store(in: &cancellables)
        
        input.confirmTaskSize
            .sink { [weak self] task, level in
                guard let self else { return }
                self.updateTaskSize(task, level: level)
            }
            .store(in: &cancellables)
        
        input.deleteTodoButtonTapped
            .sink { [weak self] task in
                guard let self else { return }
                self.deleteTask(task)
            }
            .store(in: &cancellables)
        
        //선택 관련
        input.selectionModeButtonTapped
            .sink { [weak self] _ in
                guard let self, !output.basketResult.isEmpty else { return }
                
                output.isSelectionMode.toggle()
                
                if !output.isSelectionMode{
                    output.selectedTaskIDs.removeAll()
                }
            }
            .store(in: &cancellables)
        
        input.taskSelectionTapped
            .sink { [weak self] taskID in
                guard let self else { return }
                
                if output.selectedTaskIDs.contains(taskID){
                    output.selectedTaskIDs.remove(taskID)
                }else{
                    output.selectedTaskIDs.insert(taskID)
                }
            }
            .store(in: &cancellables)
        
        input.selectedAllButtonTapped
            .sink { [weak self] _ in
                guard let self else { return }
                
                let unspecifiedIDs = output.basketTaskIDs
                
                guard !unspecifiedIDs.isEmpty else { return }
                
                if output.isAllBasketSelected{
                    output.selectedTaskIDs.removeAll()
                }else{
                    output.selectedTaskIDs = unspecifiedIDs
                }
            }
            .store(in: &cancellables)
        
        input.batchSizeConfirmed
            .sink { [weak self] level in
                guard let self else { return }
                self.updateSelectedTaskSizes(level: level)
            }
            .store(in: &cancellables)
    }

    //MARK: - Functions
    private func createTodoTask(_ inputText: String) {
        guard !output.isSaving else { return }

        let title =
            inputText
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !title.isEmpty else { return }
        guard title.count <= 20 else { return }
        
        output.isSaving = true
        defer { output.isSaving = false }

        let task = Task(
            id: UUID(),
            title: title,
            inputType: .text,
            status: .basket,
            shelf: .later
        )

        do {
            try repository.create(task)
            try fetchTodoTask()
            
            output.todoInputText = ""
            output.showTodoLengthLimitMessage = false
            output.canCreateTodo = false
        } catch {
            print("할 일 저장 또는 목록 갱신 실패", error)
        }
    }

    private func fetchTodoTask() throws {
        //목록을 변경하기 전체 상태 저장
        let shouldKeepAllSelected = output.isSelectionMode && output.isAllBasketSelected
        
        let tasks = try repository.fetchAll()
        
        output.basketResult = tasks.filter({$0.status == .basket})
        output.fridgeResult = tasks.filter({$0.status == .fridge})
        
        let basketIDs = Set(output.basketResult.map(\.id))
        
        //장바구니가 비면 선택 모드 종료
        guard !output.basketResult.isEmpty else {
            output.selectedTaskIDs.removeAll()
            output.isSelectionMode = false
            return
        }
        
        guard output.isSelectionMode else {
            output.selectedTaskIDs.removeAll()
            return
        }
        
        if shouldKeepAllSelected{
            //새로 추가된 Task까지 모두 선택
            output.selectedTaskIDs = basketIDs
        }else{
            output.selectedTaskIDs.formIntersection(basketIDs)
        }
    }
    
    private func updateTaskSize(_ task: Task, level: SizeLevel){
        let previousLevel = task.sizeLevel
        let previousStatus = task.status
        
        task.sizeLevel = level
        task.status = .fridge
        
        do{
            try repository.update(task)
        }catch{
            task.sizeLevel = previousLevel
            task.status = previousStatus
            
            print("Task 크기 수정 실패: \(error)")
            return
        }
        
        do{
            try fetchTodoTask()
        }catch{
            print("Task 목록 새로고침 실패: \(error)")
        }
    }
    
    private func deleteTask(_ task: Task){
        do{
            try repository.delete(task)
        } catch{
            print("Task 삭제 실패: \(error)")
        }
        
        do{
            try fetchTodoTask()
        }catch{
            print("Task 목록 새로고침 실패: \(error)")
        }
    }
    
    private func updateSelectedTaskSizes(level: SizeLevel){
        let selectedTasks = output.basketResult.filter { task in
            output.selectedTaskIDs.contains(task.id)
        }
        guard !selectedTasks.isEmpty else { return }
        
        selectedTasks.forEach { task in
            task.sizeLevel = level
            task.status = .fridge
        }
        
        do{
            try repository.update(selectedTasks)
        } catch {
            print("일괄 크기 변경 실패: \(error)")
            return
        }
        
        output.selectedTaskIDs.removeAll()
        output.isSelectionMode = false
        
        do{
            try fetchTodoTask()
        } catch {
            print("일괄 크기 변경 성공, 목록 갱신 실패: \(error)")
        }
    }
}
