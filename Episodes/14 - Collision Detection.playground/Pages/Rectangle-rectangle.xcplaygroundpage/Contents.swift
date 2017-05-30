import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    
    struct Rectangle : RectangleProvidable {
        var x:Float
        var y:Float
        var width:Float
        var height:Float
    }
    
    
    let rect0:Rectangle = Rectangle(x: 200, y: 200, width: 200, height: 100)
    var rect1:Rectangle = Rectangle(x: 0, y: 0, width: 100, height: 200)
    
    
    override func setup() {
        requestAnimationFrame()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        let touchPoint = touch.location(in: self)
        rect1.x = Float(touchPoint.x) - 50
        rect1.y = Float(touchPoint.y) - 100
        
        requestAnimationFrame()
    }
    
    private let redColor = UIColor(red: 0xFF / 0xFF, green: 0x66 / 0xFF, blue: 0x66 / 0xFF, alpha: 1).cgColor
    private let grayColor = UIColor(red: 0x99 / 0xFF, green: 0x99 / 0xFF, blue: 0x99 / 0xFF, alpha: 1).cgColor
    
    override func update(context: CGContext) {
        
        if Utils.rectInersect(r0: rect0, r1: rect1) {
            context.setFillColor(redColor)
        }
        else {
            context.setFillColor(grayColor)
        }
        
        context.beginPath()
        context.addRect(CGRect(x: rect0.x, y: rect0.y, width: rect0.width, height: rect0.height))
        context.fillPath()
        
        context.beginPath()
        context.addRect(CGRect(x: rect1.x, y: rect1.y, width: rect1.width, height: rect1.height))
        context.fillPath()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
