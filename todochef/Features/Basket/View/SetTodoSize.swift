//
//  SetTodoSize.swift
//  todochef
//
//  Created by 이상민 on 11/5/26.
//

import SwiftUI

struct SetTodoSize: View {
    let task: Task
    let onConfirm: (SizeLevel) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedLevel: SizeLevel
    
    init(task: Task, onConfirm: @escaping (SizeLevel) -> Void){
        self.task = task
        self.onConfirm = onConfirm
        
        _selectedLevel = State(
            initialValue: task.sizeLevel == .zero ? .three : task.sizeLevel
        )
    }
    
    var body: some View {
        VStack(spacing: Spacing.md){
            VStack(spacing: Spacing.xs){
                HStack(spacing: Spacing.xs) {
                    Text("🥕")
                        .font(.shelfTitle)
                        .foregroundStyle(.freshnessSoon)
                    
                    Text("크기 정하기")
                        .font(.shelfTitle)
                }//: HSTACK
                
                Text("\"\(task.title)\"")
                    .font(.bodyText)
            }//: VSTACK
            
            Circle()
                .fill(Color.freshnessWaiting)
                .frame(width: 60, height: 60)
                .overlay {
                    Text(task.sizeLevel.icon)
                        .font(.brandTitle)
                }
            
            VStack(spacing: Spacing.sm){
                Text(task.sizeLevel.label)
                    .font(.shelfTitle)
                
                VStack(spacing: Spacing.xs){
                    Text(task.sizeLevel.description)
                        .font(.bodyText)
                        .fontWeight(.bold)
                    
                    Text(task.sizeLevel.estimatedTime)
                        .font(.bodyText)
                }//: VSTACK
            }//: VSTACK
            
            TaskSizeSlider(selectedLevel: $selectedLevel)
            
            HStack(spacing: Spacing.lg){
                //취소
                Button {
                    dismiss()
                } label: {
                    Text("취소")
                }
                .hCenter()
                .padding(Spacing.md)
                .background(content: {
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .fill(.appBackground)
                })

                //확인
                Button {
                    onConfirm(selectedLevel)
                } label: {
                    Text("확인")
                }
                .hCenter()
                .padding(Spacing.md)
                .background(content: {
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .fill(.orange)
                })
            }//: HSTACK
            .font(.shelfTitle)
            .foregroundStyle(.textPrimary)
        }//: VSTACK
        .padding(.horizontal, Spacing.lg)
    }
}
