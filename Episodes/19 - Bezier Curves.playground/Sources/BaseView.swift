import UIKit

open class BaseView : UIView
{
    private var isSetup:Bool = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = UIColor.white
        setup()
        isSetup = true
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
        
        guard isSetup else { return }
        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Unable to get context via \(UIGraphicsGetCurrentContext)") }
            
            update(context:context);
        
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        
        let touchPoint = touch.location(in: self)
        handleTouchDown(touchX: Float(touchPoint.x), touchY: Float(touchPoint.y))
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        
        let touchPoint = touch.location(in: self)
        handleTouchMoved(touchX: Float(touchPoint.x), touchY: Float(touchPoint.y))
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        
        let touchPoint = touch.location(in: self)
        handleTouchUp(touchX: Float(touchPoint.x), touchY: Float(touchPoint.y))
    }
    
    open func handleTouchDown(touchX:Float, touchY:Float) {
        // Override
    }
    
    open func handleTouchMoved(touchX:Float, touchY:Float) {
        // Override
    }
    
    open func handleTouchUp(touchX:Float, touchY:Float) {
        // Override
    }
    
    
    open func setup() {
        // Override
    }
    
    open func update(context:CGContext) {
        // Override
    }
    
    public func requestAnimationFrame(_ sel:Selector)
    {
        self.perform(sel, with: nil, afterDelay: 1.0 / 60.0)
    }
}


