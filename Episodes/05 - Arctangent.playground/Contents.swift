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
    
    var arrowX:Float = 0
    var arrowY:Float = 0
    var angle:Float = 0
    var dx:Float = 0
    var dy:Float = 0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Unable to get context via \(UIGraphicsGetCurrentContext)") }
        
        let width = Float(rect.width)
        let height = Float(rect.height)
        
        arrowX = width * 0.5
        arrowY = height * 0.5
        
        context.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 1)
        context.saveGState()
        context.translateBy(x: CGFloat(arrowX), y: CGFloat(arrowY))
        context.rotate(by: CGFloat(angle))
        context.move(to: CGPoint(x:20, y:0))
        context.addLine(to: CGPoint(x:-20, y:0))
        context.move(to: CGPoint(x:20, y:0))
        context.addLine(to: CGPoint(x:10, y:-10))
        context.move(to: CGPoint(x:20, y:0))
        context.addLine(to: CGPoint(x:10, y:10))
        context.strokePath()
        context.restoreGState()
    }
    
    func refresh() {
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        dx = Float(touchPoint.x) - arrowX
        dy = Float(touchPoint.y) - arrowY
        angle = atan2f(dy, dx)
        refresh()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:200, height:200))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true


