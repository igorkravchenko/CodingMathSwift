import Foundation

open class Vector {
    private var _x:Float = 1
    private var _y:Float = 0
    
    public init(x:Float, y:Float) {
        _x = x
        _y = y
    }
    
    public func setX(_ value:Float) {
        return _x = value
    }
    
    public func getX() -> Float {
        return _x
    }
    
    public func setY(_ value:Float) {
        _y = value
    }
    
    public func getY() -> Float {
        return _y
    }
    
    public func setAngle(_ angle:Float) {
        let length = getLength()
        _x = cos(angle) * length
        _y = sin(angle) * length
    }
    
    public func getAngle() -> Float {
        return atan2(_y, _x)
    }
    
    public func setLength(_ length:Float) {
        let angle = getAngle()
        _x = cos(angle) * length
        _y = sin(angle) * length
    }
    
    public func getLength() -> Float {
        return sqrt(_x * _x + _y * _y)
    }
    
    public func add(_ v2:Vector) -> Vector {
        return Vector(x: _x + v2.getX(), y: _y + v2.getY())
    }
    
    public func subtract(_ v2:Vector) -> Vector {
        return Vector(x: _x - v2.getX(), y: _y - v2.getY())
    }
    
    public func multiply(_ val:Float) -> Vector {
        return Vector(x: _x * val, y: _y * val)
    }
    
    public func divide(_ val:Float) -> Vector {
        return Vector(x: _x / val, y: _y / val)
    }
    
    public func addTo(_ v2:Vector) {
        _x += v2.getX()
        _y += v2.getY()
    }
    
    public func subtractFrom(_ v2:Vector) {
        _x -= v2.getX()
        _y -= v2.getY()
    }
    
    public func multiplyBy(_ val:Float) {
        _x *= val
        _y *= val
    }
    
    public func divideBy(_ val:Float) {
        _x /= val
        _y /= val
    }
}
