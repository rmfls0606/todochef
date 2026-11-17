//
//  FridgeViewModel.swift
//  todochef
//
//  Created by 이상민 on 11/17/26.
//

import Combine
import Foundation

final class FridgeViewModel: ViewModelType{
    private let repository: TaskRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    @Published var output = Output()
    
    struct Input{
        let onAppear = PassthroughSubject<Void, Never>()
    }
    
    struct Output{
        var sections: [FridgeShelfSection] = []
    }
    
    init(repository: TaskRepositoryProtocol){
        self.repository = repository
        transform()
    }
    
    func transform() {
        input.onAppear
            .sink { [weak self] _ in
                guard let self else { return }
                fetchTasks()
            }
            .store(in: &cancellables)
    }
    
    private func fetchTasks(){
        do{
            let fridgeTasks = try repository.fetchAll()
                .filter{ $0.status == .fridge }
            
            let groupedTasks = Dictionary(grouping: fridgeTasks, by: \.shelf)
            
            output.sections = Shelf.allCases.map({ shelf in
                let tasks = groupedTasks[shelf, default: []]
                    .sorted{ $0.sortOrder < $1.sortOrder }
                
                return FridgeShelfSection(shelf: shelf, tasks: tasks)
            })
        }catch{
            print("냉장고 Task 조회 실패: \(error)")
        }
    }
}
