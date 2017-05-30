import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    
    let rightDirButton = UIButton.buttonWithText("→")
    let leftDirButton = UIButton.buttonWithText("←")
    let upDirButton = UIButton.buttonWithText("↑")
    
    var ship:Particle!
    var thrust = Vector(x: 0, y: 0)
    var angle:Float = 0
    var turningLeft = false
    var turningRight = false
    var thrusting = false
    
    override func setup() {
        
        rightDirButton.center = CGPoint(x: width / 2.0 + 44.0, y: height - 88.0)
        addSubview(rightDirButton)
        addHandlerForButton(rightDirButton)
        
        leftDirButton.center = CGPoint(x: width / 2.0 - 44.0, y: height - 88.0)
        addSubview(leftDirButton)
        addHandlerForButton(leftDirButton)
        
        upDirButton.center = CGPoint(x: width / 2.0, y: height - 88.0 - 44.0)
        addSubview(upDirButton)
        addHandlerForButton(upDirButton)
        
        ship = Particle(x: width / 2.0, y: height / 2.0, speed: 0, direction: 0)
        ship.friction = 0.99
    }
    
    override func update(context: CGContext) {
        
        if turningLeft {
            angle -= 0.05
        }
        
        if turningRight {
            angle += 0.05
        }
        
        thrust.setAngle(angle)
        
        if thrusting {
            thrust.setLength(0.1)
        }
        else {
            thrust.setLength(0)
        }
        
        ship.accelerate(thrust)
        ship.update()
        
        context.saveGState()
        context.translateBy(
            x: CGFloat(ship.position.getX()),
            y: CGFloat(ship.position.getY())
        )
        
        context.rotate(by: CGFloat(angle))
        
        context.beginPath()
        
        context.move(to: CGPoint(
            x: 10,
            y: 0
        ))
        
        context.addLine(to: CGPoint(
            x: -10,
            y: -7
        ))
        
        context.addLine(to: CGPoint(
            x: -10,
            y: 7
        ))
        
        context.addLine(to: CGPoint(
            x: 10,
            y: 0
        ))
        
        if thrusting {
            context.move(to: CGPoint(
                x: -10,
                y: 0
            ))
            
            context.addLine(to: CGPoint(
                x: -18,
                y: 0
            ))
        }
        
        context.strokePath()
        
        context.restoreGState()
        
        if (ship.position.getX() > width) {
            ship.position.setX(0)
        }
        
        if (ship.position.getX() < 0) {
            ship.position.setX(width)
        }
        
        if (ship.position.getY() > height) {
            ship.position.setY(0)
        }
        
        if (ship.position.getY() < 0) {
            ship.position.setY(height)
        }
        
        requestAnimationFrame()
    }
    
    func addHandlerForButton(_ button:UIButton) {
        button.addTarget(self, action: #selector(keyDownHandler(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(keyUpHandler(_:)), for: .touchUpInside)
    }
    
    func keyDownHandler(_ button:UIButton) {
        
        switch button {
            
        case upDirButton:
            thrusting = true
            
        case leftDirButton:
            turningLeft = true
            
        case rightDirButton:
            turningRight = true
            
        default:
            break
        }
    }
    
    func keyUpHandler(_ button:UIButton) {
        
        switch button {
            
        case upDirButton:
            thrusting = false
            
        case leftDirButton:
            turningLeft = false
            
        case rightDirButton:
            turningRight = false
            
        default:
            break
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


let view = SampleView(frame:CGRect(x:0, y:0, width:500, height:500))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
