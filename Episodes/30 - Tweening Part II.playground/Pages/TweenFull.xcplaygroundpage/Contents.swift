import UIKit
import PlaygroundSupport

class Ball {
    var x:Float
    var y:Float
    var alpha:Float
    
    init(x:Float = 0, y:Float = 0, alpha:Float = 1) {
        self.x = x
        self.y = y
        self.alpha = alpha
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
            tween(obj: ball, start: [ball.x, ball.y, ball.alpha], target: [900, 700, 0], duration: 1, easingFunc: easeInOutQuad) {
            
            [unowned self](b, newValues, done) in
            b.x = newValues[0]
            b.y = newValues[1]
            b.alpha = newValues[2]
            
            if done {
               self.tweenBack()
            }
            
            self.setNeedsDisplay()
        }
        
    }
    
    func tweenBack() {
        tween(obj: ball, start: [ball.x, ball.y, ball.alpha], target: [100, 100, 1], duration: 1, easingFunc: easeInOutQuad) {
            [unowned self](b, newValues, done) in
            b.x = newValues[0]
            b.y = newValues[1]
            b.alpha = newValues[2]
            self.setNeedsDisplay()
        }
    }
    
    func tween<T>(obj:T, start:[Float], target:[Float], duration:Float, easingFunc:@escaping (Float, Float, Float, Float) -> Float, render:@escaping(T, [Float], Bool) -> ()) {
        
        if start.count != target.count {
            fatalError("number of start and target values must match")
        }
        
        if (duration <= 0) {
            render(obj, target, true)
            return;
        }
        
        var changes = [Float]()
        var i:Int = 0
        while i < start.count {
            changes.append(target[i] - start[i])
            i += 1
        }
        
        let startTime = Float(CACurrentMediaTime())
        let frameRate:TimeInterval = 1 / 60
        
        func updateAnim() {
            var time = Float(CACurrentMediaTime()) - startTime
            if time < duration {
                var progress = [Float]()
                var j:Int = 0
                while j < changes.count {
                    progress.append(easingFunc(time, start[j], changes[j], duration))
                    j += 1
                }
                render(obj, progress, false)
                DispatchQueue.main.asyncAfter(deadline: .now() + frameRate) {
                    updateAnim()
                }
            }
            else {
                time = duration
                var progress = [Float]()
                var j:Int = 0
                while j < changes.count {
                    progress.append(easingFunc(time, start[j], changes[j], duration))
                    j += 1
                }
                render(obj, progress, true)
            }
        }
        
        updateAnim()
    }
    
    override func update(context: CGContext) {
        context.beginPath()
        context.setFillColor(UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(ball.alpha)).cgColor)
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
