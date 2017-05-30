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
        let p0 = Point(
            x: 100,
            y: height * 0.75
        )
        let p1 = Point(
            x: width - 100,
            y: height * 0.75
        )
        koch(context: context, p0: p0, p1: p1, limit: 4)
    }
    
    func koch(context:CGContext, p0:Point, p1:Point, limit:Int) {
        let dx = p1.x - p0.x
        let dy = p1.y - p0.y
        let dist = sqrt(dx * dx + dy * dy)
        let unit = dist / 3
        let angle = atan2(dy, dx)
        let pA = Point(
            x: p0.x + dx / 3,
            y: p0.y + dy / 3
        )
        let pC = Point(
            x: p1.x - dx / 3,
            y: p1.y - dy / 3
        )
        let pB = Point(
            x: pA.x + cos(angle - Float.pi / 3) * unit,
            y: pA.y + sin(angle - Float.pi / 3) * unit
        )
        
        if (limit > 0) {
            koch(context: context, p0: p0, p1: pA, limit: limit - 1)
            koch(context: context, p0: pA, p1: pB, limit: limit - 1)
            koch(context: context, p0: pB, p1: pC, limit: limit - 1)
            koch(context: context, p0: pC, p1: p1, limit: limit - 1)
        }
        else {
            context.beginPath()
            context.move(to: p0.cgPoint)
            context.addLine(to: pA.cgPoint)
            context.addLine(to: pB.cgPoint)
            context.addLine(to: pC.cgPoint)
            context.addLine(to: p1.cgPoint)
            context.strokePath()
        }
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
