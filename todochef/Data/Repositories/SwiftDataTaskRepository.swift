//
//  SwiftDataTaskRepository.swift
//  todochef
//
//  Created by 이상민 on 11/3/26.
//

import SwiftData

@MainActor
final class SwiftDataTaskRepository: TaskRepositoryProtocol{
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func create(_ task: Task) throws {
        modelContext.insert(task)
        try modelContext.save()
    }
    
    func fetchAll() throws -> [Task] {
        let descriptor = FetchDescriptor<Task>()
        return try modelContext.fetch(descriptor)
    }
    
    func update(_ task: Task) throws {
        //조회한 Task의 프로퍼티를 변경한 후 호출
        try modelContext.save()
    }
    
    func update(_ tasks: [Task]) throws{
        guard !tasks.isEmpty else { return }
        guard modelContext.hasChanges else { return }
        
        do{
            try modelContext.save()
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
    func delete(_ task: Task) throws {
        modelContext.delete(task)
        try modelContext.save()
    }
}
