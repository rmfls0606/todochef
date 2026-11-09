//
//  SizeLevel.swift
//  todochef
//
//  Created by 이상민 on 11/9/26.
//

import Foundation

enum SizeLevel: Int, CaseIterable, Codable{
    case zero = 0
    case one
    case two
    case three
    case four
    case five
    
    var label: String{
        switch self {
        case .zero:
            return "크기 미정"
        case .one:
            return "한입 거리"
        case .two:
            return "간단한 재료"
        case .three:
            return "중간 크기"
        case .four:
            return "복잡한 재료"
        case .five:
            return "대형 재료"
        }
    }
    
    var icon: String{
        switch self {
        case .zero:
            return "🥛"
        case .one:
            return "🧄"
        case .two:
            return "🥚"
        case .three:
            return "🍞"
        case .four:
            return "🥩"
        case .five:
            return "🍅"
        }
    }
    
    var description: String{
        switch self {
        case .zero:
            return "아직 크기를 정하지 않았어요"
        case .one:
            return "금방 끝낼 수 있는 할 일이에요"
        case .two:
            return "가볍게 처리할 수 있는 할 일이에요"
        case .three:
            return "보통 수준의 할 일이에요"
        case .four:
            return "시간과 집중이 필요한 일이에요"
        case .five:
            return "여러 단계로 나누면 좋은 할 일이에요"
        }
    }
    
    var estimatedTime: String{
        switch self {
        case .zero: return "시간 미정"
        case .one: return "약 5~15분"
        case .two: return "약 15~30분"
        case .three: return "약 1~2시간"
        case .four: return "약 2~4시간"
        case .five: return "약 4시간 이상"
        }
    }
}
