//
//  BasketCell.swift
//  todochef
//
//  Created by 이상민 on 11/5/26.
//

import SwiftUI

struct BasketCell: View{
    let task: Task
    let onConfirm: (Task, SizeLevel) -> Void
    let onDelete: (Task) -> Void
    
    @State private var onSheet: Bool = false
    
    var body: some View{
        HStack(spacing: Spacing.md){
            Circle()
                .fill(Color.freshnessWaiting)
                .frame(width: 40, height: 40)
                .overlay {
                    Text(task.sizeLevel.icon)
                        .font(.shelfTitle)
                }
                .vTop()
            
            VStack(alignment: .leading, spacing: Spacing.xs){
                Text(task.title)
                    .font(Font.bodyText)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                
                Text(task.sizeLevel != .zero ? "\(task.sizeLevel.label) • \(task.sizeLevel.estimatedTime)" : "🥛 크기 미정")
                    .font(Font.taskTitle)
                    .foregroundStyle(Color.textSecondary)
            }//: VSTACK
            
            Spacer()
            
            Menu{
                Button {
                    onSheet.toggle()
                } label: {
                    Text("수정")
                }
                
                Button {
                    onDelete(task)
                } label: {
                    Text("삭제")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .font(.bodyText)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.textSecondary)
                    .contentShape(Rectangle())
                    .vCenter()
            }
        }//: HSTACK
        .padding(Spacing.md)
        .hLeading()
        .background{
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .fill(Color.surface)
        }
        .sheet(isPresented: $onSheet) {
            SetTodoSize(task: task, onConfirm: { level in
                onConfirm(task, level)
                // TODO: 저장 실패 시 시트 닫히지 않게 하고 toast
                onSheet = false
            })
            .presentationDetents([.medium,.large])
        }
    }
}
