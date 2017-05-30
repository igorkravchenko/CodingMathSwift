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
   
    let p0 = Point(x: 100, y: 100)
    let p1 = Point(x: 500, y: 500)
    let p2 = Point(x: 600, y: 50)
    let p3 = Point(x: 80, y: 600)
    
    override func update(context: CGContext) {
        context.beginPath()
        context.move(to: p0.cgPoint)
        context.addLine(to: p1.cgPoint)
        context.move(to: p2.cgPoint)
        context.addLine(to: p3.cgPoint)
        context.strokePath()
        
        let intersect = lineIntersect(p0: p0, p1: p1, p2: p2, p3: p3)
        context.beginPath()
        context.addArc(
            center: CGPoint(x: intersect.x, y: intersect.y),
            radius: 20,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false)
        context.strokePath()
        
    }
    
    func lineIntersect(p0:XYProvidable, p1:XYProvidable, p2:XYProvidable, p3:XYProvidable) -> XYProvidable {
        let A1 = p1.y - p0.y
        let B1 = p0.x - p1.x
        let C1 = A1 * p0.x + B1 * p0.y
        let A2 = p3.y - p2.y
        let B2 = p2.x - p3.x
        let C2 = A2 * p2.x + B2 * p2.y
        let denominator = A1 * B2 - A2 * B1
        return Point(
            x: (B2 * C1 - B1 * C2) / denominator,
            y: (A1 * C2 - A2 * C1) / denominator
        )
    }
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
