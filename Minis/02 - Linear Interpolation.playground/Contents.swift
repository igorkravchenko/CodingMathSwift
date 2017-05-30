
import UIKit
import CoreGraphics
import PlaygroundSupport

func lerp(norm:Float, min:Float, max:Float) -> Float
{
    return (max - min) * norm + min
}

class SampleView : UIView
{
    var timer:Timer?
    
    public override init(frame: CGRect)
    {
        width = Float(frame.size.width)
        height = Float(frame.size.height)
        maxX = width - 50
        maxY = height - 100
        
        super.init(frame: frame)

        self.backgroundColor = UIColor.white
        
        timer = Timer.scheduledTimer(withTimeInterval: 1 / 30, repeats: true)
        {
            [unowned self] _ in
            self.setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let width:Float
    let height:Float
    
    let minX = 50 as Float
    let maxX:Float
    let minY = 100 as Float
    let maxY:Float
    let minAlpha = 0 as Float
    let maxAlpha = 1 as Float
    let minRadius = 10 as Float
    let maxRadius = 400 as Float

    var t = 0 as Float
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
               guard let context:CGContext = UIGraphicsGetCurrentContext() else  { return }
        
        context.setFillColor( UIColor.init(red: 0, green: 0, blue: 0, alpha: CGFloat(lerp(norm: t, min: maxAlpha, max: minAlpha))).cgColor )
        
        context.addArc(
            center: CGPoint( x: CGFloat(lerp(norm: t, min: minX, max: maxX)), y: CGFloat(lerp(norm: t, min: minY, max: maxY))),
            radius: CGFloat( lerp(norm: t, min: minRadius, max: maxRadius) ),
            startAngle: -CGFloat.pi * 2,
            endAngle: CGFloat.pi * 2,
            clockwise: false
        )
        
        context.fillPath()
        
        t += 0.005
        if t > 1
        {
            t = 0
        }
    }
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:400, height:250))
PlaygroundPage.current.liveView = view
