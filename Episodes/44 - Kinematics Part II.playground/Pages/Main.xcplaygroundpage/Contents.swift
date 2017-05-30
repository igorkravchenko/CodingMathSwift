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
    var leg0:FKSystem!
    var leg1:FKSystem!
    
    override func setup() {
        leg0 = FKSystem(x: width / 2, y: height / 2)
        leg1 = FKSystem(x: width / 2, y: height / 2)
        leg1.phase = Float.pi
        leg0.addArm(length: 200, centerAngle: Float.pi / 2, rotationRange: Float.pi / 4, phaseOffset: 0)
        leg0.addArm(length: 180, centerAngle: 0.87, rotationRange: 0.87, phaseOffset: -1.5)
        leg1.addArm(length: 200, centerAngle: Float.pi / 2, rotationRange: Float.pi / 4, phaseOffset: 0)
        leg1.addArm(length: 180, centerAngle: 0.87, rotationRange: 0.87, phaseOffset: -1.5)
    }
    
    override func update(context: CGContext) {
        leg0.update()
        leg1.update()
        leg0.render(context: context)
        leg1.render(context: context)
        requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true

