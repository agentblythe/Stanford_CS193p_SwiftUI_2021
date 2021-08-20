//
//  Pie.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 19/07/2021.
//

import SwiftUI

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise = false
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let centre = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: centre.x + radius * CGFloat(cos(startAngle.radians)),
            y: centre.y + radius * CGFloat(sin(startAngle.radians))
        )
        
        var p = Path()
        p.move(to: centre)
        p.addLine(to: start)
        p.addArc(center: centre,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 clockwise: !clockwise)
        p.addLine(to: centre)
        
        return p
    }
}
