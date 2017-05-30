import UIKit

public class Arm {
    public var x:Float = 0
    public var y:Float = 0
    public var length:Float
    public var angle:Float = 0
    public var parent:Arm?
    public var centerAngle:Float
    public var rotationRange:Float = Float.pi / 4
    public var phaseOffset:Float = 0
    
    public init(length:Float, centerAngle:Float, rotationRange:Float, phaseOffset:Float) {
        self.length = length
        self.centerAngle = centerAngle
        self.rotationRange = rotationRange
        self.phaseOffset = phaseOffset
    }
    
    public func setPhase(pahse:Float) {
        angle = centerAngle + sin(pahse + phaseOffset) * rotationRange
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
