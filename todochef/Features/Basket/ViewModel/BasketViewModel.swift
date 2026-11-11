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
    }

    struct Output {
        var basketResult: [Task] = []
        var fridgeResult: [Task] = []
        var isSaving: Bool = false
    }

    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
        transform()
    }

    func transform() {
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
    }

    //MARK: - Functions
    private func createTodoTask(_ inputText: String) {
        guard !output.isSaving else { return }

        let title =
            inputText
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !title.isEmpty else { return }
        
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
        } catch {
            print("할 일 저장 또는 목록 갱신 실패", error)
        }
    }

    private func fetchTodoTask() throws {
        let tasks = try repository.fetchAll()
        
        output.basketResult = tasks.filter({$0.status == .basket})
        output.fridgeResult = tasks.filter({$0.status == .fridge})
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
}
