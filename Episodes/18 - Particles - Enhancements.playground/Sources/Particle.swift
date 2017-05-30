import Foundation

public class Particle : Equatable, CircleProvidable {
    
    private static var nextID:Int64 = Int64.min
    
    public var x:Float
    public var y:Float
    public var vx:Float
    public var vy:Float
    public var gravity:Float
    public var mass:Float
    public var radius:Float
    public var bounce:Float
    public var friction:Float
    private var springs:[Spring]
    private var gravitations:[Particle]
    private let id:Int64
    
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
        springs = [Spring]()
        gravitations = [Particle]()
        Particle.nextID += 1
        id = Particle.nextID
    }
    
    public func addGravitation(_ p:Particle) {
        removeGravitation(p)
        gravitations.append(p)
    }
    
    public func removeGravitation(_ p:Particle) {
        var i = gravitations.count - 1
        
        while i >= 0 {
            let particle = gravitations[i]
            
            if p == particle {
                gravitations.remove(at: i)
                return
            }
            
            i -= 1
        }
    }
    
    public func addSpring(point:XYProvidable, k:Float, length:Float = 0) {
        removeSpring(point: point)
        springs.append(Spring(point: point, k: k, length: length))
    }
    
    public func removeSpring(point:XYProvidable) {
        var i = springs.count - 1
        
        while i >= 0 {
            let p = springs[i].point
            
            if p.x == point.x && p.y == point.y {
                springs.remove(at: i)
                return
            }
            
            i -= 1
        }
    }
    
    public func getSpeed() -> Float {
        return sqrtf(vx * vx + vy * vy)
    }
    
    public func setSpeed(_ speed:Float) {
        let heading = getHeading()
        vx = cosf(heading) * speed
        vy = sinf(heading) * speed
    }
    
    public func getHeading() -> Float {
        return atan2f(vy, vx)
    }
    
    public func setHeading(_ heading:Float) {
        let speed = getHeading()
        vx = cosf(heading) * speed
        vy = sinf(heading) * speed
    }
    
    public func accelerate(ax:Float, ay:Float) {
        vx += ax
        vy += ay
    }
    
    public func update() {
        handleSprings()
        handleGravitations()
        vx *= friction
        vy *= friction
        vy += gravity
        x += vx
        y += vy
    }
    
    private func handleGravitations() {
        for particle in gravitations {
            gravitateTo(particle)
        }
    }
    
    private func handleSprings() {
        for spring in springs {
            springTo(point: spring.point, k: spring.k, length: spring.length)
        }
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
        //let ax = dx / dist * force
        //let ay = dy / dist * force
        
        //vx += ax
        //vy += ay
        
        // inline the commented out code above
        vx += dx / dist * force
        vy += dy / dist * force
    }
    
    public func springTo(point:XYProvidable, k:Float, length:Float = 0) {
        let dx = point.x - x
        let dy = point.y - y
        let distance = sqrt(dx * dx + dy * dy)
        let springForce = (distance - length) * k
        let ax = dx / distance * springForce
        let ay = dy / distance * springForce
        
        vx += ax
        vy += ay
    }
    
    private struct Spring {
        let point:XYProvidable
        let k:Float
        let length:Float
        
        init(point:XYProvidable, k:Float, length:Float = 0) {
            self.point = point
            self.k = k
            self.length = length
        }
    }
    
    public static func ==(lhs: Particle, rhs: Particle) -> Bool {
        return lhs.id == rhs.id
    }

}
