import Foundation
import CoreGraphics

public extension CGPoint {
    init(x:Float, y:Float) {
        self.init(x:CGFloat(x), y:CGFloat(y))
    }
}

public extension CGRect {
    init(x:Float, y:Float, width:Float, height:Float) {
        self.init(x: CGFloat(x),
                  y: CGFloat(y),
                  width: CGFloat(width),
                  height: CGFloat(height))
    }
}

public extension CGSize {
    init(width:Float, height:Float) {
        self.init(width:CGFloat(width), height:CGFloat(height))
    }
}

public extension Float
{
    public static func random() -> Float {
        return Float( arc4random() % UInt32.max ) / Float( UInt32.max )
    }
}
