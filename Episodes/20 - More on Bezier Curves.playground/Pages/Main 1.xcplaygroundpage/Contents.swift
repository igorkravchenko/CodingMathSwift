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
    var cp:Point!
    
    
    let lightGrayColor = UIColor.lightGray.cgColor
    let blackColor = UIColor.black.cgColor
    
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
        
        cp = Point()
        cp.x = p1.x * 2 - (p0.x + p2.x) / 2
        cp.y = p1.y * 2 - (p0.y + p2.y) / 2
        
        requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
    }
    
    func drawPoint(_ p:Point, inContext context:CGContext) {
        context.beginPath()
        context.addArc(
            center: CGPoint(x: p.x, y: p.y),
            radius: 3,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
    }
    
    override func update(context: CGContext) {
        drawPoint(p0, inContext: context)
        drawPoint(p1, inContext: context)
        drawPoint(p2, inContext: context)
        drawPoint(cp, inContext: context)
        
        context.setStrokeColor(lightGrayColor)
        context.beginPath()
        context.move(to: p0.cgPoint)
        context.addLine(to: cp.cgPoint)
        context.addLine(to: p2.cgPoint)
        context.strokePath()
        
        context.setStrokeColor(blackColor)
        context.beginPath()
        context.move(to: p0.cgPoint)
        context.addQuadCurve(to: p2.cgPoint, control: cp.cgPoint)
        context.strokePath()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
