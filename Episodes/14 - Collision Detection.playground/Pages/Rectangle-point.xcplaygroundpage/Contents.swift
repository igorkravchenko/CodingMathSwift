import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    
    struct Rectangle : RectangleProvidable {
        var x:Float
        var y:Float
        var width:Float
        var height:Float
    }
    
    
    var rect:Rectangle = Rectangle(x: 300, y: 200, width: -200, height: -100)
    var x:Float = 0
    var y:Float = 0
    
    override func setup() {
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
        
        if Utils.pointInRectCollision(x: x, y: y, rect: rect) {
            context.setFillColor(redColor)
        }
        else {
            context.setFillColor(grayColor)
        }
        
        context.beginPath()
        context.addRect(CGRect(x: rect.x, y: rect.y, width: rect.width, height: rect.height))
        context.fillPath()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
