//
//  TaskSizeSlider.swift
//  todochef
//
//  Created by 이상민 on 11/5/26.
//


import SwiftUI

struct TaskSizeSlider: View {
    
    @Binding var selectedLevel: SizeLevel
    
    private let levels = SizeLevel.allCases.filter{ $0 != .zero }
    private let sliderColor: Color = Color.orange
    private let sliderHeight: CGFloat = 28
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            
            // MARK: - Slider
            GeometryReader { geometry in
                let width = geometry.size.width
                
                //전체 너비를 5개 영역으로 분할
                let stepWidth = (width - 24) / CGFloat(levels.count - 1)
                
                //첫 번째와 마지막 눈금의 중심 좌표
                let startX = 12.0
                let endX = width - startX
                let centerY = sliderHeight / 2
                
                let selectedIndex = levels.firstIndex(of: selectedLevel) ?? 0
                
                //현재 선택된 단계의 좌표
                let currentX = startX
                + CGFloat(selectedIndex) * stepWidth
                
                
                ZStack(alignment: .topLeading) {
                    
                    // 전체 트랙
                    Capsule()
                        .fill(sliderColor.opacity(0.25))
                        .frame(
                            width: endX - startX,
                            height: 6
                        )
                        .position(
                            x: width / 2,
                            y: centerY
                        )
                    
                    // 선택된 구간
                    Capsule()
                        .fill(sliderColor)
                        .frame(
                            width: CGFloat(selectedIndex) * stepWidth,
                            height: 6
                        )
                        .position(
                            x: (startX + currentX) / 2,
                            y: centerY
                        )
                    
                    // 눈금
                    ForEach(levels, id: \.self) { level in
                        Circle()
                            .fill(level.rawValue < selectedLevel.rawValue ? .white :  sliderColor.opacity(0.6))
                            .frame(width: 6, height: 6)
                            .position(
                                x: startX
                                + CGFloat(level.rawValue - 1) * stepWidth,
                                y: centerY
                            )
                    }//: LOOP
                    
                    // 선택 핸들
                    Circle()
                        .fill(Color.white)
                        .frame(width: 28, height: 28)
                        .overlay {
                            Circle()
                                .fill(sliderColor)
                                .padding(5)
                        }
                        .shadow(
                            color: .black.opacity(0.15),
                            radius: 3,
                            y: 2
                        )
                        .position(x: currentX, y: centerY)
                }//: ZSTACK
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            guard stepWidth > 0 else { return }
                            
                            let position = value.location.x - startX
                            
                            let index = Int(
                                (position / stepWidth).rounded()
                            )
                            
                            //인덱스 범위를 0~4로 제한
                            let clampedIndex = min(
                                max(index, 0),
                                levels.count - 1
                            )
                            
                            selectedLevel = levels[clampedIndex]
                        }
                )
            }//: GeometryReader
            .frame(height: sliderHeight)
            
            // MARK: - Labels
            HStack(spacing: 0) {
                ForEach(Array(levels.enumerated()), id: \.element) { index, level in
                    Button {
                        selectedLevel = level
                    } label: {
                        VStack(spacing: Spacing.xs) {
                            Text(level.icon)
                                .font(.shelfTitle)
                            
                            Text(level.label)
                                .font(.taskTitle)
                                .foregroundStyle(
                                    selectedLevel == level
                                    ? Color.textPrimary
                                    : Color.textSecondary
                                )
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }//: VSTACK
//                        .hCenter()
                    }
                    .buttonStyle(.plain)
//                    .background(.green)
                    
                    if index < levels.count - 1{
                        Spacer(minLength: 0)
                    }
                }//: LOOP
            }//: HSTACK
        }//: VSTACK
    }
}
