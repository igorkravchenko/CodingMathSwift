import UIKit
import PlaygroundSupport

struct Point : XYProvidable {
    var x:Float
    var y:Float
}

class SampleView : BaseView {
    
    var springPoint:Point!
    var weight:Particle!
    let k:Float = 0.1
    let springLength:Float = 100
    
    override func setup() {
        springPoint = Point(x: width / 2, y: height / 2)
        weight = Particle(x: Float.random() * width, y: Float.random() * height, speed: 50, direction: Float.random() * Float.pi * 2, gravity: 0.5)
        weight.radius = 20
        weight.friction = 0.95
    }
    
    override func update(context: CGContext) {
        
        let dx = springPoint.x - weight.x
        let dy = springPoint.y - weight.y
        let distance = sqrt(dx * dx + dy * dy)
        let springForce = (distance - springLength) * k
        let ax = dx / distance * springForce
        let ay = dy / distance * springForce
        
        weight.vx += ax
        weight.vy += ay
        
        weight.update()
        
        context.beginPath()
        context.addArc(
            center: CGPoint(x: weight.x, y: weight.y),
            radius: CGFloat(weight.radius),
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        context.beginPath()
        context.addArc(
            center: CGPoint(x: springPoint.x, y: springPoint.y),
            radius: 4,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        context.beginPath()
        context.move(to: CGPoint(x: weight.x, y: weight.y))
        context.addLine(to: CGPoint(x: springPoint.x, y: springPoint.y))
        context.strokePath()
        
        requestAnimationFrame()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchPoint = touch.location(in: self)
        springPoint.x = Float(touchPoint.x)
        springPoint.y = Float(touchPoint.y)
    }
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
