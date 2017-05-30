
import UIKit
import PlaygroundSupport

/*
class SampleView : BaseView {
    
    var position = Vector(x: 100, y: 100)
    var velocity = Vector(x: 0, y: 0)
    
    override open func setup() {
        velocity.setLength(3)
        velocity.setAngle(Float.pi / 6)
    }
    
    override open func update(context: CGContext) {
        
        context.addArc(
            center: CGPoint(x: position.getX(), y:position.getY()),
            radius: 10,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        
        context.fillPath()
        
        position.addTo(velocity)
        
        requestAnimationFrame()
    }
    
}
*/

/*
open class SampleView : BaseView {
    
    let p = Particle(x: 100, y: 100, speed: 3, direction: Float.pi / 6.0)
 
    override open func update(context: CGContext) {
        
        context.addArc(
            center: CGPoint(x: p.position.getX(), y: p.position.getY()),
            radius: 10,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        
        context.fillPath()
        
        p.update()
        
        requestAnimationFrame()
    }
}
*/

class SampleView : BaseView {
    
    var particles = [Particle]()
    let numParticles:Int = 100
    
    override open func setup() {
        for _ in 0 ..< numParticles {
            particles.append(
                Particle(
                    x: width / 2.0,
                    y: height / 2.0,
                    speed: Float.random() * 4 + 1,
                    direction: Float.random() * Float.pi * 2
                )
            )
        }
    }
    
    override open func update(context: CGContext) {
        
        
        for p in particles {
            p.update()
        
            context.addArc(
                center: CGPoint(x: p.position.getX(), y: p.position.getY()),
                radius: 10,
                startAngle: -CGFloat.pi,
                endAngle: CGFloat.pi,
                clockwise: false
            )
            
            context.fillPath()
        }
        
        requestAnimationFrame()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:400, height:400))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
