//
//  SparklineView.swift
//  CryptoSphere
//
//  Created by Nurtore on 21.05.2026.
//


import SwiftUI

struct SparklineView: View {
    let prices: [Double]
    let isPositive: Bool
    
    var body: some View {
        GeometryReader { geometry in
            if prices.isEmpty {
                EmptyView()
            } else {
                Path { path in
                    for index in prices.indices {
                        let xPosition = geometry.size.width / CGFloat(prices.count - 1) * CGFloat(index)

                        let maxY = prices.max() ?? 0
                        let minY = prices.min() ?? 0
                        let yRange = maxY - minY
                        
                        let yPosition: CGFloat
                        if yRange == 0 {
                            yPosition = geometry.size.height / 2
                        } else {
                            yPosition = geometry.size.height - ((CGFloat(prices[index] - minY) / CGFloat(yRange)) * geometry.size.height)
                        }
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: xPosition, y: yPosition))
                        } else {
                            path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                        }
                    }
                }
                .stroke(isPositive ? Color.green : Color.red, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
            }
        }
    }
}
