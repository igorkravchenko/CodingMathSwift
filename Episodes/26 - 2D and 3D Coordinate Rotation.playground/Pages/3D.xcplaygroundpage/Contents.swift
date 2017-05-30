import UIKit
import PlaygroundSupport

class Point {
    var x:Float
    var y:Float
    var z:Float
    var sx:Float = 0
    var sy:Float = 0
    
    init(x:Float = 0, y:Float = 0, z:Float = 0) {
        self.x = x
        self.y = y
        self.z = z
    }
}

extension Point {
    var cgPoint:CGPoint {
        return CGPoint(x: sx, y: sy)
    }
}

class SampleView : BaseView {
    let fl:Float = 300
    var points = [Point]()
    
    let rightButton = UIButton.buttonWithText("→")
    let leftButton = UIButton.buttonWithText("←")
    let upButton = UIButton.buttonWithText("↑")
    let downButton = UIButton.buttonWithText("↓")
    let shiftButton = UIButton.buttonWithText("⇪")
    let controlButton = UIButton.buttonWithText("⌃")
    
    override func setup() {
        points.insert(Point(x: -500, y: -500, z: 1000), at: 0)
        points.insert(Point(x:  500, y: -500, z: 1000), at: 1)
        points.insert(Point(x:  500, y: -500, z:  500), at: 2)
        points.insert(Point(x: -500, y: -500, z:  500), at: 3)
        
        points.insert(Point(x: -500, y: 500, z: 1000), at: 4)
        points.insert(Point(x:  500, y: 500, z: 1000), at: 5)
        points.insert(Point(x:  500, y: 500, z:  500), at: 6)
        points.insert(Point(x: -500, y: 500, z:  500), at: 7)
        
        
        rightButton.center = CGPoint(x: width - 20, y: height / 2)
        addSubview(rightButton)
        rightButton.addTarget(self, action: #selector(handleButtonDown(_:)), for: .touchDown)
        
        leftButton.center = CGPoint(x: 20, y: height / 2)
        addSubview(leftButton)
        leftButton.addTarget(self, action: #selector(handleButtonDown(_:)), for: .touchDown)
        
        upButton.center = CGPoint(x: width / 2, y: 20)
        addSubview(upButton)
        upButton.addTarget(self, action: #selector(handleButtonDown(_:)), for: .touchDown)
        
        downButton.center = CGPoint(x: width / 2, y: height - 20)
        addSubview(downButton)
        downButton.addTarget(self, action: #selector(handleButtonDown(_:)), for: .touchDown)
        
        shiftButton.center = CGPoint(x: 20, y: 20)
        addSubview(shiftButton)
        shiftButton.addTarget(self, action: #selector(handleToggleTouchUp(_:)), for: .touchUpInside)
        shiftButton.setTitleColor(shiftButton.tintColor, for: .normal)
        shiftButton.setTitleColor(UIColor.magenta, for: .selected)
        
        controlButton.center = CGPoint(x: 60, y: 20)
        addSubview(controlButton)
        controlButton.addTarget(self, action: #selector(handleToggleTouchUp(_:)), for: .touchUpInside)
        controlButton.setTitleColor(controlButton.tintColor, for: .normal)
        controlButton.setTitleColor(UIColor.magenta, for: .selected)
        
        setNeedsDisplay()
    }
    
    func project() {
        for p in points {
            let scale = fl / (fl + p.z)
            p.sx = p.x * scale
            p.sy = p.y * scale
        }
    }
    
    func drawLine(_ context:CGContext, _ indices:Int ...) {
        var p = points[indices[0]]
        context.move(to: p.cgPoint)
        for i in 1 ..< indices.count {
            p = points[indices[i]]
            context.addLine(to: p.cgPoint)
        }
    }
    
    func translateModel(x:Float, y:Float, z:Float) {
        for p in points {
            p.x += x
            p.y += y
            p.z += z
        }
        setNeedsDisplay()
    }
    
    func rotateX(_ angle:Float) {
        let cosine = cosf(angle)
        let sine = sinf(angle)
        
        for p in points {
            let y = p.y * cosine - p.z * sine
            let z = p.z * cosine + p.y * sine
            p.y = y
            p.z = z
        }
        setNeedsDisplay()
    }
    
    func rotateY(_ angle:Float) {
        let cosine = cosf(angle)
        let sine = sinf(angle)
        
        for p in points {
            let x = p.x * cosine - p.z * sine
            let z = p.z * cosine + p.x * sine
            p.x = x
            p.z = z
        }
        setNeedsDisplay()
    }
    
    func rotateZ(_ angle:Float) {
        let cosine = cosf(angle)
        let sine = sinf(angle)
        
        for p in points {
            let x = p.x * cosine - p.y * sine
            let y = p.y * cosine + p.x * sine
            p.x = x
            p.y = y
        }
        setNeedsDisplay()
    }
    
    override func update(context: CGContext) {
        context.translateBy(x: CGFloat(width / 2), y: CGFloat(height / 2))
        project()
        
        context.beginPath()
        drawLine(context, 0, 1, 2, 3, 0)
        drawLine(context, 4, 5, 6, 7, 4)
        drawLine(context, 0, 4)
        drawLine(context, 1, 5)
        drawLine(context, 2, 6)
        drawLine(context, 3, 7)
        context.strokePath()
    }
    
    func handleButtonDown(_ button:UIButton) {
        switch button {
        case leftButton:
            if controlButton.isSelected {
                rotateY(0.05)
            }
            else {
                translateModel(x: -20, y: 0, z: 0)
            }
        case rightButton:
            if controlButton.isSelected {
                rotateY(-0.05)
            }
            else {
                translateModel(x: 20, y: 0, z: 0)
            }
        case upButton:
            if shiftButton.isSelected {
                translateModel(x: 0, y: 0, z: 20)
            }
            else if controlButton.isSelected {
                rotateX(0.05)
            }
            else {
                translateModel(x: 0, y: -20, z: 0)
            }
        case downButton:
            if shiftButton.isSelected {
                translateModel(x: 0, y: 0, z: -20)
            }
            else if controlButton.isSelected {
                rotateX(-0.05)
            }
            else {
                translateModel(x: 0, y: 20, z: 0)
            }
        default:
            break
        }
    }
    
    func handleToggleTouchUp(_ button:UIButton) {
        button.isSelected = !button.isSelected
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
