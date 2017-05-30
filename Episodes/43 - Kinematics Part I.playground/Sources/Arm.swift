import UIKit

public class Arm {
    public var x:Float
    public var y:Float
    public var length:Float
    public var angle:Float
    public var parent:Arm?
    
    public init(x:Float, y:Float, length:Float, angle:Float) {
        self.x = x
        self.y = y
        self.length = length
        self.angle = angle
    }
    
    public func getEndX() -> Float {
        var angle = self.angle
        var parent = self.parent
        while let p = parent {
            angle += p.angle
            parent = p.parent
        }
        return x + cos(angle) * length
    }
    
    public func getEndY() -> Float {
        var angle = self.angle
        var parent = self.parent
        while let p = parent {
            angle += p.angle
            parent = p.parent
        }
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
}
