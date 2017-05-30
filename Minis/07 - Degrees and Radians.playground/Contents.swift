
import UIKit
import PlaygroundSupport

func degreesToRads(_ degrees:Float) -> Float
{
    return degrees / 180.0 * Float.pi
}

func radsToDegrees(_ radians:Float) -> Float
{
    return radians * 180.0 / Float.pi
}

class SampleView : UIView
{
    var redCircesPaths = [CGMutablePath]()
    var greenCircesPaths = [CGMutablePath]()
    var blueCircesPaths = [CGMutablePath]()
    
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ r: CGRect)
    {
        super.draw(r)
        
        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Unable to get context via \(UIGraphicsGetCurrentContext)") }
        
        context.setFillColor(UIColor.black.cgColor)
        
        let angle = CGFloat(degreesToRads(37))
        context.translateBy(x: r.width / 2, y: r.height / 2)
        context.rotate(by: angle)
        context.beginPath()
        context.addArc(center: CGPoint(x:0, y:0), radius: 20, startAngle: -CGFloat.pi, endAngle: CGFloat.pi, clockwise: false)
        context.fillPath()
        context.setLineWidth(10)
        context.beginPath()
        context.move(to: CGPoint(x:0, y:0))
        context.addLine(to: CGPoint(x:50, y:0))
        context.strokePath()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:400, height:200))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
