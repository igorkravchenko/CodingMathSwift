import UIKit
import PlaygroundSupport

class Point : XYProvidable {
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
    override func update(context: CGContext) {
        context.translateBy(x: CGFloat(width / 2), y: CGFloat(height / 2))
        let p0 = Point (
            x: 0,
            y: -321
        )
        let p1 = Point (
            x: 278,
            y: 160
        )
        let p2 = Point (
            x: -278,
            y: 160
        )
    
        sierpinski(context: context, p0: p0, p1: p1, p2: p2, limit: 6)
    }
    
    func sierpinski(context:CGContext, p0:Point, p1:Point, p2:Point, limit:Int) {
        if limit > 0 {
            let pA = Point(
                x: (p0.x + p1.x) / 2,
                y: (p0.y + p1.y) / 2
            )
            let pB = Point(
                x: (p1.x + p2.x) / 2,
                y: (p1.y + p2.y) / 2
            )
            let pC = Point(
                x: (p2.x + p0.x) / 2,
                y: (p2.y + p0.y) / 2
            )
            sierpinski(
                context: context, p0: p0, p1: pA, p2: pC, limit: limit - 1
            )
            sierpinski(
                context: context, p0: pA, p1: p1, p2: pB, limit: limit - 1
            )
            sierpinski(
                context: context, p0: pC, p1: pB, p2: p2, limit: limit - 1
            )
        }
        else {
            drawTrainagle(context: context, p0: p0, p1: p1, p2: p2)
        }
    }
    
    func drawTrainagle(context:CGContext, p0:Point, p1:Point, p2:Point) {
        context.beginPath()
        context.move(to: p0.cgPoint)
        context.addLine(to: p1.cgPoint)
        context.addLine(to: p2.cgPoint)
        context.fillPath()
        
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
