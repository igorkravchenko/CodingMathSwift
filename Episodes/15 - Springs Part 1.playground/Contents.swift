import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    
    var springPoint:Vector!
    var weight:Particle!
    let k:Float = 0.1
    
    override func setup() {
        springPoint = Vector(x: width / 2, y: height / 2)
        weight = Particle(x: Float.random() * width, y: Float.random() * height, speed: 50, direction: Float.random() * Float.pi * 2)
        weight.radius = 20
        weight.friction = 0.5 + Float.random() * 0.5
    }
    
    override func update(context: CGContext) {
        let distance = springPoint.subtract(weight.position)
        let springForce = distance.multiply(k)
        
        weight.velocity.addTo(springForce)
    
        weight.update()
        
        context.beginPath()
        context.addArc(
            center: CGPoint(x: weight.position.getX(), y: weight.position.getY()),
            radius: CGFloat(weight.radius),
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        context.beginPath()
        context.addArc(
            center: CGPoint(x: springPoint.getX(), y: springPoint.getY()),
            radius: 4,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        context.beginPath()
        context.move(to: CGPoint(x: weight.position.getX(), y: weight.position.getY()))
        context.addLine(to: CGPoint(x: springPoint.getX(), y: springPoint.getY()))
        context.strokePath()
        
        requestAnimationFrame()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchPoint = touch.location(in: self)
        springPoint.setX(Float(touchPoint.x))
        springPoint.setY(Float(touchPoint.y))
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
