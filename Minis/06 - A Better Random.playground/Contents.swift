
import UIKit
import PlaygroundSupport

extension Float
{
    static func random() -> Float
    {
        return Float( arc4random() % UInt32.max ) / Float( UInt32.max )
    }
}

func randomRange(min:Float, max:Float) -> Float
{
    return min + Float.random() * (max - min)
}

func randomInt(min:Int, max:Int) -> Int
{
    return Int( floorf( Float(min) + Float.random() * Float(max - min + 1) ) )
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
        
        for _ in 0 ..< 200
        {
            let redPath = CGMutablePath()
            redPath.addArc(
                center: CGPoint(
                                x:CGFloat(randomRange(min: 0, max: Float(frame.width * 0.33))),
                                y:CGFloat(randomRange(min: 0, max: Float(frame.height)))
                ),
                radius: CGFloat(randomRange(min: 10, max: 40)),
                startAngle: -CGFloat.pi,
                endAngle: CGFloat.pi,
                clockwise: false
            )
            redCircesPaths.append(redPath)
            
            let greenPath = CGMutablePath()
            greenPath.addArc(
                center: CGPoint(
                    x:CGFloat(randomRange(min: Float(frame.width * 0.33), max: Float(frame.width * 0.66))),
                    y:CGFloat(randomRange(min: 0, max: Float(frame.height)))
                ),
                radius: CGFloat(randomRange(min: 10, max: 40)),
                startAngle: -CGFloat.pi,
                endAngle: CGFloat.pi,
                clockwise: false
            )
            greenCircesPaths.append(greenPath)
            
            let bluePath = CGMutablePath()
            bluePath.addArc(
                center: CGPoint(
                    x:CGFloat(randomRange(min: Float(frame.width * 0.66), max: Float(frame.width))),
                    y:CGFloat(randomRange(min: 0, max: Float(frame.height)))
                ),
                radius: CGFloat(randomRange(min: 10, max: 40)),
                startAngle: -CGFloat.pi,
                endAngle: CGFloat.pi,
                clockwise: false
            )
            blueCircesPaths.append(bluePath)
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ r: CGRect)
    {
        super.draw(r)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.red.cgColor)
        
        for path in redCircesPaths
        {
            context?.addPath(path)
        }
        
        context?.fillPath()
        
        context?.setFillColor(UIColor.green.cgColor)
        
        for path in greenCircesPaths
        {
            context?.addPath(path)
        }
        
        context?.fillPath()
        
        context?.setFillColor(UIColor.blue.cgColor)
        
        for path in blueCircesPaths
        {
            context?.addPath(path)
        }
        
        context?.fillPath()
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view

let nums = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

for _ in 0 ..< 10
{
    let index = randomInt(min: 4, max: 8)
    print(nums[index])
}
