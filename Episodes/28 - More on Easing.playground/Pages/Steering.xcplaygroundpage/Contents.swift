import UIKit
import PlaygroundSupport


class SampleView : BaseView {
    var angle:Float = 0
    var wheel:UIImage!
    var wheelWidth:Float = 0
    var wheelHeight:Float = 0
    var targetAngle:Float = 0
    let ease:Float = 0.05
    
    override func setup() {
        wheel = UIImage(named: "wheel")
        guard let cgImage = wheel.cgImage else {
            fatalError()
        }
        wheelWidth = Float(cgImage.width)
        wheelHeight = Float(cgImage.height)
        setNeedsDisplay()
    }
    
    override func update(context: CGContext) {
        angle += (targetAngle - angle) * ease
        
        context.saveGState()
        context.translateBy(x: CGFloat(width / 2), y: CGFloat(height / 2))
        context.rotate(by: CGFloat(angle))
        
        wheel.draw(at: CGPoint(x: -wheelWidth / 2, y: -wheelHeight / 2))
        
        context.restoreGState()
        requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
    }
    
    override func handleTouchMoved(touchX: Float, touchY: Float) {
        targetAngle = Utils.map(value: touchX, sourceMin: 0, sourceMax: width, destMin: -Float.pi, destMax: Float.pi)
    }
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
