//
//  BasketCell.swift
//  todochef
//
//  Created by 이상민 on 11/5/26.
//

import SwiftUI

struct BasketCell: View{
    let task: Task
    
    @State private var onSheet: Bool = false
    
    var body: some View{
        HStack(spacing: Spacing.md){
            Circle()
                .fill(Color.freshnessWaiting)
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: "app.gift")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .vTop()
            
            VStack(alignment: .leading, spacing: Spacing.xs){
                Text(task.title)
                    .font(Font.bodyText)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                
                HStack(alignment: .center, spacing: Spacing.xs){
                    Image(systemName: "app.gift")
                    
                    Text(task.content ?? "크기 미정")
                }//: HSTACK
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
                    print("셀 삭제")
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
                print(level)
            })
                .presentationDetents([.medium,.large])
        }
    }
}
