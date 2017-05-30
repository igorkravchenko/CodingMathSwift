import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    
    var particles = [Particle]()
    let numParticles:Int = 100
    
    override open func setup() {
        for _ in 0 ..< numParticles {
            let p = Particle(
                x: width / 2.0,
                y: height,
                speed: Float.random() * 8 + 5,
                direction: -Float.pi / 2 + (Float.random() * 0.2 - 0.1),
                grav: 0.1
            )
            
            p.radius = Float.random() * 10 + 2
            
            particles.append(p)
        }
    }
    
    override open func update(context: CGContext) {
        
        for p in particles {
            p.update()
            
            context.addArc(
                center: CGPoint(
                    x: p.position.getX(),
                    y: p.position.getY()
                ),
                radius: CGFloat(p.radius),
                startAngle: -CGFloat.pi,
                endAngle: CGFloat.pi,
                clockwise: false
            )
            
            context.fillPath()
            
            if (p.position.getY() - p.radius > height) {
                p.position.setX(width / 2)
                p.position.setY(height)
                p.velocity.setLength(Float.random() * 8 + 5)
                p.velocity.setAngle(-Float.pi / 2 + (Float.random() * 0.2 - 0.1))
            }
        }
        
        requestAnimationFrame()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:400, height:400))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
