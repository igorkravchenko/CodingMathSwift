import UIKit
import PlaygroundSupport

class Ball {
    var x:Float
    var y:Float
    
    init(x:Float = 0, y:Float = 0) {
        self.x = x
        self.y = y
    }
}

extension Ball {
    var xyCGPoint:CGPoint {
        return CGPoint(x: x, y: y)
    }
}

class SampleView : BaseView {
    let ball = Ball(x: 100, y: 100)
    
    
    override func setup() {
        tweenX(obj: ball, targetX: 800, duration: 1, easingFunc: easeInOutQuad)
    }
    
    func tweenX(obj:Ball, targetX:Float, duration:Float, easingFunc:@escaping (Float, Float, Float, Float) -> Float) {
        let startX = obj.x
        let changeX = targetX - startX
        let startTime = Float(CACurrentMediaTime())
        
        let frameRate:TimeInterval = 1 / 60
        
        func updateAnim() {
            var time = Float(CACurrentMediaTime()) - startTime
            
            if time < duration {
                obj.x = easingFunc(time, startX, changeX, duration)
                DispatchQueue.main.asyncAfter(deadline: .now() + frameRate) {
                    updateAnim()
                }
            }
            else {
                time = duration
                obj.x = easingFunc(time, startX, changeX, duration)
            }
            setNeedsDisplay()
        }
        
        updateAnim()
    }
    
    override func update(context: CGContext) {
        context.beginPath()
        context.addArc(
            center: ball.xyCGPoint,
            radius: 20,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
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

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
