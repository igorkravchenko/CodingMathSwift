import UIKit
import PlaygroundSupport

struct Point : XYProvidable {
    var x:Float
    var y:Float
    
    init(x:Float, y:Float) {
        self.x = x
        self.y = y
    }
}

class SampleView : BaseView {
    
    let sun1 = Particle(x: 300, y: 200, speed: 0, direction: 0)
    let sun2 = Particle(x: 800, y: 600, speed: 0, direction: 0)
    let emitter = Point(x: 100, y: 0)
    var particles = [Particle]()
    let numParticles:Int = 100
    
    override func setup() {
        sun1.mass = 10000
        sun1.radius = 10
        sun2.mass = 20000
        sun2.radius = 20
        
        for _ in 0 ..< numParticles {
            let p = Particle(x: emitter.x, y: emitter.y, speed: Utils.randomRange(min: 7, max: 8), direction: Float.pi / 2 + Utils.randomRange(min: -0.1, max: 0.1))
            p.addGravitation(sun1)
            p.addGravitation(sun2)
            p.radius = 3
            particles.append(p)
        }
    }
    
    private let yellowColor = UIColor.yellow.cgColor
    private let blackColor = UIColor.black.cgColor
    
    override func update(context: CGContext) {
        
        draw(context: context, p: sun1, color: yellowColor)
        draw(context: context, p: sun2, color: yellowColor)
        
        for p in particles {
            p.update()
            draw(context: context, p: p, color: blackColor)
            if p.x > width ||
               p.x < 0 ||
               p.y > height ||
               p.y < 0  {
               p.setSpeed(Utils.randomRange(min: 7, max: 8))
                p.setHeading(Float.pi / 2 + Utils.randomRange(min: -0.1, max: 0.1))
            }
        }
        
        requestAnimationFrame()
    }
    
    func draw(context:CGContext, p:Particle, color:CGColor) {
        context.setFillColor(color)
        context.beginPath()
        context.addArc(
            center: CGPoint(x: p.x, y: p.y),
            radius: CGFloat(p.radius),
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
    }
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:900, height:800))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
