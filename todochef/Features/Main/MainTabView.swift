//
//  MainTabView.swift
//  todochef
//
//  Created by 이상민 on 10/25/26.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab: MainTab = .basket
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTab.allCases, id: \.self){ tab in
                Tab(tab.title, systemImage: tab.imageName, value: tab){
                    NavigationStack {
                        destination(for: tab)
                    }
                }
            }
        }
        .tint(.brandPrimary)
    }
    
    @ViewBuilder
    private func destination(for tab: MainTab) -> some View{
        switch tab {
        case .basket:
            BasketView()
        case .fridge:
            FridgeView()
        case .counter:
            CounterView()
        case .cookbook:
            CookbookView()
        }
    }
}

#Preview {
    MainTabView()
}
