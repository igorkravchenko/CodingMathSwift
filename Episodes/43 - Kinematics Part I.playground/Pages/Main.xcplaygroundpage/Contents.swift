import UIKit
import PlaygroundSupport

class Point : XYProvidable {
    var x:Float
    var y:Float
    
    init(x:Float = 0, y:Float = 0) {
        self.x = x
        self.y = y
    }
}

extension Point {
    var cgPoint:CGPoint {
        return CGPoint(x: x, y: y)
    }
}

extension UIColor {
    convenience init(color24:Int) {
        let r = color24 >> 16
        let g = color24 >> 8 & 0xFF
        let b = color24 & 0xFF
        self.init(red:CGFloat(r) / 0xFF, green:CGFloat(g) / 0xFF, blue:CGFloat(b) / 0xFF, alpha: 1)
    }
}

class SampleView : BaseView {

    var arm:Arm!
    var angle:Float = 0
    var arm2:Arm!
    var arm3:Arm!
    
    override func setup() {
        arm = Arm(x: width / 2, y: height / 2, length: 100, angle: 0)
        arm2 = Arm(x: arm.getEndX(), y: arm.getEndY(), length: 100, angle: 1.3)
        arm3 = Arm(x: arm2.getEndX(), y: arm2.getEndY(), length: 100, angle: 1.3)
        arm2.parent = arm
        arm3.parent = arm2
    }
    
    override func update(context: CGContext) {
        arm.angle = sin(angle) * 1.2
        arm2.angle = cos(angle * 0.5) * 0.92
        arm3.angle = sin(angle * 1.5) * 1.34
        arm2.x = arm.getEndX()
        arm2.y = arm.getEndY()
        arm3.x = arm2.getEndX()
        arm3.y = arm2.getEndY()
        angle += 0.05
        arm.render(context: context)
        arm2.render(context: context)
        arm3.render(context: context)
        requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true

