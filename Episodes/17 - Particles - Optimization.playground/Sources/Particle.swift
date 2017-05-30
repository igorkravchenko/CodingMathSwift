import Foundation

public class Particle {
    public var x:Float
    public var y:Float
    public var vx:Float
    public var vy:Float
    public var gravity:Float
    public var mass:Float
    public var radius:Float
    public var bounce:Float
    public var friction:Float
    
    public init(x:Float, y:Float, speed:Float, direction:Float, gravity:Float = 0) {
        self.x = x
        self.y = y
        vx = cosf(direction) * speed
        vy = sinf(direction) * speed
        self.gravity = gravity
        mass = 1
        radius = 0
        bounce = -1
        friction = 1
    }
    
    public func accelerate(ax:Float, ay:Float) {
        vx += ax
        vy += ay
    }
    
    public func update() {
        vx *= friction
        vy *= friction
        vy += gravity
        x += vx
        y += vy
    }
    
    public func angleTo(_ p2:Particle) -> Float {
        return atan2f(p2.y - y, p2.x - x)
    }
    
    public func distanceTo (_ p2:Particle) -> Float {
        let dx = p2.x - x
        let dy = p2.y - y
        
        return sqrtf(dx * dx + dy * dy)
    }
    
    public func gravitateTo(_ p2:Particle) {
        let dx = p2.x - x
        let dy = p2.y - y
        let distSQ = dx * dx + dy * dy
        let dist = sqrt(distSQ)
        let force = p2.mass / distSQ
        let ax = dx / dist * force
        let ay = dy / dist * force
        
        vx += ax
        vy += ay
        
    }
}
