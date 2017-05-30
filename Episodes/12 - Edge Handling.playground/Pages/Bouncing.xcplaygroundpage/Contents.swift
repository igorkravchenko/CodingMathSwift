import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    
    var p:Particle!
    
    override func setup() {
        p = Particle(x: width / 2, y: height / 2, speed: 3, direction: Float.random() * Float.pi * 2, grav: 0.1)
        p.radius = 40
        p.bounce = -0.9
    }
    
    override func update(context: CGContext) {
        p.update()
        
        context.beginPath()
        context.addArc(
            center: CGPoint(x: p.position.getX(), y: p.position.getY()),
            radius: CGFloat(p.radius),
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        
        context.fillPath()
        
        if (p.position.getX() + p.radius > width) {
            p.position.setX(width - p.radius)
            p.velocity.setX(p.velocity.getX() * p.bounce)
        }
        
        if (p.position.getX() - p.radius < 0) {
            p.position.setX(p.radius)
            p.velocity.setX(p.velocity.getX() * p.bounce)
        }
        
        if (p.position.getY() + p.radius > height) {
            p.position.setY(height - p.radius)
            p.velocity.setY(p.velocity.getY() * p.bounce)
        }
        
        if (p.position.getY() - p.radius < 0) {
            p.position.setY(p.radius)
            p.velocity.setY(p.velocity.getY() * p.bounce)
        }
        
        requestAnimationFrame()
    }
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:500, height:500))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
