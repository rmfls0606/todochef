//
//  MainTab.swift
//  todochef
//
//  Created by 이상민 on 10/25/26.
//

enum MainTab: CaseIterable{
    case basket
    case fridge
    case counter
    case cookbook
    
    var title: String{
        switch self {
        case .basket:
            return "장바구니"
        case .fridge:
            return "냉장고"
        case .counter:
            return "조리대"
        case .cookbook:
            return "요리북"
        }
    }
    
    var imageName: String{
        switch self {
        case .basket:
            return "basket"
        case .fridge:
            return "refrigerator"
        case .counter:
            return "frying.pan"
        case .cookbook:
            return "book.closed"
        }
    }
}
