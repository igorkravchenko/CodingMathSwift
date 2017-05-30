import UIKit
import PlaygroundSupport

struct Gun {
    var x:Float
    var y:Float
    var angle:Float
}

class SampleView : BaseView {
    
    var gun:Gun!
    
    override func setup() {
        gun = Gun(x: 100, y: height, angle: -Float.pi / 4)
    }
    
    override func update(context: CGContext) {
        draw(context: context)
    }
    
    override func handleTouchDown(touchX: Float, touchY: Float) {
        aimGun(touchX: touchX, touchY: touchY)
    }
    
    override func handleTouchMoved(touchX: Float, touchY: Float) {
        aimGun(touchX: touchX, touchY: touchY)
    }
    
    func aimGun(touchX:Float, touchY:Float) {
        gun.angle = Utils.clamp(value:atan2f(touchY - gun.y,  touchX - gun.x), min: -Float.pi / 2, max: -0.3)
        requestAnimationFrame()
    }
    
    func draw(context:CGContext) {
        context.beginPath()
        context.addArc(
            center: CGPoint(x: gun.x, y: gun.y),
            radius: 24,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        
        )
        context.fillPath()
        
        context.saveGState()
        context.translateBy(x: CGFloat(gun.x), y: CGFloat(gun.y))
        context.rotate(by: CGFloat(gun.angle))
        context.fill(CGRect(x: 0, y: -8, width: 40, height: 16))
        context.restoreGState()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
