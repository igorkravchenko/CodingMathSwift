import Foundation

public class Particle {
    public var position:Vector
    public var velocity:Vector
    public var gravity:Vector
    public var mass:Float
    public var radius:Float
    public var bounce:Float
    
    public init(x:Float, y:Float, speed:Float, direction:Float, grav:Float = 0) {
        position = Vector(x: x, y: y)
        velocity = Vector(x: 0, y: 0)
        velocity.setLength(speed)
        velocity.setAngle(direction)
        gravity = Vector(x: 0, y: grav)
        mass = 1
        radius = 0
        bounce = -1
    }
    
    public func accelerate(_ accel:Vector) {
        velocity.addTo(accel)
    }
    
    public func update() {
        velocity.addTo(gravity)
        position.addTo(velocity)
    }
    
    public func angleTo(_ p2:Particle) -> Float {
        return atan2f(
            p2.position.getY() - position.getY(),
            p2.position.getX() - position.getX()
            )
    }
    
    public func distanceTo (_ p2:Particle) -> Float {
        let dx = p2.position.getX() - position.getX()
        let dy = p2.position.getY() - position.getY()
        
        return sqrtf(dx * dx + dy * dy)
    }
    
    public func gravitateTo(_ p2:Particle) {
        var grav = Vector(x:  0, y: 0)
        let dist = distanceTo(p2)
        
        grav.setLength(p2.mass / (dist * dist))
        grav.setAngle(angleTo(p2))
        velocity.addTo(grav)
    }
}
