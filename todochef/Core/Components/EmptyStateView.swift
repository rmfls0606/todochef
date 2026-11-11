//
//  EmptyStateView.swift
//  todochef
//
//  Created by 이상민 on 11/11/26.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String?
    let description: String
    
    init(title: String?, description: String) {
        self.title = title
        self.description = description
    }
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            Text(title ?? "")
                .font(.shelfTitle)
                .foregroundStyle(.textPrimary)
            
            Text(description)
                .font(.bodyText)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
        }//: VSTACK
        .vCenter()
        .padding(Spacing.lg)
        .accessibilityElement(children: .combine)
    }
}
