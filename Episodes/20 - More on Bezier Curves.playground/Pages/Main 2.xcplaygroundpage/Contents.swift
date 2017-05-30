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
    var points = [Point]()
    let numPoints:Int = 10
    
    override func setup() {
        for _ in 0 ..< numPoints {
            let p = Point(x: Float.random() * width, y: Float.random() * height)
            points.append(p)
        }
        
        setNeedsDisplay()
    }
    
    let lightGrayColor = UIColor.lightGray.cgColor
    let blackColor = UIColor.black.cgColor
    
    override func update(context: CGContext) {
        for p in points {
            context.beginPath()
            context.addArc(
                center: p.cgPoint,
                radius: 3,
                startAngle: -CGFloat.pi,
                endAngle: CGFloat.pi,
                clockwise: false
            )
            context.fillPath()
        }
        
        context.setStrokeColor(lightGrayColor)
        context.beginPath()
        context.move(to: points[0].cgPoint)
        var i:Int = 1
        while i < numPoints {
            context.addLine(to: points[i].cgPoint)
            i += 1
        }
        context.strokePath()
        context.setStrokeColor(blackColor)
        
        context.beginPath()
        Utils.multicurve(points: points, context: context)
        context.strokePath()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
