import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    
    var particles = [Particle]()
    let numParticles:Int = 100
    
    override open func setup() {
        for _ in 0 ..< numParticles {
            particles.append(
                Particle(
                    x: width / 2.0,
                    y: height / 2.0,
                    speed: Float.random() * 5 + 2,
                    direction: Float.random() * Float.pi * 2,
                    grav: 0.1
                )
            )
        }
    }
    
    override open func update(context: CGContext) {
        
        print(particles.count)
        
        for p in particles {
            p.update()
            
            context.addArc(
                center: CGPoint(
                    x: p.position.getX(),
                    y: p.position.getY()
                ),
                radius: 4.0,
                startAngle: -CGFloat.pi,
                endAngle: CGFloat.pi,
                clockwise: false
            )
            
            context.fillPath()
        }
        
        removeDeadParticles()
        
        requestAnimationFrame()
    }
    
    func removeDeadParticles() {
        var i = particles.count - 1
        
        while i >= 0 {
            let p = particles[i]
            if (p.position.getX() - p.radius > width ||
                p.position.getX() + p.radius < 0 ||
                p.position.getY() - p.radius > height ||
                p.position.getY() + p.radius < 0) {
            
                particles.remove(at: i)
            }
            
            i -= 1
        }
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:400, height:400))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
