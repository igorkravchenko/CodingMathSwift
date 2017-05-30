import UIKit
import PlaygroundSupport

class Point{
    var x:Float
    var y:Float
    var z:Float
    var angle:Float
    
    init(x:Float = 0, y:Float = 0, z:Float = 0, angle:Float = 0) {
        self.x = x
        self.y = y
        self.z = z
        self.angle = angle
    }
}


class SampleView : BaseView {
    
    let fl:Float = 300
    var points = [Point]()
    let numPoints:Int = 200
    let centerZ:Float = 2000
    let radius:Float = 1000
    var baseAngle:Float = 0
    var rotationSpeed:Float = 0.01
    var ypos:Float = 0
    
    override func setup() {
        for i in 0 ..< numPoints {
            let point = Point(y: 2000 - 4000 / Float(numPoints) * Float(i), angle: 0.2 * Float(i))
            point.x = cosf(point.angle + baseAngle) * radius
            point.z = centerZ + sinf(point.angle + baseAngle) * radius
            points.append(point)
        }
        
        setNeedsDisplay()
    }
    
    override func update(context: CGContext) {
        context.translateBy(x: CGFloat(width / 2), y: CGFloat(height / 2))
        baseAngle += rotationSpeed
        
        context.beginPath()
        
        for i in 0 ..< numPoints {
            let point = points[i]
            let perspective = fl / (fl + point.z)
            context.saveGState()
            context.scaleBy(x: CGFloat(perspective), y: CGFloat(perspective))
            context.translateBy(x: CGFloat(point.x), y: CGFloat(point.y))
            
            if i == 0 {
                context.move(to: CGPoint())
            }
            else {
                context.addLine(to: CGPoint())
            }
            
            context.restoreGState()
            
            point.x = cosf(point.angle + baseAngle) * radius
            point.z = centerZ + sinf(point.angle + baseAngle) * radius
        }
        context.strokePath()
        requestAnimationFrame(#selector(self.setNeedsDisplay as () -> ()))
    }
    
    override func handleTouchMoved(touchX: Float, touchY: Float) {
        rotationSpeed = (touchX - width / 2) * 0.00005
        ypos = (touchY - height / 2) * 2
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
