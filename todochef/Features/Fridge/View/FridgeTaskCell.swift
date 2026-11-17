//
//  FridgeTaskCell.swift
//  todochef
//
//  Created by 이상민 on 11/17/26.
//

import SwiftUI

struct FridgeTaskCell: View {
    let task: Task
    
    var body: some View {
        VStack(alignment: .center, spacing: Spacing.sm) {
            Text(task.title)
                .font(.taskTitle)
                .foregroundStyle(.textPrimary)
            
            Divider()
            
            Text(task.sizeLevel.icon)
                .font(.bodyText)
            
            Text(task.shelf.title)
                .font(.freshnessLabel)
                .foregroundStyle(.freshnessWaiting)
                .padding(.horizontal, Spacing.sm)
                .padding(.vertical, Spacing.xs)
                .background {
                    Capsule()
                        .fill(.freshnessExpired)
                }
        }//: VSTACK
        .padding(Spacing.sm)
        .background {
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .fill(.surface)
                .stroke(.divider, lineWidth: 1)
        }
    }
}
