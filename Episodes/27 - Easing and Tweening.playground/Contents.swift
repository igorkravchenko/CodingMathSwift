import UIKit
import PlaygroundSupport

class Point {
    var x:Float
    var y:Float
    
    init(x:Float = 0, y:Float = 0) {
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
    var target:Point!
    var position:Point!
    let ease:Float = 0.1
    
    override func setup() {
        target = Point(
            x: width,
            y: Float.random() * height
        )
        
        position = Point(
            x: 0,
            y: Float.random() * height
        )
        
        setNeedsDisplay()
    }
    
    override func update(context: CGContext) {
        context.beginPath()
        context.addArc(
            center: position.cgPoint,
            radius: 10,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        let dx = target.x - position.x
        let dy = target.y - position.y
        let vx = dx * ease
        let vy = dy * ease
        position.x += vx
        position.y += vy
        requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
    }
    
    override func handleTouchMoved(touchX: Float, touchY: Float) {
        target.x = touchX
        target.y = touchY
    }
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
