import UIKit
import PlaygroundSupport
import Dispatch

class SampleView : UIView
{
    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var xangle = 0 as Float
    var yangle = 0 as Float
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Unable to get context via \(UIGraphicsGetCurrentContext)") }
        
        let width = Float(rect.width)
        let height = Float(rect.height)
        
        let centerY = height * 0.5
        let centerX = width * 0.5
        let xRadius = 200 as Float
        let yRadius = 400 as Float
        let xspeed = 0.1 as Float
        let yspeed = 0.131 as Float
        
        let x = centerX + cos(xangle) * xRadius
        let y = centerY + sin(yangle) * yRadius
        context.addArc(
            center: CGPoint(x: x, y: y),
            radius: 10.0,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        xangle += xspeed
        yangle += yspeed
        
        self.perform(#selector(refresh), with: nil, afterDelay: 1.0 / 30.0)
    }
    
    func refresh() {
        setNeedsDisplay()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true


