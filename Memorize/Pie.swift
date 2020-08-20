//
//  Pie.swift
//  Memorize
//
//  Created by Daniel Savchak on 31.07.2020.
//  Copyright © 2020 Danylo Savchak. All rights reserved.
//

import SwiftUI

struct Pie: Shape {
    var startAngle: Angle
    var endingAngle: Angle
    var clockwise: Bool = false
    
    var animatableData: AnimatablePair<Double,Double> {
        get {
            AnimatablePair(startAngle.radians,endingAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endingAngle = Angle.radians(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width,rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(CGFloat(startAngle.radians)),
            y: center.y + radius * sin(CGFloat(startAngle.radians))
        )
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endingAngle,
            clockwise: clockwise
        )
        p.addLine(to: center)
        return p
    }
}
