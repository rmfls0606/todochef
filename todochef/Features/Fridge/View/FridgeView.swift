//
//  FridgeView.swift
//  todochef
//
//  Created by 이상민 on 10/25/26.
//

import Combine
import SwiftUI

struct FridgeView: View {
    @StateObject private var viewModel: FridgeViewModel
    
    init(viewModel: FridgeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack{
            ScrollView{
                LazyVStack(spacing: Spacing.xl){
                    ForEach(viewModel.output.sections){ section in
                        FridgeShelfView(shelfSection: section)
                    }//: LOOP
                }//: LazyVStack
                .padding(.horizontal, Spacing.xl)
                .padding(.bottom, Spacing.xl)
            }//: SCROLLVIEW
        }//: VSTACK
        .background(Color.appBackground)
        .navigationTitle("🧊 냉장고")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "trash")
                    .foregroundStyle(.textPrimary)
            }
        }
        .onAppear {
            viewModel.input.onAppear.send(())
        }
    }
}
