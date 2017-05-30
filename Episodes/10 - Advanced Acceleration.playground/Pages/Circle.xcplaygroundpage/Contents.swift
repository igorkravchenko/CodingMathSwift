import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    
    let rightDirButton = UIButton.buttonWithText("→")
    let leftDirButton = UIButton.buttonWithText("←")
    let upDirButton = UIButton.buttonWithText("↑")
    let downDirButton = UIButton.buttonWithText("↓")
    
    var ship:Particle!
    var thrust = Vector(x: 0, y: 0)
    
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
        
        downDirButton.center = CGPoint(x: width / 2.0, y: height - 88.0 + 44.0)
        addSubview(downDirButton)
        addHandlerForButton(downDirButton)
        
        ship = Particle(x: width / 2.0, y: height / 2.0, speed: 0, direction: 0)
    }
    
    override func update(context: CGContext) {
        
        ship.accelerate(thrust)
        ship.update()
        
        context.addArc(
            center: CGPoint(
                x: ship.position.getX(),
                y: ship.position.getY()
            ),
            radius: 10,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        
        context.fillPath()
        
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
            thrust.setY(-0.1)
            
        case downDirButton:
            thrust.setY(0.1)
            
        case leftDirButton:
            thrust.setX(-0.1)
            
        case rightDirButton:
            thrust.setX(0.1)
            
        default:
            break
        }
    }
    
    func keyUpHandler(_ button:UIButton) {
        
        switch button {
            
        case upDirButton:
            thrust.setY(0.0)
            
        case downDirButton:
            thrust.setY(0.0)
            
        case leftDirButton:
            thrust.setX(0.0)
            
        case rightDirButton:
            thrust.setX(0.0)
            
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
