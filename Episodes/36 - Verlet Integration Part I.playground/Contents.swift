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


class SampleView : BaseView {
    let points = [
            Point(
                x: 100,
                y: 100,
                oldx: 95,
                oldy: 95
            )
    ]
    
    let bounce:Float = 0.9
    let gravity:Float = 0.5
    let friction:Float = 0.999
    
    override func update(context: CGContext) {
        updatePoints()
        renderPoints(context: context)
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
    
    func renderPoints(context:CGContext) {
        for p in points {
            context.beginPath()
            context.addArc(center: p.cgPoint, radius: 5, startAngle: -CGFloat.pi, endAngle: CGFloat.pi, clockwise: false)
            context.fillPath()
        }
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
