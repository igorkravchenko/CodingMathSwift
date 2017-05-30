
import UIKit
import PlaygroundSupport

func clamp(value:Float, min:Float, max:Float) -> Float
{
    return Float.minimum(Float.maximum(value, min), max)
}

PlaygroundPage.current.needsIndefiniteExecution = true


class SampleView : UIView
{
    let rect:CGRect
    
    public override init(frame: CGRect)
    {
        self.rect = CGRect(x: frame.width / 2.0 - 200.0, y: frame.height / 2 - 150, width: 400.0, height: 300.0)
        self.circlePoint.x = frame.width / 2.0
        self.circlePoint.y = frame.height / 2.0
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ r: CGRect)
    {
        super.draw(r)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(UIColor(red: 0xCC / 255.0, green: 0xCC / 255.0, blue: 0xCC / 255, alpha: 1).cgColor)
        context?.fill( CGRect(x: rect.origin.x - 10, y: rect.origin.y - 10, width: rect.width + 20, height: rect.height + 20 ) )
        context?.fillPath()
        context?.setFillColor(UIColor.black.cgColor)
        
        let circlePath = CGMutablePath()
        circlePath.addArc(center: self.circlePoint, radius: 10, startAngle: -CGFloat.pi, endAngle: CGFloat.pi, clockwise: false)
        
        context?.addPath(circlePath)
        context?.fillPath()
    }
    
    var circlePoint = CGPoint()
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touchPoint = touches.first?.location(in: self) else { return }
        
        let x = clamp(value: Float(touchPoint.x), min: Float(rect.origin.x), max: Float(rect.origin.x + rect.width))
        let y = clamp(value: Float(touchPoint.y), min: Float(rect.origin.y), max: Float(rect.origin.y + rect.height))
        
        circlePoint.x = CGFloat(x)
        circlePoint.y = CGFloat(y)

        setNeedsDisplay()
    }
    
    
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:500, height:400))
PlaygroundPage.current.liveView = view
