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
    @FocusState private var isTodoInputFocused: Bool
    
    init(viewModel: BasketViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private var isBasketEmpty: Bool{
        viewModel.output.basketResult.isEmpty &&
        viewModel.output.fridgeResult.isEmpty
    }
    
    private var todoInputTextBinding: Binding<String>{
        Binding {
            viewModel.output.todoInputText
        } set: { newValue in
            viewModel.input.todoInputText.send(newValue)
        }
        
    }
    
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
            
            HStack(alignment: .top, spacing: Spacing.sm){
                VStack(alignment: .trailing){
                    Text("할 일을 입력하세요")
                        .font(.bodyText)
                        .hidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlay(alignment: .leading) {
                            TextField("할 일을 입력하세요", text: todoInputTextBinding)
                                .focused($isTodoInputFocused)
                                .font(.bodyText)
                                .textFieldStyle(.plain)
                        }
                        .padding(Spacing.md)
                        .background {
                            RoundedRectangle(cornerRadius: CornerRadius.medium)
                                .fill(Color.surface)
                                .stroke(viewModel.output.showTodoLengthLimitMessage ? Color.freshnessExpired : Color.divider, lineWidth: 1)
                        }
                    
                    if viewModel.output.showTodoLengthLimitMessage{
                        Text("할 일은 최대 20자까지 입력할 수 있어요")
                            .font(.freshnessLabel)
                            .foregroundStyle(.freshnessExpired)
                    }
                }//: VSTACK
                
                Button {
                    viewModel.input.createTodoTaskButtonTapped.send(viewModel.output.todoInputText)
                    isTodoInputFocused = false
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
                .disabled(viewModel.output.isSaving || !viewModel.output.canCreateTodo)
            }//: HSTACK
            .padding(.horizontal, Spacing.lg)

            basketContent
        }//: VSTACK
        .vTop()
        .background(.appBackground)
        .onAppear {
            viewModel.input.onAppear.send(())
        }
        .onTapGesture {
            isTodoInputFocused = false
        }
    }
    
    @ViewBuilder
    private var basketContent: some View{
        if isBasketEmpty{
            EmptyStateView(title: nil, description: """
                아직 담은 재료가 없어요
                할 일을 적어서 새 재료를 추가해 보세요.
                """)
        }else{
            basketListContent
        }
    }
    
    private var basketListContent: some View{
        //MARK: - Content
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: Spacing.sm){
                if !viewModel.output.basketResult.isEmpty{
                    Section{
                        ForEach(viewModel.output.basketResult, id: \.id) { task in
                            BasketCell(task: task) { task, level in
                                viewModel.input.confirmTaskSize.send((task, level))
                            } onDelete: { task in
                                viewModel.input.deleteTodoButtonTapped.send(task)
                            }
                            
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
                            BasketCell(task: task){ task, level in
                                viewModel.input.confirmTaskSize.send((task, level))
                            } onDelete: { task in
                                viewModel.input.deleteTodoButtonTapped.send(task)
                            }
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
        .scrollDismissesKeyboard(.immediately)
    }
}
