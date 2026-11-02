//
//  TaskRepositoryProtocol.swift
//  todochef
//
//  Created by 이상민 on 11/3/26.
//

import Foundation

@MainActor
protocol TaskRepositoryProtocol{
    func create(_ task: Task) throws
    func fetchAll() throws -> [Task]
    func update(_ task: Task) throws
    func delete(_ task: Task) throws
}
