//
//  BasketView.swift
//  todochef
//
//  Created by 이상민 on 10/24/26.
//

import SwiftUI
import Combine

struct BasketView: View {
    
    @StateObject private var viewModel = BasketViewModel()
    
    @State private var todoInputText: String = ""
    
    var body: some View {
        VStack{
            HStack{
                TextField("할 일을 입력하세요", text: $todoInputText)
                    .font(.bodyText)
                    .padding(Spacing.md)
                    .background{
                        RoundedRectangle(cornerRadius: CornerRadius.medium)
                            .fill(Color.surface)
                            .stroke(Color.divider, lineWidth: 1)
                    }
                
                Button {
                    viewModel.input.createTodoTaskButtonTapped.send(todoInputText)
                } label: {
                    HStack(spacing: Spacing.xs){
                        Image(systemName: "basket")
                        
                        Text("담기")
                    }//: HSTACK
                    .font(.bodyText)
                    .fontWeight(.bold)
                    .foregroundStyle(.textPrimary)
                }
                .padding(Spacing.md)
                .background{
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .fill(Color.freshnessSoon)
                        .stroke(Color.freshnessSoon, lineWidth: 1)
                }
            }//: HSTACK
            
            Spacer()
            
        }//: VSTACK
        .padding(.horizontal, Spacing.lg)
        .background(.appBackground)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    print("냉장고 이동")
                } label: {
                    Image(systemName: "refrigerator")
                }
            }
            ToolbarItem(placement: .title) {
                HStack(spacing: Spacing.xs){
                    Image(systemName: "basket")
                    
                    Text("장바구니")
                        .font(.screenTitle)
                }//: HSTACK
            }
        }
    }
}

#Preview {
    BasketView()
}
