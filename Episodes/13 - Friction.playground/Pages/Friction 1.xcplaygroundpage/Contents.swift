import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    
    var p:Particle!
    var friction:Vector!
    
    override func setup() {
        p = Particle(x: width / 2, y: height / 2, speed: 10, direction: Float.random() * Float.pi * 2)
        friction = Vector(x: 0.15, y: 0)
        p.radius = 10
        
    }
    
    override func update(context: CGContext) {
        p.update()
    
        friction.setAngle(p.velocity.getAngle())
        
        if p.velocity.getLength() > friction.getLength() {
            p.velocity.subtractFrom(friction)
        }
        else {
            p.velocity.setLength(0)
        }
        
        
        context.beginPath()
        context.addArc(
            center: CGPoint(x: p.position.getX(), y: p.position.getY()),
            radius: CGFloat(p.radius),
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        
        context.fillPath()
        
        requestAnimationFrame()
    }
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
