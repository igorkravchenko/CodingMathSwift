import UIKit
import PlaygroundSupport

struct Gun {
    var x:Float
    var y:Float
    var angle:Float
}

struct Target : CircleProvidable {
    var x:Float = 0
    var y:Float = 0
    var radius:Float = 0
}

class SampleView : BaseView {
    
    var gun:Gun!
    var cannonball:Particle!
    var isShooting = false
    let shotButton:UIButton = UIButton.buttonWithText("💣")
    var forceAngle:Float = 0
    var forceSpeed:Float = 0.1
    var rawForce:Float = 0
    var target = Target()
    
    override func setup() {
        gun = Gun(x: 100, y: height, angle: -Float.pi / 4)
        cannonball = Particle(x: gun.x, y: gun.y, speed: 15, direction: gun.angle, gravity: 0.2)
        cannonball.radius = 7
        shotButton.center = CGPoint(x: width - 44, y: 44)
        shotButton.addTarget(self, action: #selector(onShootButtonTap), for: .touchDown)
        addSubview(shotButton)
        setTarget()
        updateStep()
    }
    
    func setTarget() {
        target.x = Utils.randomRange(min: 200, max: width)
        target.y = height
        target.radius = Utils.randomRange(min: 10, max: 40)
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
    }
    
    let lightColor = UIColor(red: 0xC0 / 0xFF, green: 0xC0 / 0xFF, blue: 0xC0 / 0xFF, alpha: 1).cgColor
    let darkColor = UIColor(red: 0x6 / 0xFF, green: 0x6 / 0xFF, blue: 0x6 / 0xFF, alpha: 1).cgColor
    let blackColor = UIColor.black.cgColor
    let redColor = UIColor.red.cgColor
    
    func draw(context:CGContext) {
        context.setFillColor(lightColor)
        context.fill(CGRect(x: 10, y: height - 10, width: 20, height: -100))
        
        context.setFillColor(darkColor)
        context.fill(CGRect(x: 10, y: height - 10, width: 20, height: Utils.map(value: rawForce, sourceMin: -1, sourceMax: 1, destMin: 0, destMax: -100)))
        
        context.setFillColor(blackColor)
        
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
            center: CGPoint(x: cannonball.x, y: cannonball.y),
            radius: CGFloat(cannonball.radius),
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        context.setFillColor(redColor)
        context.beginPath()
        context.addArc(
            center: CGPoint(x: target.x, y: target.y),
            radius: CGFloat(target.radius),
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
    }
    
    func onShootButtonTap() {
        if !isShooting {
            shoot()
        }
    }
    
    func shoot() {
        let force = Utils.map(value: rawForce, sourceMin: -1, sourceMax: 1, destMin: 2, destMax: 20)
        cannonball.x = gun.x + cosf(gun.angle) * 40
        cannonball.y = gun.y + sinf(gun.angle) * 40
        cannonball.setSpeed(force)
        cannonball.setHeading(gun.angle)
        
        isShooting = true
    }
    
    func updateStep() {
        if !isShooting {
            forceAngle += forceSpeed
        }
        
        rawForce = sinf(forceAngle)
        if isShooting {
            cannonball.update()
            checkTarget()
        }
        
        if cannonball.y > height {
            isShooting = false
        }
        requestAnimationFrame(#selector(updateStep))
        refresh()
    }
    
    func checkTarget() {
        if Utils.circleCollision(target, cannonball) {
            // create amazing collision reaction!
            setTarget()
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
