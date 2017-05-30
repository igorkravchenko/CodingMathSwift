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
    let numPoints:Int = 10
    var points = [Point]()
    let ease:Float = 0.1
    
    override func setup() {
        for _ in 0 ..< numPoints {
            points.append(Point(x: 0, y: 0))
        }
        
        target = Point(
            x: width,
            y: Float.random() * height
        )
        
        setNeedsDisplay()
    }
    
    override func update(context: CGContext) {
        let leader = Point(
            x: target.x,
            y: target.y
        )
        
        for point in points {
            point.x += (leader.x - point.x) * ease
            point.y += (leader.y - point.y) * ease
            
            context.beginPath()
            context.addArc(
                center: point.cgPoint,
                radius: 10,
                startAngle: -CGFloat.pi,
                endAngle: CGFloat.pi,
                clockwise: false
            )
            context.fillPath()
            
            leader.x = point.x
            leader.y = point.y
        }
        
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
