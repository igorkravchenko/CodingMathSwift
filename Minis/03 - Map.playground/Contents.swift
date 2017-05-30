
import UIKit
import CoreGraphics
import PlaygroundSupport

func map(value:Float, sourceMin:Float, sourceMax:Float, destMin:Float, destMax:Float) -> Float
{
    return lerp(norm: norm(value: value, min: sourceMin, max: sourceMax), min: destMin, max: destMax)
}

func norm(value:Float, min:Float, max:Float) -> Float
{
    return (value - min) / (max - min)
}

func lerp(norm:Float, min:Float, max:Float) -> Float
{
    return (max - min) * norm + min
}

PlaygroundPage.current.needsIndefiniteExecution = true


class SampleView : UIView
{
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        let width = Float(rect.size.width)
        let height = Float(rect.size.height)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.black.cgColor)
        
        let path = CGMutablePath()
        
        path.addArc(center: CGPoint(x: CGFloat(width / 2), y: CGFloat(height / 2)), radius: CGFloat(radius), startAngle: -CGFloat.pi, endAngle: CGFloat.pi, clockwise: false)
        
        context?.addPath(path)
        
        context?.fillPath()
    }
    
    var radius:Float = 0
    var touchPoint = CGPoint()
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touchPoint = touches.first?.location(in: self) else { return }
        self.touchPoint = touchPoint
        let height = Float(self.bounds.height)
        
        radius = map(value: Float(touchPoint.y), sourceMin: 0, sourceMax: height, destMin: 20, destMax: height / 2)
        
        setNeedsDisplay()
    }
    
    
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:400, height:250))
PlaygroundPage.current.liveView = view
