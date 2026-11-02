//
//  AppDIContainer.swift
//  todochef
//
//  Created by 이상민 on 11/3/26.
//

import SwiftData

@MainActor
final class AppDIContainer{
    //MARK: - Persistence
    let modelContainer: ModelContainer
    
    //MARK: - Repositories
    let taskRepositry: TaskRepositoryProtocol
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        
        self.taskRepositry = SwiftDataTaskRepository(modelContext: modelContainer.mainContext)
    }
    
    //MARK: - ViewModel Factory
    func makeBasketViewModel() -> BasketViewModel{
        BasketViewModel(repository: taskRepositry)
    }
}
