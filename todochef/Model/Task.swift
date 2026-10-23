//
//  Task.swift
//  todochef
//
//  Created by 이상민 on 10/24/26.
//

import Foundation
import SwiftData

@Model
final class Task{
    @Attribute(.unique) var id: UUID // 고유 식별자
    var title: String // 태스크 제목
    var content: String? // 메모 or 세부 내용
    var inputType: InputType // 수집 형태
    var mediaPath: String? // 음성 or 이미지 파일 경로
    var status: Status // 단계 구분
    var shelf: Shelf // 냉장고 선반
    var cookedAt: Date? // 완료 시각(요리북 기록용)
    var expiredAt: Date? // 유통기한(마감일)
    
    init(id: UUID, title: String, content: String? = nil, inputType: InputType, mediaPath: String? = nil, status: Status, shelf: Shelf, cookedAt: Date? = nil, expiredAt: Date? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.inputType = inputType
        self.mediaPath = mediaPath
        self.status = status
        self.shelf = shelf
        self.cookedAt = cookedAt
        self.expiredAt = expiredAt
    }
}

//수집 형태 종료
enum InputType: Codable{
    case text
    case voice
    case image
}

// 단계 구분 종류
enum Status: Codable{
    case basket
    case fridge
    case counter
    case done
}

//냉장고 선반 종류
enum Shelf: Codable{
    case today
    case tomorrow
    case week
    case later
}
