//
//  BasketViewModel.swift
//  todochef
//
//  Created by 이상민 on 11/2/26.
//

import Foundation
import Combine

final class BasketViewModel: ViewModelType{
    
    private let repository: TaskRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    @Published var output = Output()
    
    struct Input{
        var todoInputText = PassthroughSubject<String, Never>()
        let createTodoTaskButtonTapped = PassthroughSubject<String, Never>()
    }
    
    struct Output{
        var todoIntputText: String = ""
    }
    
    init(repository: TaskRepositoryProtocol){
        self.repository = repository
        transform()
    }
    
    func transform(){
        // TODO: 중복 요청 방지
        input.createTodoTaskButtonTapped
            .sink { todoText in
                print(todoText)
            }
            .store(in: &cancellables)
    }
}
