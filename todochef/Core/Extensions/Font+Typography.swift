//
//  Font+Typography.swift
//  todochef
//
//  Created by 이상민 on 10/25/26.
//

import SwiftUI

extension Font{
    //MARK: - Title
    static let brandTitle = Font.system(size: 32, weight: .bold)
    static let screenTitle = Font.system(size: 24, weight: .bold)
    static let shelfTitle = Font.system(size: 16, weight: .bold)
    
    //MARK: - Content
    static let bodyText = Font.system(size: 14, weight: .regular)
    static let taskTitle = Font.system(size: 11.5, weight: .bold)
    
    //MARK: - Label
    static let freshnessLabel = Font.system(size: 9, weight: .medium)
}
