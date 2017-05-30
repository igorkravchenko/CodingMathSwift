import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    
    var sun:Particle!
    var planet:Particle!
    
    override func setup() {
        sun = Particle(x: width / 2, y: height / 2, speed: 0, direction: 0)
        planet = Particle(x: width / 2 + 200, y: height / 2, speed: 10, direction: -Float.pi / 2 )
        sun.mass = 20000
    }
    
    override func update(context: CGContext) {
        
        planet.gravitateTo(sun)
        planet.update()
        
        context.beginPath()
        context.setFillColor(red: 1, green: 1, blue: 0, alpha: 1)
        context.addArc(
            center: CGPoint(
                x: sun.x,
                y: sun.y
            ),
            radius: 20,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        context.beginPath()
        context.setFillColor(red: 0, green: 0, blue: 1, alpha: 1)
        context.addArc(
            center: CGPoint(
                x: planet.x,
                y: planet.y
            ),
            radius: 5,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        requestAnimationFrame()
    }
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:500, height:500))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
