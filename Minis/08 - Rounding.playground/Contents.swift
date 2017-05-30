
import UIKit
import PlaygroundSupport

func round(value:Double, to places:Int) -> Double
{
    let mult = pow(10, Double(places))
    return round(Double(value) * mult) / mult
}

func round(value:Double, to nearest:Double) -> Double
{
    return round(value / nearest) * nearest
}

print( round(value: Double.pi, to: 1) )
print( round(value: Double.pi, to: 3) )
print( round(value: Double.pi, to: 5) )

print( Int(  round(value: 123456789, to: -1) ) )
print( Int(  round(value: 123456789, to: -2) ) )
print( Int(  round(value: 123456789, to: -3) ) )

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
    
    override func draw(_ r: CGRect)
    {
        super.draw(r)
        
        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Unable to get context via \(UIGraphicsGetCurrentContext)") }
        drawGrid(context: context)
        
        
        let x = round(value: Double(circlePoint.x), to: gridSize)
        let y = round(value: Double(circlePoint.y), to: gridSize)
        let p = CGPoint(x: x, y: y)
        context.setFillColor(UIColor.black.cgColor)
        context.beginPath()
        context.addArc(center: p, radius: 20, startAngle: -CGFloat.pi, endAngle: CGFloat.pi, clockwise: false)
        context.fillPath()
    }
    
    var circlePoint = CGPoint()
    
    let gridSize = 40 as Double

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touchPoint = touches.first?.location(in: self) else { return }
        circlePoint = touchPoint
        setNeedsDisplay()
    }
    
    func drawGrid(context:CGContext)
    {
        context.beginPath()
        context.setLineWidth(1)
        context.setStrokeColor(UIColor.gray.cgColor)
        let width = Int(self.bounds.width)
        let height = Int(self.bounds.height)
        
        var x = 0
        
        let gridSize = Int(self.gridSize)
        
        while x <= width
        {
            context.move(to: CGPoint(x: x, y: 0))
            context.addLine(to: CGPoint(x: x, y: height))
            x += gridSize
        }
        
        var y = 0
        
        while y <= height
        {
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: width, y: y))
            y += gridSize
        }
        
        context.strokePath()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:400, height:200))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true

