import UIKit
import PlaygroundSupport

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
        
        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Unable to get context via \(UIGraphicsGetCurrentContext)") }
        
        let height = Float(rect.height)
        
        context.translateBy(x: 0, y: CGFloat(height / 2.0))
        context.scaleBy(x: 1.0, y: -1.0)
        
        var angle:Float = 0
        
        while angle < Float.pi * 2.0  {
            let x = angle * 100.0
            let y = sinf(angle) * 100.0
            angle += 0.01
            context.addRect(CGRect(x: x, y: y, width: 5.0, height: 5.0))
            context.fillPath()
        }
    }
}


let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true


