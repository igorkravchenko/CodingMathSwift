
import UIKit
import PlaygroundSupport

class Handle : Equatable {
    
    private static var _id:Int = Int.min
    
    var x: Float
    var y: Float
    var radius:Float
    private (set) var id:Int
    
    init(x:Float, y:Float, radius:Float) {
        self.x = x
        self.y = y
        self.radius = radius
        Handle._id += 1
        id = Handle._id

    }
    
    public static func ==(lhs: Handle, rhs: Handle) -> Bool
    {
        return lhs.id == rhs.id
    }
}

func distanceXY(x0:Float, y0:Float, x1:Float, y1:Float) -> Float {
    let dx = x1 - x0
    let dy = y1 - y0
    return sqrtf(dx * dx + dy * dy)
}

protocol Circle {
    var x:Float { get }
    var y:Float { get }
    var radius:Float { get }
}

protocol Point {
    var x:Float { get }
    var y:Float { get }
}

func circlePointCollision(x:Float, y:Float, circleX:Float, circleY:Float, circleRadius:Float) -> Bool {
    return distanceXY(x0: x, y0: y, x1: circleX, y1: circleY) < circleRadius
}

extension CGPoint {
    init(x:Float, y:Float) {
        self.init(x:CGFloat(x), y:CGFloat(y))
    }
}

class SampleView : UIView
{
    let handle0 = Handle(x: 100, y: 100, radius: 15)
    let handle1 = Handle(x: 300, y: 300, radius: 15)
    let handle2 = Handle(x: 500, y: 100, radius: 15)
    let handle3 = Handle(x: 500, y: 500, radius: 15)
    
    let handles:[Handle]
    var offset = (x:0 as Float, y:0 as Float)
    var isDragging = false
    var dragHandle:Handle?

    public override init(frame: CGRect) {
        handles = [handle0, handle1, handle2, handle3]
        super.init(frame: frame)
        super.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Unable to get context via \(UIGraphicsGetCurrentContext)") }
        
        context.setStrokeColor(UIColor.black.cgColor)
        
        context.move(to: CGPoint(x: handle0.x, y: handle0.y))
        
        context.addCurve(to: CGPoint(x: handle1.x, y:handle1.y),
                         control1: CGPoint(x: handle2.x, y: handle2.y),
                         control2: CGPoint(x: handle3.x, y: handle3.y))
        context.strokePath()
        
        context.setFillColor(UIColor.gray.cgColor)
        
        for handle in handles {
            
            if let dragHandle = self.dragHandle {
                if isDragging && handle == dragHandle {
                    context.setShadow(offset: CGSize(width: 4, height: 4), blur:  8, color:UIColor.black.cgColor)
                }
            }
            
            context.addArc(center: CGPoint(x:handle.x, y: handle.y),
                           radius: CGFloat(handle.radius),
                           startAngle: -CGFloat.pi,
                           endAngle: CGFloat.pi, clockwise: false)
            context.fillPath()
            context.setShadow(offset: CGSize(width:0, height:0), blur: 0)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let locX = Float(location.x)
        let locY = Float(location.y)
        for handle in handles {
            if circlePointCollision(x: locX, y: locY, circleX: handle.x, circleY: handle.y, circleRadius: handle.radius) {
                isDragging = true
                self.dragHandle = handle
                offset.x = locX - handle.x
                offset.y = locY - handle.y
                print(handle.id)
            }
        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let locX = Float(location.x)
        let locY = Float(location.y)
        guard let dragHandle = self.dragHandle else { return }
        dragHandle.x = locX - offset.x
        dragHandle.y = locY - offset.y
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDragging = false
        setNeedsDisplay()
        dragHandle = nil
        offset.x = 0
        offset.y = 0
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
