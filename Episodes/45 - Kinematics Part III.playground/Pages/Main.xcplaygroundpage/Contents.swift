import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    var iks:IKSystem!
    
    override func setup() {
        iks = IKSystem(x: width / 2, y: height / 2)
        for _ in 0 ..< 20 {
            iks.addArm(length: 30)
        }
        
        
    }
    
    override func update(context: CGContext) {
        iks.render(context: context)
    }
    
    override func handleTouchMoved(touchX: Float, touchY: Float) {
        iks.drag(x: touchX, y: touchY)
        setNeedsDisplay()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true

