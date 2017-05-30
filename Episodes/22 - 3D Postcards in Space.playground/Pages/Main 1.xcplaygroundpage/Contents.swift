import UIKit
import PlaygroundSupport

struct Point3D {
    var x:Float = 0
    var y:Float = 0
    var z:Float = 0
}

class SampleView : BaseView {
    let fl:Float = 300
    let shapePos = Point3D(x: 500, y: 300, z: 1000)
    
    
    override func setup() {
        
    }
    
    override func update(context: CGContext) {
        context.translateBy(x: CGFloat(width / 2), y: CGFloat(height / 2))
        let perspective = fl / (fl + shapePos.z)
        context.translateBy(x: CGFloat(shapePos.x * perspective), y: CGFloat(shapePos.y * perspective))
        context.scaleBy(x: CGFloat(perspective), y: CGFloat(perspective))
        context.fill(CGRect(x: -100, y: -100, width: 200, height: 200))
        
    }
}


let view = SampleView(frame:CGRect(x:0, y:0, width:1024, height:1024))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
