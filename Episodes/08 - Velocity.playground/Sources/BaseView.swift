import UIKit

open class BaseView : UIView
{
    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = UIColor.white
        setup()
    }
    
    public var width:Float {
        return Float(self.frame.width)
    }
    
    public var height:Float {
        return Float(self.frame.height)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Unable to get context via \(UIGraphicsGetCurrentContext)") }
        update(context:context);
    }
    
    open func setup() {
        
    }
    
    open func update(context:CGContext) {
        
    }
    
    public func requestAnimationFrame()
    {
        self.perform(#selector(refresh), with: nil, afterDelay: 1.0 / 60.0)
    }
    
    @objc private func refresh() {
        setNeedsDisplay()
    }
}


