import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    
    var particleA:Particle!
    var particleB:Particle!
    var particleC:Particle!

    let k:Float = 0.01
    let separation:Float = 100
    
    override func setup() {
        particleA = Particle(
            x: Utils.randomRange(min: 0, max: width),
            y: Utils.randomRange(min: 0, max: height),
            speed: Utils.randomRange(min: 0, max: 50),
            direction: Utils.randomRange(min: 0, max: Float.pi * 2)
        )
        
        particleB = Particle(
            x: Utils.randomRange(min: 0, max: width),
            y: Utils.randomRange(min: 0, max: height),
            speed: Utils.randomRange(min: 0, max: 50),
            direction: Utils.randomRange(min: 0, max: Float.pi * 2)
        )
        
        particleC = Particle(
            x: Utils.randomRange(min: 0, max: width),
            y: Utils.randomRange(min: 0, max: height),
            speed: Utils.randomRange(min: 0, max: 50),
            direction: Utils.randomRange(min: 0, max: Float.pi * 2)
        )
        
        particleA.friction = 0.9
        particleA.radius = 20
        
        particleB.friction = 0.9
        particleB.radius = 20
        
        particleC.friction = 0.9
        particleC.radius = 20
    }
    
    override func update(context: CGContext) {
        
        spring(p0: particleA, p1: particleB, separation: separation)
        spring(p0: particleB, p1: particleC, separation: separation)
        spring(p0: particleC, p1: particleA, separation: separation)
        
        particleA.update()
        particleB.update()
        particleC.update()
        
        context.beginPath()
        context.addArc(
            center: CGPoint(x: particleA.position.getX(), y: particleA.position.getY()),
            radius: CGFloat(particleA.radius),
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        context.beginPath()
        context.addArc(
            center: CGPoint(x: particleB.position.getX(), y: particleB.position.getY()),
            radius: CGFloat(particleB.radius),
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        context.beginPath()
        context.addArc(
            center: CGPoint(x: particleC.position.getX(), y: particleC.position.getY()),
            radius: CGFloat(particleC.radius),
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        context.beginPath()
        context.move(to: CGPoint(x: particleA.position.getX(), y: particleA.position.getY()))
        context.addLine(to: CGPoint(x: particleB.position.getX(), y: particleB.position.getY()))
        context.addLine(to: CGPoint(x: particleC.position.getX(), y: particleC.position.getY()))
        context.addLine(to: CGPoint(x: particleA.position.getX(), y: particleA.position.getY()))
        
        context.strokePath()
        
        requestAnimationFrame()
    }
    
    func spring(p0:Particle, p1:Particle, separation:Float) {
        var distance = p0.position.subtract(p1.position)
        distance.setLength(distance.getLength() - separation)
        let springForce = distance.multiply(k)
        
        p1.velocity.addTo(springForce)
        p0.velocity.subtractFrom(springForce)
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let _ = touch.location(in: self)
        
    }
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
