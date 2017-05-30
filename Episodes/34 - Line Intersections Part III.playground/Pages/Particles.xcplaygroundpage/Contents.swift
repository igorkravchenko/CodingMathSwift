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

extension XYProvidable {
    var cgPoint:CGPoint {
        return CGPoint(x: x, y: y)
    }
}

struct Line {
    let p0:Point
    let p1:Point
}

struct SampleParticle {
    var x:Float
    var y:Float
    var vx:Float
    var vy:Float
}

class SampleView : BaseView {
    var particle:SampleParticle!
    var lines = [Line]()
    
    override func setup() {
        particle = SampleParticle(
            x: width / 2,
            y: height / 2,
            vx: Float.random() * 10 - 5,
            vy: Float.random() * 10 - 5
        )
        
        for _ in 0 ..< 10 {
            lines.append(
                Line(
                    p0: Point(x: Float.random() * width, y: Float.random() * height),
                    p1: Point(x: Float.random() * width, y: Float.random() * height)
                )
            )
        }
    }
    
    override func update(context: CGContext) {
        drawLines(context: context)
        let p0 = Point(
            x: particle.x,
            y: particle.y
        )
        particle.x += particle.vx
        particle.y += particle.vy
        context.fill(CGRect(x: particle.x - 2, y: particle.y - 2, width: 4, height: 4))

        let p1 = Point(
            x: particle.x,
            y: particle.y
        )
        
        for i in 0 ..< lines.count {
            let p2 = lines[i].p0
            let p3 = lines[i].p1
            if let intersect = segmentIntersect(p0: p0, p1: p1, p2: p2, p3: p3) {
                context.beginPath()
                context.setStrokeColor(UIColor.red.cgColor)
                context.addArc(
                    center: intersect.cgPoint,
                    radius: 20,
                    startAngle: -CGFloat.pi,
                    endAngle: CGFloat.pi,
                    clockwise: false
                )
                context.strokePath()
                return
            }
        }
        
        requestAnimationFrame(#selector(setNeedsDisplay as  () -> ()))
    }
    
    func drawLines(context:CGContext) {
        context.beginPath()
        for i in 0 ..< lines.count {
            context.move(to: lines[i].p0.cgPoint)
            context.addLine(to: lines[i].p1.cgPoint)
        }
        context.strokePath()
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
