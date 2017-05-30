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
        context.addArc(
            center: CGPoint(x: p0.x, y: p0.y),
            radius: 4,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        context.beginPath()
        context.addArc(
            center: CGPoint(x: p1.x, y: p1.y),
            radius: 4,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        context.beginPath()
        context.addArc(
            center: CGPoint(x: p2.x, y: p2.y),
            radius: 4,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        context.beginPath()
        context.addArc(
            center: CGPoint(x: p3.x, y: p3.y),
            radius: 4,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        context.beginPath()
        context.move(to: CGPoint(x: p0.x, y: p0.y))
        context.addCurve(to: p3.cgPoint, control1: p1.cgPoint, control2: p2.cgPoint)
        context.strokePath()
        
        var pFinal = Point() as XYAssignable
        
        var t:Float = 0
        while t <= 1 {
            Utils.cubicBezier(p0: p0, p1: p1, p2: p2, p3: p3, t: t, pFinal:&pFinal)
            t += 0.01
            context.beginPath()
            context.addArc(
                center: CGPoint(x: pFinal.x, y: pFinal.y),
                radius: 10,
                startAngle: -CGFloat.pi,
                endAngle: CGFloat.pi,
                clockwise: false
            )
            context.strokePath()
        }
    }
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
