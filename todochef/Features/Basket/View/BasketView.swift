//
//  BasketView.swift
//  todochef
//
//  Created by 이상민 on 10/24/26.
//

import SwiftUI
import Combine

struct BasketView: View {
    
    @StateObject private var viewModel: BasketViewModel
    
    init(viewModel: BasketViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    @State private var todoInputText: String = ""
    
    var body: some View {
        VStack(spacing: Spacing.md){
            //MARK: - Header
            HStack{
                HStack(spacing: Spacing.xs){
                    Image(systemName: "basket")
                        .font(.shelfTitle)
                    
                    Text("장바구니")
                        .font(.screenTitle)
                }//: HSTACK
                .foregroundStyle(Color.textPrimary)
                
                Spacer()
                
                Button {
                    print("냉장고 이동")
                } label: {
                    Image(systemName: "refrigerator")
                        .font(.shelfTitle)
                }
            }//: HSTACK
            .padding(.top, Spacing.lg)
            .padding(.horizontal, Spacing.lg)
            
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
                    todoInputText = ""
                } label: {
                    HStack(spacing: Spacing.xs){
                        Image(systemName: "basket")
                        
                        Text("담기")
                    }//: HSTACK
                    .font(.bodyText)
                    .fontWeight(.bold)
                    .foregroundStyle(.textPrimary)
                }
                .disabled(viewModel.output.isSaving)
                .padding(Spacing.md)
                .background{
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .fill(Color.freshnessSoon)
                        .stroke(Color.freshnessSoon, lineWidth: 1)
                }
            }//: HSTACK
            .padding(.horizontal, Spacing.lg)
            
            //MARK: - Content
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: Spacing.sm){
                    if !viewModel.output.basketResult.isEmpty{
                        Section{
                            ForEach(viewModel.output.basketResult, id: \.id) { task in
                                BasketCell(task: task)
                            }//: LOOP
                        } header: {
                            Text("크기 정할 재료")
                                .font(.shelfTitle)
                                .foregroundStyle(Color.textPrimary)
                        }
                    }
                    
                    if !viewModel.output.fridgeResult.isEmpty{
                        Section {
                            ForEach(viewModel.output.fridgeResult, id: \.id){ task in
                                BasketCell(task: task)
                            }
                        } header: {
                            Text("크기 정한 재료 -> 냉장고 보관함으로")
                                .font(.shelfTitle)
                                .foregroundStyle(Color.textPrimary)
                                .padding(.top, viewModel.output.basketResult.isEmpty ? 0 : Spacing.md)
                        }
                    }
                }//: LazyVStack
                .padding(.horizontal, Spacing.lg)
            }//: SCROLLVIEW
            .scrollBounceBehavior(.basedOnSize)
        }//: VSTACK
        .vTop()
        .background(.appBackground)
        .onAppear {
            viewModel.input.onAppear.send(())
        }
    }
}
