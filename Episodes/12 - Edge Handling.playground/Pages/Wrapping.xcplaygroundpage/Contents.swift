import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    
    var p:Particle!
    
    override func setup() {
        p = Particle(x: width / 2, y: height / 2, speed: 3, direction: Float.random() * Float.pi * 2)
        p.radius = 30
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
        
        if (p.position.getX() - p.radius > width) {
            p.position.setX(-p.radius)
        }
        
        if (p.position.getX() + p.radius < 0) {
            p.position.setX(width + p.radius)
        }
        
        if (p.position.getY() - p.radius > height) {
            p.position.setY(-p.radius)
        }
        
        if (p.position.getY() + p.radius < 0) {
            p.position.setY(height + p.radius)
        }
        
        requestAnimationFrame()
    }
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:500, height:500))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
