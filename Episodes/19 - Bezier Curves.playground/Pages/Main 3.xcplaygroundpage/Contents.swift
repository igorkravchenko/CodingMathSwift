import UIKit
import PlaygroundSupport

struct Point : XYAssignable {
    var x:Float = 0
    var y:Float = 0
}

extension Point {
    var cgPoint:CGPoint {
        return CGPoint(x: x, y: y)
    }
}

class SampleView : BaseView {
    
    var p0:Point!
    var p1:Point!
    var p2:Point!
    var p3:Point!
    var t:Float = 0
    var direction:Float = 0.01
    var pFinal = Point() as XYAssignable
    
    override func setup() {
        p0 = Point(
            x: Utils.randomRange(min: 0, max: width),
            y: Utils.randomRange(min: 0, max: height)
        )
        p1 = Point(
            x: Utils.randomRange(min: 0, max: width),
            y: Utils.randomRange(min: 0, max: height)
        )
        p2 = Point(
            x: Utils.randomRange(min: 0, max: width),
            y: Utils.randomRange(min: 0, max: height)
        )
        p3 = Point(
            x: Utils.randomRange(min: 0, max: width),
            y: Utils.randomRange(min: 0, max: height)
        )
    }
    
    override func update(context: CGContext) {
        context.beginPath()
        context.move(to: p0.cgPoint)
        context.addCurve(to: p3.cgPoint, control1: p1.cgPoint, control2: p2.cgPoint)
        context.strokePath()
        
        Utils.cubicBezier(p0: p0, p1: p1, p2: p2, p3: p3, t: t, pFinal: &pFinal)
        context.beginPath()
        context.addArc(
            center: (pFinal as! Point).cgPoint,
            radius: 10,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        t += direction
        if t > 1 || t < 0 {
            direction = -direction
        }
        
        requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
