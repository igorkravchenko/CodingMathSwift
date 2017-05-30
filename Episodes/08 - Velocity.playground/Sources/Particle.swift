import Foundation

public class Particle {
    public var position:Vector
    public var velocity:Vector
    
    public init(x:Float, y:Float, speed:Float, direction:Float) {
        position = Vector(x: x, y: y)
        velocity = Vector(x: 0, y: 0)
        velocity.setLength(speed)
        velocity.setAngle(direction)
    }
    
    public func update() {
        position.addTo(velocity)
    }
    
}
