import UIKit
import PlaygroundSupport

class Point {
    var x:Float
    var y:Float
    
    init(x: Float = 0, y: Float = 0) {
        self.x = x
        self.y = y
    }
}

extension Point {
    var cgPoint:CGPoint {
        return CGPoint(x: x, y: y)
    }
}

class SampleView : BaseView {
    
    let point = Point(
        x: 300,
        y: 200
    )
    
    let delta:Float = 0.05
    
    override func setup() {
        setNeedsDisplay()
    }
    
    override func update(context: CGContext) {
        context.translateBy(x: CGFloat(width / 2), y: CGFloat(height / 2))
        
        context.beginPath()
        context.addArc(
            center: point.cgPoint,
            radius: 20, startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        let cosine = cosf(delta)
        let sine = sin(delta)
        let x = point.x * cosine - point.y * sine
        let y = point.y * cosine + point.x * sine
        
        point.x = x
        point.y = y
        
        requestAnimationFrame(#selector(self.setNeedsDisplay as () -> ()))
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
