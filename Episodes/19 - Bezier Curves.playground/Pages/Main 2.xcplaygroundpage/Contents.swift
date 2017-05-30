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
    var maxT:Float = 0
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
        var t:Float = 0
        while t <= maxT {
            Utils.cubicBezier(p0: p0, p1: p1, p2: p2, p3: p3, t: t, pFinal: &pFinal)
            context.addLine(to: (pFinal as! Point).cgPoint)
            t += 0.01
        }
        context.strokePath()
        maxT += 0.01
        if maxT > 1 {
            maxT = 0
        }
        
        requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
