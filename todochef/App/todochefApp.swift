//
//  todochefApp.swift
//  todochef
//
//  Created by 이상민 on 10/24/26.
//

import SwiftUI
import SwiftData

@main
struct todochefApp: App {
    
    private let diContainer: AppDIContainer
    
    init(){
        do{
            let modelContainer = try ModelContainer(for: Task.self)
            
            diContainer = AppDIContainer(
                modelContainer: modelContainer
            )
        } catch{
            fatalError("SwiftData 초기화 실패: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView(diContainer: diContainer)
        }
        .modelContainer(diContainer.modelContainer)
    }
}
