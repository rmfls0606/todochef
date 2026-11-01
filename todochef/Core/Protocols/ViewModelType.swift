//
//  ViewModelType.swift
//  todochef
//
//  Created by 이상민 on 11/2/26.
//

import Foundation
import Combine

@MainActor
protocol ViewModelType: AnyObject, ObservableObject {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get set }
    
    var output: Output { get set }
    
    func transform()
}
