
import UIKit
import PlaygroundSupport

class Point
{
    var x:Float
    var y:Float
    
    init(x:Float = 0, y:Float = 0)
    {
        self.x = x
        self.y = y
    }
}

func distance(_ p0:Point, _ p1:Point) -> Float
{
    let dx = p1.x - p0.y
    let dy = p1.y - p0.y
    return sqrt(dx * dx + dy * dy)
}

func distanceXY(x0:Float, y0:Float, x1:Float, y1:Float) -> Float
{
    let dx = x1 - x0
    let dy = y1 - y0
    return sqrt(dx * dx + dy * dy)
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
    
    override func draw(_ r: CGRect)
    {
        super.draw(r)
        
        let dist = distanceXY(x0: Float(center.x), y0: Float(center.y), x1: Float(touchPoint.x), y1: Float(touchPoint.y))

        let context = UIGraphicsGetCurrentContext()
        
        if dist < 100
        {
            context?.setFillColor(red: 0xFF / 0xFF, green: 0x66 / 0xFF, blue: 0x66 / 0xFF, alpha: 1.0)
        }
        else
        {
            context?.setFillColor(red: 0xCC / 0xFF, green: 0xCC / 0xFF, blue: 0xCC / 0xFF, alpha: 1.0)
        }
        
        
        let circlePath = CGMutablePath()
        
        circlePath.addArc(center: center, radius: 100, startAngle: -CGFloat.pi, endAngle: CGFloat.pi, clockwise: false)
        
        context?.addPath(circlePath)
        context?.fillPath()
    }
    
    var touchPoint:CGPoint = CGPoint()
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touchPoint = touches.first?.location(in: self) else { return }
        self.touchPoint = touchPoint
        setNeedsDisplay()
    }
    
    
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:500, height:400))
PlaygroundPage.current.liveView = view


// also here http://stackoverflow.com/questions/34387250/generic-random-function-in-swift?rq=1

/*
protocol NumericType
{
    static func +(lhs: Self, rhs: Self) -> Self
    static func -(lhs: Self, rhs: Self) -> Self
    static func *(lhs: Self, rhs: Self) -> Self
    static func /(lhs: Self, rhs: Self) -> Self
    static func %(lhs: Self, rhs: Self) -> Self
    init(_ v: Int)
    init(_ v: Float)
    init(_ v: Double)
}

extension Double : NumericType { }
extension Float  : NumericType { }
extension Int    : NumericType { }
extension Int8   : NumericType { }
extension Int16  : NumericType { }
extension Int32  : NumericType { }
extension Int64  : NumericType { }
extension UInt   : NumericType { }
extension UInt8  : NumericType { }
extension UInt16 : NumericType { }
extension UInt32 : NumericType { }
extension UInt64 : NumericType { }


class Point<T:NumericType>
{
    var x:T
    var y:T
    
    static func distanceSQ(_ pA:Point, _ pB:Point) -> T
    {
        let px = pA.x - pB.x
        let py = pA.y - pB.y
        return px * px + py * py
    }
    
    init(x:T, y:T)
    {
        self.x = x
        self.y = y
    }
}

let pointInt = Point<Int>(x:0, y:0)
let pointFloat = Point<Float>(x:0, y:0)

Point.distanceSQ( pointFloat, pointFloat)
*/
