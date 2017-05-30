import UIKit
import PlaygroundSupport

let w = 600
let h = 600
let rect = CGRect(x: 0, y: 0, width: w, height: h)

class SampleView : BaseView {
    
    override func update(context: CGContext) {
        let seed = 1000
        srand48(seed)
        
        context.setFillColor(UIColor.red.cgColor)
        context.beginPath()
        
        for _ in 0 ..< 50 {
            let x = Float(drand48() * 600)
            let y = Float(drand48() * 600)
            let r = 20 + Float(drand48() * 50)
            context.beginPath()
            let p = CGPoint(x: x, y: y)
            context.addArc(
                center: p,
                radius: CGFloat(r),
                startAngle: -CGFloat.pi,
                endAngle: CGFloat.pi,
                clockwise: false
            )
            context.fillPath()
        }
        
        context.setFillColor(UIColor.yellow.cgColor)
        context.beginPath()
        
        srand48(seed)
        for _ in 0 ..< 50 {
            let x = Float(drand48() * 600)
            let y = Float(drand48() * 600)
            let r = 20 + Float(drand48() * 50 - 10)
            context.beginPath()
            let p = CGPoint(x: x, y: y)
            context.addArc(
                center: p,
                radius: CGFloat(r),
                startAngle: -CGFloat.pi,
                endAngle: CGFloat.pi,
                clockwise: false
            )
            context.fillPath()
        }

        
        
    }
}

let view = SampleView(frame: rect)
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true