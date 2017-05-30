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
        p0 = Point(x: Float.random() * width, y: Float.random() * height)
        p1 = Point(x: Float.random() * width, y: Float.random() * height)
        p2 = Point(x: Float.random() * width, y: Float.random() * height)
        p3 = Point(x: Float.random() * width, y: Float.random() * height)
        
        
        setNeedsDisplay()
    }
    
    let redColor = UIColor.red.cgColor

    
    override func update(context: CGContext) {
        context.beginPath()
        context.move(to: p0.cgPoint)
        context.addCurve(to: p3.cgPoint, control1: p1.cgPoint, control2: p2.cgPoint)
        context.strokePath()
        
        context.setStrokeColor(redColor)
        context.beginPath()
        Utils.multicurve(points: [p0, p1, p2, p3], context: context)
        context.strokePath()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
