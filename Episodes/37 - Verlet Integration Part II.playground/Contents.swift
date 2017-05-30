import UIKit
import PlaygroundSupport

class Point : XYProvidable {
    var x:Float
    var y:Float
    var oldx:Float
    var oldy:Float
    
    init(x:Float = 0, y:Float = 0, oldx:Float = 0, oldy:Float = 0) {
        self.x = x
        self.y = y
        self.oldx = oldx
        self.oldy = oldy
    }
}

extension Point {
    var cgPoint:CGPoint {
        return CGPoint(x: x, y: y)
    }
}

struct Stick {
    let p0:Point
    let p1:Point
    let length:Float
}


class SampleView : BaseView {
    let points = [
        Point(
            x: 100,
            y: 100,
            oldx: 85,
            oldy: 95
        ),
        Point(
            x: 200,
            y: 100,
            oldx: 200,
            oldy: 100
        ),
        Point(
            x: 200,
            y: 200,
            oldx: 200,
            oldy: 200
        ),
        
        Point(
            x: 100,
            y: 200,
            oldx: 100,
            oldy: 200
        )
    ]
    
    var sticks = [Stick]()
    
    let bounce:Float = 0.9
    let gravity:Float = 0.5
    let friction:Float = 0.999
    
    override func setup() {
        sticks += [
            Stick(
                p0: points[0],
                p1: points[1],
                length: distance(p0: points[0], p1: points[1])
            ),
            Stick(
                p0: points[1],
                p1: points[2],
                length: distance(p0: points[1], p1: points[2])
            ),
            Stick(
                p0: points[2],
                p1: points[3],
                length: distance(p0: points[2], p1: points[3])
            ),
            Stick(
                p0: points[3],
                p1: points[0],
                length: distance(p0: points[3], p1: points[0])
            ),
            Stick(
                p0: points[0],
                p1: points[2],
                length: distance(p0: points[0], p1: points[2])
            )
        ]
        
    }
    
    func distance(p0:Point, p1:Point) -> Float {
        let dx = p1.x - p0.x
        let dy = p1.y - p0.y
        return sqrt(dx * dx + dy * dy)
    }
    override func update(context: CGContext) {
        updatePoints()
        for _ in 0 ..< 3 {
            updateSticks()
            constrainPoints()
        }
        renderPoints(context: context)
        renderSticks(context: context)
        requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
    }
    
    func updatePoints() {
        for p in points {
            let vx = (p.x - p.oldx) * friction
            let vy = (p.y - p.oldy) * friction
            p.oldx = p.x
            p.oldy = p.y
            p.x += vx
            p.y += vy
            p.y += gravity
        }
    }
    
    func constrainPoints() {
        for p in points {
            let vx = (p.x - p.oldx) * friction
            let vy = (p.y - p.oldy) * friction
            
            if p.x > width {
                p.x = width
                p.oldx = p.x + vx * bounce
            }
            else if p.x < 0 {
                p.x = 0
                p.oldx = p.x + vx * bounce
            }
            if p.y > height {
                p.y = height
                p.oldy = p.y + vy * bounce
            }
            else if p.y < 0 {
                p.y = 0
                p.oldy = p.y + vy * bounce
            }
        }
    }

    
    func updateSticks() {
        for s in sticks {
            let dx = s.p1.x - s.p0.x
            let dy = s.p1.y - s.p0.y
            let distance = sqrt(dx * dx + dy * dy)
            let difference = s.length - distance
            let percent = difference / distance / 2
            let offsetX = dx * percent
            let offsetY = dy * percent
            
            s.p0.x -= offsetX
            s.p0.y -= offsetY
            s.p1.x += offsetX
            s.p1.y += offsetY
        }
    }
    
    func renderPoints(context:CGContext) {
        for p in points {
            context.beginPath()
            context.addArc(center: p.cgPoint, radius: 5, startAngle: -CGFloat.pi, endAngle: CGFloat.pi, clockwise: false)
            context.fillPath()
        }
    }
    
    func renderSticks(context:CGContext) {
        context.beginPath()
        for s in sticks {
            context.move(to: s.p0.cgPoint)
            context.addLine(to: s.p1.cgPoint)
        }
        context.strokePath()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
