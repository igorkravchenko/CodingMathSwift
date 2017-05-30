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
    let start = Point(
        x: 100,
        y: 100
    )
    let target = Point()
    let change = Point()
    var startTime:Float = 0
    let duration:Float = 1000
    
    override func setup() {
            
    }
    
    override func handleTouchUp(touchX: Float, touchY: Float) {
        target.x = touchX
        target.y = touchY
        change.x = target.x - start.x
        change.y = target.y - start.y
        startTime = Float(CACurrentMediaTime())
        
        setNeedsDisplay()
    }
    
    override func update(context: CGContext) {
        let time = (Float(CACurrentMediaTime()) - startTime) * 1000
        
        if time < duration {
            let x = easeInOutQuad(t: time, b: start.x, c: change.x, d: duration)
            let y = easeInOutQuad(t: time, b: start.y, c: change.y, d: duration)
            drawCircle(context: context, x: x, y: y)
            requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
        }
        else {
            drawCircle(
                context: context,
                x: target.x,
                y: target.y
            )
            start.x = target.x
            start.y = target.y
            print("done")
        }
    }
    
    // simple linear tweening - no easing
    // t: current time, b: beginning value, c: change in value, d: duration
    func linearTween(t:Float, b:Float, c:Float, d:Float) -> Float {
        return c * t / d + b
    }
    
    func easeInQuad(t:Float, b:Float, c:Float, d:Float) -> Float {
        var t = t
        t /= d
        return c * t * t + b;
    }
    
    // quadratic easing out - decelerating to zero velocity
    func easeOutQuad(t:Float, b:Float, c:Float, d:Float) -> Float {
        var t = t
        t /= d
        return -c  * t * (t - 2) + b
    }
    
    // quadratic easing in/out - acceleration until halfway, then deceleration
    func easeInOutQuad(t:Float, b:Float, c:Float, d:Float) -> Float {
        let t = t / d * 2
        if t < 1 {
            return c / 2 * t * t + b
        }
        return -c/2 * ((t - 1) * (t - 3) - 1) + b;
    }
    
    func drawCircle(context:CGContext, x:Float, y:Float) {
        context.beginPath()
        context.addArc(
            center: CGPoint(x: x, y: y),
            radius: 20,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
