
import UIKit
import PlaygroundSupport

extension Float
{
    static func random() -> Float
    {
        return Float( arc4random() % UInt32.max ) / Float( UInt32.max )
    }
}

class SampleView : UIView
{
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        let width = Float(rect.width)
        let height = Float(rect.height)
        let centerX = width / 2
        let centerY = height / 2
        let maxRadius = 200 as Float
        
        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Unable to get context via \(UIGraphicsGetCurrentContext)") }
        context.setFillColor(UIColor.black.cgColor)
        for _ in 0 ..< 1000 {
            let radius = sqrt(Float.random()) * maxRadius
            let angle = Float.random() * Float.pi * 2
            let x = centerX + cos(angle) * radius
            let y = centerY + sin(angle) * radius
            context.addArc(center: CGPoint(x:CGFloat(x), y:CGFloat(y)), radius: 1, startAngle: -CGFloat.pi, endAngle: CGFloat.pi, clockwise: false)
            context.fillPath()
        }
        
        
        
    }
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:400, height:400))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
