import UIKit
import PlaygroundSupport

class Point3D {
    var x:Float = 0
    var y:Float = 0
    var z:Float = 0
    
    init(x:Float, y:Float, z:Float) {
        self.x = x
        self.y = y
        self.z = z
    }
}

class SampleView : BaseView {
    let fl:Float = 300
    var shapes = [Point3D]()
    let numShapes:Int = 100
    
    override func setup() {
        for _ in 0 ..< numShapes {
            shapes.append(
                Point3D(
                    x: Utils.randomRange(min: -1000, max: 1000),
                    y: Utils.randomRange(min: -1000, max: 1000),
                    z: Utils.randomRange(min: 0, max: 10000)
                )
            )
        }
    }
    
    override func update(context: CGContext) {
        context.translateBy(x: CGFloat(width / 2), y: CGFloat(height / 2))
        
        for i in 0 ..< numShapes {
            let shape = shapes[i]
            let perspective = fl / (fl + shape.z)
            
            context.saveGState()
            context.translateBy(x: CGFloat(shape.x * perspective), y: CGFloat(shape.y * perspective))
            context.scaleBy(x: CGFloat(perspective), y: CGFloat(perspective))
            context.fill(CGRect(x: -100, y: -100, width: 200, height: 200))
            context.restoreGState()

            shape.z += 5
            if shape.z > 10000 {
                shape.z = 0
            }
            requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
        }
    }
}


let view = SampleView(frame:CGRect(x:0, y:0, width:1024, height:1024))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
