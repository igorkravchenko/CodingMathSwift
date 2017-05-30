
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

func randomDist(min:Float, max:Float, iterations:Int) -> Float {
    var total = 0 as Float
    
    for _ in 0 ..< iterations {
        total += randomRange(min: min, max: max)
    }
    
    return total / Float(iterations)
}

class SampleView : UIView
{
    var results = Array<Int>(repeating: 0, count: 100)
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.isUserInteractionEnabled = true
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update()
    {
        addResult()
        setNeedsDisplay()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(update),
                     with: nil,
                     afterDelay: 1 / 30)
    }
    
    func addResult()
    {
        let r0 = randomRange(min: 0, max: 100)
        let r1 = randomRange(min: 0, max: 100)
        let result = Int(floorf((r0 + r1) / 2))
        results[result] += 1
        
        // bell curve
        /*
        let iterations = 3
        var total:Float = 0
        
        for _ in 0 ..< iterations
        {
            total += randomRange(min: 0, max: 100)
        }
        
        let result = Int( floorf( total / Float( iterations ) ) )
        results[result] += 1
        */
        
    }
    
    override func draw(_ r: CGRect)
    {
        super.draw(r)
        
        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Unable to get context via \(UIGraphicsGetCurrentContext)") }
        
        let w = r.width / 100
        
        for i in 0 ..< 100
        {
            let h = CGFloat( results[i] * -10 )
            context.fill( CGRect(x: w * CGFloat(i), y: r.height, width: w, height: h) )
        }
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:400, height:200))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
