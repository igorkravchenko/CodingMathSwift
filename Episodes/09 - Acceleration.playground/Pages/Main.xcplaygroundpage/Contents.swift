import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    
    var p:Particle!
    let accel = Vector(x: 0.1, y: 0.1)
    
    override func setup() {
        p = Particle(x: 100, y: height, speed: 10, direction: -Float.pi / 2)
    }
    
    override func update(context: CGContext) {
        
        context.addArc(
            center: CGPoint(x: p.position.getX(), y: p.position.getY()),
            radius: 10,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        
        context.fillPath()
        
        p.accelerate(accel)
        p.update()
        
        requestAnimationFrame()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:500))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
