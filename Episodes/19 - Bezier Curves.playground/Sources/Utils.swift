import Foundation

public protocol XYProvidable {
    var x:Float { get }
    var y:Float { get }
}

public protocol XYAssignable : XYProvidable {
    var x:Float { get set }
    var y:Float { get set }
}

public protocol CircleProvidable : XYProvidable {
    var radius:Float { get }
}

public protocol RectangleProvidable : XYProvidable {
    var width:Float { get }
    var height:Float { get }
}

public struct Utils {
    
    public static func norm(value:Float, min:Float, max:Float) -> Float {
        return (value - min) / (max - min)
    }
    
    public static func lerp(norm:Float, min:Float, max:Float) -> Float {
        return (max - min) * norm + min
    }
    
    public static func map(value:Float, sourceMin:Float, sourceMax:Float, destMin:Float, destMax:Float) -> Float {
        return lerp(norm: norm(value: value, min: sourceMin, max: sourceMax), min: destMin, max: destMax)
    }
    
    public static func clamp(value:Float, min:Float, max:Float) -> Float {
        return Float.minimum(Float.maximum(value, Float.minimum(min, max)), Float.maximum(min, max))
    }
    
    public static func distance(_ p0:XYProvidable, _ p1:XYProvidable) -> Float {
        let dx = p1.x - p0.x
        let dy = p1.y - p0.y
        return sqrt(dx * dx + dy * dy)
    }
    
    public static func distanceXY(x0:Float, y0:Float, x1:Float, y1:Float) -> Float {
        let dx = x1 - x0
        let dy = y1 - y0
        return sqrt(dx * dx + dy * dy)
    }
    
    public static func circleCollision(_ c0:CircleProvidable, _ c1:CircleProvidable) -> Bool {
        return distance(c0, c1) <= (c0.radius + c1.radius)
    }
    
    public static func circlePointCollision(x:Float, y:Float, circle:CircleProvidable) -> Bool {
        return distanceXY(x0: x, y0: y, x1: circle.x, y1: circle.y) < circle.radius
    }
    
    public static func pointInRectCollision(x:Float, y:Float, rect:RectangleProvidable) -> Bool {
        return inRange(value: x, min: rect.x, max: rect.x + rect.width) &&
               inRange(value: y, min: rect.y, max: rect.y + rect.height)
    }
    
    public static func inRange(value:Float, min:Float, max:Float) -> Bool {
        return value >= Float.minimum(min, max) && value <= Float.maximum(min, max)
    }
    
    public static func rangeIntersect(min0:Float, max0:Float, min1:Float, max1:Float) -> Bool {
        return Float.maximum(min0, max0) >= Float.minimum(min1, max1) && Float.minimum(min0, max0) <= Float.maximum(min1, max1)
    }
    
    public static func rectInersect(r0:RectangleProvidable, r1:RectangleProvidable) -> Bool {
        return rangeIntersect(min0: r0.x, max0: r0.x + r0.width, min1: r1.x, max1: r1.x + r1.width) &&
               rangeIntersect(min0: r0.y, max0: r0.y + r0.height, min1: r1.y, max1: r1.y + r1.height)
    }
    
    public static func randomRange(min:Float, max:Float) -> Float {
        return min + Float.random() * (max - min)
    }
    
    private struct Point : XYAssignable {
        var x:Float = 0
        var y:Float = 0
    }
    
    public static func quadraticBezier(p0:XYProvidable, p1:XYProvidable, p2:XYProvidable, t:Float, pFinal:inout XYAssignable) -> XYProvidable {
        pFinal.x = powf(1 - t, 2) * p0.x +
                    (1 - t) * 2 * t * p1.x +
                    t * t * p2.x
        pFinal.y = powf(1 - t, 2) * p0.y +
                    (1 - t) * 2 * t * p1.y +
                    t * t * p2.y
        return pFinal
    }
    
    public static func cubicBezier(p0:XYProvidable, p1:XYProvidable, p2:XYProvidable, p3:XYProvidable, t:Float, pFinal:inout XYAssignable) -> XYProvidable {
        pFinal.x = powf(1 - t, 3) * p0.x +
                    powf(1 - t, 2) * 3 * t * p1.x +
                    (1 - t) * 3 * t * t * p2.x +
                    t * t * t * p3.x
        
        pFinal.y = powf(1 - t, 3) * p0.y +
            powf(1 - t, 2) * 3 * t * p1.y +
            (1 - t) * 3 * t * t * p2.y +
            t * t * t * p3.y
        return pFinal
    }
    
    public static func cubicBezier(p0:XYProvidable, p1:XYProvidable, p2:XYProvidable, p3:XYProvidable, t:Float) -> XYProvidable {
        var p = Point() as XYAssignable
        return cubicBezier(p0: p0, p1: p1, p2: p2, p3: p3, t: t, pFinal: &p)
    }
}
