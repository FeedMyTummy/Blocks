//
//  WWave.swift
//  Blocks
//
//  Original https://stackoverflow.com/a/63412977/10447655
//  Modified by FeedMyTummy on 12/8/20.
//

import SwiftUI

struct WWave: Shape {

    private var offset: Angle
    private let fractionFilled: Double
    private let height: CGFloat
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let lowfudge = -0.05
        let highfudge = 1.05
        
        let newfractionFilled = lowfudge + (highfudge - lowfudge) * fractionFilled
        let waveHeight = height * rect.height
        let yoffset = CGFloat(1 - newfractionFilled) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 360)
        
        p.move(to: CGPoint(x: 0, y: yoffset + waveHeight * CGFloat(sin(offset.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width + 5
            p.addLine(to: CGPoint(x: x, y: yoffset + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
    
    init(offset: Angle, fractionFilled: Double, height: CGFloat) {
        self.offset = offset
        self.fractionFilled = fractionFilled
        self.height = height
    }
}

struct WWave_Previews: PreviewProvider {
    
    static var previews: some View {
        WWave(offset: .zero, fractionFilled: 0.5, height: 0.015)
    }
}
