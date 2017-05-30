import Foundation

public class Particle {
    public var position:Vector
    public var velocity:Vector
    public var gravity:Vector
    
    public init(x:Float, y:Float, speed:Float, direction:Float, grav:Float = 0) {
        position = Vector(x: x, y: y)
        velocity = Vector(x: 0, y: 0)
        velocity.setLength(speed)
        velocity.setAngle(direction)
        gravity = Vector(x: 0, y: grav)
    }
    
    public func accelerate(_ accel:Vector) {
        velocity.addTo(accel)
    }
    
    public func update() {
        velocity.addTo(gravity)
        position.addTo(velocity)
    }
    
}
