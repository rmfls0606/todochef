//
//  FridgeShelfView.swift
//  todochef
//
//  Created by 이상민 on 11/17/26.
//

import SwiftUI

struct FridgeShelfView: View {
    let shelfSection: FridgeShelfSection
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            header
            content
        }//: VSTACK
    }
    
    private var header: some View{
        HStack(spacing: Spacing.xs) {
            Text(shelfSection.shelf.title)
                .font(.shelfTitle)
                .foregroundStyle(.textPrimary)
            
            Text("\(shelfSection.tasks.count)")
                .font(.taskTitle)
                .foregroundStyle(.textSecondary)
                .padding(.horizontal, Spacing.sm)
                .padding(.vertical, Spacing.xs)
                .background{
                    Capsule()
                        .fill(.freshnessWaiting)
                }
        }//: HSTACK
        .hLeading()
    }
    
    private var content: some View{
        Group{
            if shelfSection.tasks.isEmpty{
                Text(shelfSection.shelf == .storage ? "크기를 정한 재료가 이곳에 보관돼요" : "여기로 재료를 끌어다 놓으세요")
                    .font(.bodyText)
                    .foregroundStyle(.textSecondary)
                    .hCenter()
            }else{
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: Spacing.md) {
                        ForEach(shelfSection.tasks, id: \.self) { task in
                            FridgeTaskCell(task: task)
                                .containerRelativeFrame(.horizontal, count: 3, span: 1, spacing: Spacing.md)
                        }//: LOOP
                    }//: LazyHStack
                }//: SCROLLVIEW
                .scrollTargetLayout()
                .scrollTargetBehavior(.viewAligned)
            }
        }
        .padding(Spacing.md)
        .background {
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .fill(.surface)
        }
        .overlay{
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.freshnessWaiting, lineWidth: 1)
        }
    }
}
