import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    
    struct Circle : CircleProvidable {
        var x:Float
        var y:Float
        var radius:Float
    }
    
    
    var circle:Circle!
    var x:Float = 0
    var y:Float = 0
    
    override func setup() {
        circle = Circle(x: Float.random() * width, y: Float.random() * height, radius: 50 + Float.random() * 100)
        requestAnimationFrame()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        let touchPoint = touch.location(in: self)
        x = Float(touchPoint.x)
        y = Float(touchPoint.y)
        
        requestAnimationFrame()
    }
    
    private let redColor = UIColor(red: 0xFF / 0xFF, green: 0x66 / 0xFF, blue: 0x66 / 0xFF, alpha: 1).cgColor
    private let grayColor = UIColor(red: 0x99 / 0xFF, green: 0x99 / 0xFF, blue: 0x99 / 0xFF, alpha: 1).cgColor
    
    override func update(context: CGContext) {
        
        if Utils.circlePointCollision(x: x, y: y, circle: circle) {
            context.setFillColor(redColor)
        }
        else {
            context.setFillColor(grayColor)
        }
        
        context.beginPath()
        context.addArc(
            center: CGPoint(x: circle.x, y: circle.y),
            radius: CGFloat(circle.radius),
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
