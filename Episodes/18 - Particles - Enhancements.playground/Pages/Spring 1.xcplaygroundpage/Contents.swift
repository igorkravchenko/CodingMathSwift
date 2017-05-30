import UIKit
import PlaygroundSupport

class Point : XYProvidable {
    var x:Float
    var y:Float
    
    init(x:Float, y:Float) {
        self.x = x
        self.y = y
    }
}

class SampleView : BaseView {
    
    var springPoint:Point!
    var springPoint2:Point!
    var weight:Particle!
    let k:Float = 0.1
    let springLength:Float = 100
    
    override func setup() {
        springPoint = Point(x: width / 2, y: height / 2)
        springPoint2 = Point(x: Utils.randomRange(min: 0, max: width), y: Utils.randomRange(min: 0, max: height))
        weight = Particle(x: Float.random() * width, y: Float.random() * height, speed: 50, direction: Float.random() * Float.pi * 2, gravity: 0.5)
        weight.radius = 20
        weight.friction = 0.95
        weight.addSpring(point: springPoint, k: k, length: springLength)
        weight.addSpring(point: springPoint2, k: k, length: springLength)
    }
    
    override func update(context: CGContext) {
        weight.update()
        
        context.beginPath()
        context.addArc(
            center: CGPoint(x: weight.x, y: weight.y),
            radius: CGFloat(weight.radius),
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        context.beginPath()
        context.addArc(
            center: CGPoint(x: springPoint.x, y: springPoint.y),
            radius: 4,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        context.beginPath()
        context.move(to: CGPoint(x: springPoint2.x, y: springPoint2.y))
        context.addLine(to: CGPoint(x: weight.x, y: weight.y))
        context.addLine(to: CGPoint(x: springPoint.x, y: springPoint.y))
        context.strokePath()
        
        requestAnimationFrame()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchPoint = touch.location(in: self)
        springPoint.x = Float(touchPoint.x)
        springPoint.y = Float(touchPoint.y)
    }
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
