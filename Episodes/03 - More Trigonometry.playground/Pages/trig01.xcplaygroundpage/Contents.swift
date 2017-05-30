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

    var angle = 0 as Float
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Unable to get context via \(UIGraphicsGetCurrentContext)") }
        
        let width = Float(rect.width)
        let height = Float(rect.height)
        
        let centerY = height * 0.5
        let centerX = width * 0.5
        let offset = height * 0.4
        let speed = 0.1 as Float
        
        let y = centerY + sinf(angle) * offset
        
        context.addArc(
            center: CGPoint(x:centerX, y:y),
            radius: 50.0,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        
        context.fillPath()
        
        angle += speed
        
        self.perform(#selector(refresh), with: nil, afterDelay: 1.0 / 20.0)
        
    }
    
    func refresh() {
        setNeedsDisplay()
    }
}




let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true


