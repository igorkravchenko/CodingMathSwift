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
    let p1 = Point(x: 500, y: 100)
    let p2 = Point(x: 100, y: 200)
    let p3 = Point(x: 500, y: 200)
    
    var clickPoint:Point?
    
    override func update(context: CGContext) {
        drawPoint(context: context, point: p0)
        drawPoint(context: context, point: p1)
        drawPoint(context: context, point: p2)
        drawPoint(context: context, point: p3)
        
        context.beginPath()
        context.move(to: p0.cgPoint)
        context.addLine(to: p1.cgPoint)
        context.move(to: p2.cgPoint)
        context.addLine(to: p3.cgPoint)
        context.strokePath()
        
        guard let intersect = segmentIntersect(p0: p0, p1: p1, p2: p2, p3: p3) else { return }
        print(intersect.x, intersect.y)
        context.beginPath()
        context.addArc(
            center: CGPoint(x: intersect.x, y: intersect.y),
            radius: 20,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false)
        context.strokePath()
        
    }
    
    func drawPoint(context:CGContext, point:Point) {
        context.beginPath()
        context.addArc(
            center: CGPoint(x: point.x, y: point.y),
            radius: 10,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false)
        context.fillPath()
    }
    
    override func handleTouchDown(touchX: Float, touchY: Float) {
        clickPoint = getClickPoint(x: touchX, y: touchY)
    }
    
    override func handleTouchMoved(touchX: Float, touchY: Float) {
        guard let clickPoint = self.clickPoint else { return }
        clickPoint.x = touchX
        clickPoint.y = touchY
        setNeedsDisplay()
    }
    
    func getClickPoint(x:Float, y:Float) -> Point? {
        let points = [p0, p1, p2, p3]
        for p in points {
            let dx = p.x - x
            let dy = p.y - y
            let dist = sqrt(dx * dx + dy * dy)
            if dist < 10 {
                return p
            }
        }
        
        return nil
    }
    
    func lineIntersect(p0:XYProvidable, p1:XYProvidable, p2:XYProvidable, p3:XYProvidable) -> XYProvidable? {
        let A1 = p1.y - p0.y
        let B1 = p0.x - p1.x
        let C1 = A1 * p0.x + B1 * p0.y
        let A2 = p3.y - p2.y
        let B2 = p2.x - p3.x
        let C2 = A2 * p2.x + B2 * p2.y
        let denominator = A1 * B2 - A2 * B1
        
        if denominator == 0 {
            return nil
        }
        
        return Point(
            x: (B2 * C1 - B1 * C2) / denominator,
            y: (A1 * C2 - A2 * C1) / denominator
        )
    }
    
    func segmentIntersect(p0:XYProvidable, p1:XYProvidable, p2:XYProvidable, p3:XYProvidable) -> XYProvidable? {
        let A1 = p1.y - p0.y
        let B1 = p0.x - p1.x
        let C1 = A1 * p0.x + B1 * p0.y
        let A2 = p3.y - p2.y
        let B2 = p2.x - p3.x
        let C2 = A2 * p2.x + B2 * p2.y
        let denominator = A1 * B2 - A2 * B1
        
        if denominator == 0 {
            return nil
        }
        
        let intersectX = (B2 * C1 - B1 * C2) / denominator
        let intersectY = (A1 * C2 - A2 * C1) / denominator
        let rx0 = (intersectX - p0.x) / (p1.x - p0.x)
        let ry0 = (intersectY - p0.y) / (p1.y - p0.y)
        let rx1 = (intersectX - p2.x) / (p3.x - p2.x)
        let ry1 = (intersectY - p2.y) / (p3.y - p2.y)
        if ((rx0 >= 0 && rx0 <= 1) || (ry0 >= 0 && ry0 <= 1)) &&
            ((rx1 >= 0 && rx1 <= 1) || (ry1 >= 0 && ry1 <= 1)) {
            return Point(x: intersectX, y: intersectY)
        }
        return nil
    }

    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
