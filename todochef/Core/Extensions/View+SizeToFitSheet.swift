//
//  View+SizeToFitSheet.swift
//  todochef
//
//  Created by 이상민 on 11/16/26.
//

import SwiftUI

enum SizeToFitPresentationDetent{
    case sizeToFit
}

struct SizeToFitModifier: ViewModifier{
    let additional: Set<PresentationDetent>
    
    @State private var contentHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGFloat.self) { geometry in
                geometry.size.height
            } action: { height in
                guard height > 0 else { return }
                contentHeight = height
            }
            .presentationDetents(Set([.height(contentHeight)]).union(additional))

    }
}

extension View{
    func presentationDetents(_ detent: SizeToFitPresentationDetent, additional: Set<PresentationDetent> = []) -> some View{
        modifier(SizeToFitModifier(additional: additional))
    }
}
