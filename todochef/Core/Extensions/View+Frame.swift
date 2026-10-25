//
//  View+Frame.swift
//  todochef
//
//  Created by 이상민 on 10/26/26.
//

import SwiftUI

extension View{
    
    //MARK: - Vertical Alignment
    
    func vCenter() -> some View{
        frame(maxHeight: .infinity, alignment: .center)
    }
    
    func vTop() -> some View{
        frame(maxHeight: .infinity, alignment: .top)
    }
    
    func vBottom() -> some View{
        frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    //MARK: - Horizontal Alignment
    
    func hCenter() -> some View{
        frame(maxWidth: .infinity, alignment: .center)
    }
    
    func hLeading() -> some View{
        frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View{
        frame(maxWidth: .infinity, alignment: .trailing)
    }
}
