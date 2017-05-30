import UIKit
import PlaygroundSupport

struct Gun {
    var x:Float
    var y:Float
    var angle:Float
}

class SampleView : BaseView {
    
    var gun:Gun!
    var cannonball:Particle!
    var canShoot = true
    let shotButton:UIButton = UIButton.buttonWithText("💣")
    
    
    override func setup() {
        gun = Gun(x: 100, y: height, angle: -Float.pi / 4)
        cannonball = Particle(x: gun.x, y: gun.y, speed: 15, direction: gun.angle, grav: 0.2)
        cannonball.radius = 7
        shotButton.center = CGPoint(x: width - 44, y: 44)
        shotButton.addTarget(self, action: #selector(onShootButtonTap), for: .touchUpInside)
        addSubview(shotButton)
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
        
        context.beginPath()
        context.addArc(
            center: CGPoint(x: cannonball.position.getX(), y: cannonball.position.getY()),
            radius: CGFloat(cannonball.radius),
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
    }
    
    func onShootButtonTap() {
        if canShoot {
            shoot()
        }
    }
    
    func shoot() {
        cannonball.position.setX(gun.x + cosf(gun.angle) * 40)
        cannonball.position.setY(gun.y + sinf(gun.angle) * 40)
        cannonball.velocity.setLength(15)
        cannonball.velocity.setAngle(gun.angle)
        
        canShoot = false
        updateStep()
    }
    
    func updateStep() {
        cannonball.update()
        refresh()
        
        if cannonball.position.getY() > height {
            canShoot = true
        }
        else {
            requestAnimationFrame(#selector(updateStep))
        }
    }
}

extension UIButton {
    static func buttonWithText(_ text:String) -> UIButton {
        let button = UIButton(type: .roundedRect)
        button.setTitle(text, for: .normal)
        button.frame = CGRect(
            x: 0,
            y: 0, width: 44.0,
            height: 44.0
        )
        return button
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
