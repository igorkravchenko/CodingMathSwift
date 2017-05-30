import UIKit
import PlaygroundSupport

class Point {
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

class SampleView : BaseView {
    var target:Point!
    var position:Point!
    let ease:Float = 0.1
    var easing = true
    
    override func setup() {
        target = Point(
            x: width,
            y: Float.random() * height
        )
        
        position = Point(
            x: 0,
            y: Float.random() * height
        )
        
        setNeedsDisplay()
    }
    
    override func update(context: CGContext) {
        context.beginPath()
        context.addArc(
            center: position.cgPoint,
            radius: 10,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        easing = easeTo(position: position, target: target, ease: ease)

        if easing {
            requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
        }
    }
    
    override func handleTouchUp(touchX: Float, touchY: Float) {
        target.x = touchX
        target.y = touchY
        if !easing {
            easing = true
            requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
        }
    }
    
    func easeTo(position:Point, target:Point, ease:Float) -> Bool {
        let dx = target.x - position.x
        let dy = target.y - position.y
        position.x += dx * ease
        position.y += dy * ease
        if abs(dx) < 0.1 && abs(dy) < 0.1 {
            position.x = target.x
            position.y = target.y
            return false
        }
        return true
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
