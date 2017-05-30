import UIKit

public class Arm {
    public var x:Float = 0
    public var y:Float = 0
    public var length:Float
    public var angle:Float = 0
    public var parent:Arm?
    
    public init(x:Float, y:Float, length:Float, angle:Float) {
        self.x = x
        self.y = y
        self.angle = angle
        self.length = length
    }
    
    public func getEndX() -> Float {
        return x + cos(angle) * length
    }
    
    public func getEndY() -> Float {
        return y + sin(angle) * length
    }
    
    static let color = UIColor.black.cgColor
    
    public func render(context:CGContext) {
        context.setStrokeColor(Arm.color)
        context.setLineWidth(5)
        context.beginPath()
        context.move(to: CGPoint(x: x, y: y))
        context.addLine(to: CGPoint(x: getEndX(), y: getEndY()))
        context.strokePath()
    }
    
    public func pointAt(x:Float, y:Float) {
        let dx = x - self.x
        let dy = y - self.y
        angle = atan2(dy, dx)
    }
    
    public func drag(x:Float, y:Float) {
        pointAt(x: x, y: y)
        self.x = x - cos(angle) * length
        self.y = y - sin(angle) * length
        guard let parent = self.parent else {
            return
        }
        parent.drag(x: self.x, y: self.y)
    }
    
    public func update() {
        
    }
}
