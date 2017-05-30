
import UIKit
import CoreGraphics
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

func norm(value:Float, min:Float, max:Float) -> Float
{
    return (value - min) / (max - min)
}

class SampleView : UIView
{
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        let width = Float(rect.size.width)
        let height = Float(rect.size.height)
        let values:[Float] = [7,5, 21, 18, 33, 12, 27, 18, 9, 23, 14, 6, 31, 25, 17, 13, 29]
        let min = values.min()!
        let max = values.max()!
        
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.black.cgColor)
        
        let path = CGMutablePath()
    
        for i in 0 ..< values.count
        {
            let normValue = norm(value: values[i], min: min, max: max)
            let x = width / Float(values.count - 1) * Float(i)
            let y = height - height * normValue
            
            if i == 0
            {
                path.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
            }
            else
            {
                path.addLine(to: CGPoint(x:CGFloat(x), y:CGFloat(y)))
            }
        }
        
        context?.addPath(path)
        context?.strokePath()
    }
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:400, height:250))
PlaygroundPage.current.liveView = view
