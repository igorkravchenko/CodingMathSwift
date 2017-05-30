import UIKit
import PlaygroundSupport


class SampleView : BaseView {
    
    override func setup() {
        
    }
    
    override func update(context: CGContext) {
        context.beginPath()
        context.move(to: CGPoint(x: width / 2, y: 0))
        context.addLine(to: CGPoint(x: width / 2, y: height))
        context.strokePath()
        
        for _ in 0 ..< 100 {
            let heads = Float.random() < 0.5
            let y = Float.random() * height
            var x = Float.random() * width / 2
            
            if heads {
                x += width / 2
            }
            
            context.beginPath()
            context.addArc(
                center: CGPoint(x: x, y: y),
                radius: CGFloat(20),
                startAngle: -CGFloat.pi,
                endAngle: CGFloat.pi,
                clockwise: false
            )
            context.fillPath()
        }
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true

