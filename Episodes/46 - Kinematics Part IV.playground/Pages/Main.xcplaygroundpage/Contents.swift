import UIKit
import PlaygroundSupport

class Ball {
    var x:Float = 100
    var y:Float = 100
    var vx:Float = 5
    var vy:Float = 0
    var radius:Float = 20
    var gravity:Float = 0.25
    var bounce:Float = -1
    
    func update(width:Float, height:Float) {
        x += vx
        y += vy
        vy += gravity
        if x + radius > width {
            x = width - radius
            vx *= bounce
        }
        else if x < radius {
            x = radius
            vx *= bounce
        }
        if y + radius > height {
            y = height - radius
            vy *= bounce
        }
        else if y < radius {
            y = radius
            vy *= bounce
        }
    }
    
    func render(context:CGContext) {
        context.beginPath()
        context.addArc(
            center: CGPoint(x: x, y: y),
            radius: CGFloat(radius),
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
    }
    
}

class SampleView : BaseView {
    var iks1:IKSystem!
    var iks2:IKSystem!
    let ball = Ball()
    
    override func setup() {
        iks1 = IKSystem(x: 250, y: height)
        iks1.addArm(length: 240)
        iks1.addArm(length: 180)
        iks1.addArm(length: 120)
        
        iks2 = IKSystem(x: width - 250, y: height)
        iks2.addArm(length: 240)
        iks2.addArm(length: 180)
        iks2.addArm(length: 120)
    }
    
    override func update(context: CGContext) {
        ball.update(width: width, height: height)
        ball.render(context: context)

        iks1.reach(x: ball.x, y: ball.y)
        iks2.reach(x: ball.x, y: ball.y)

        iks1.render(context: context)
        iks2.render(context: context)
        requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:1200, height:800))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true

