import UIKit

public extension UIImage {
    class func image(color:UIColor, size:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { fatalError() }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError()
        }
        UIGraphicsEndImageContext()
        return image
    }
}

private extension UIImage {
    class func createARGBBitmapContext(forImage image:CGImage) -> CGContext? {
        let width:Int = image.width
        let height:Int = image.height
        let bytesPerRow = width * 4
        let byteCount = bytesPerRow * height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapData = UnsafeMutablePointer<UInt8>.allocate(capacity: byteCount)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext.init(
            data: bitmapData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        )
        return context
    }
}

public struct Pixel : Hashable, Equatable{
    let x:Int
    let y:Int
    let a:UInt8
    let r:UInt8
    let g:UInt8
    let b:UInt8
    
    public init(x:Int, y:Int, a:UInt8, r:UInt8, g:UInt8, b:UInt8) {
        self.x = x
        self.y = y
        self.a = a
        self.r = r
        self.g = g
        self.b = b
    }
    
    public static func ==(lhs: Pixel, rhs: Pixel) -> Bool
    {
        return lhs.x == rhs.x &&
        lhs.y == rhs.y &&
        lhs.a == rhs.a &&
        lhs.r == rhs.r &&
        lhs.g == rhs.g &&
        lhs.b == rhs.b
    }
    
    public var hashValue: Int {
        return "\(x),\(y),\(a),\(r),\(g),\(b)".hash
    }
}

public extension Pixel {
    init?(x:Int, y:Int, cgColor:CGColor) {
        guard let components = cgColor.components else {
            return nil
        }
        
        guard components.count == 4 else {
            return nil
        }
        
        self.x = x
        self.y = y
        a = UInt8(components[3] * 0xFF)
        r = UInt8(components[0] * 0xFF)
        g = UInt8(components[1] * 0xFF)
        b = UInt8(components[2] * 0xFF)
    }
}

public extension UIImage {
    func setPixels(_ pixels:Set<Pixel>) -> UIImage? {
        guard let cgImage = self.cgImage else {
            fatalError()
        }
        
        guard let context = UIImage.createARGBBitmapContext(forImage: cgImage) else {
            fatalError()
        }
        
        let width = cgImage.width
        let height = cgImage.height
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        context.clear(rect)
        context.draw(cgImage, in: rect)
        guard let mutableRawPointer = context.data else {
            fatalError()
        }
        
        let bytesPerRow = width * 4
        let byteCount = bytesPerRow * height
        let typedPointer:UnsafeMutablePointer<UInt8> = mutableRawPointer.bindMemory(to: UInt8.self, capacity: byteCount)
        
        for pixel in pixels {
            let offset = 4 * (width * pixel.y + pixel.x)
            typedPointer.advanced(by: offset).pointee = pixel.a
            typedPointer.advanced(by: offset + 1).pointee = pixel.r
            typedPointer.advanced(by: offset + 2).pointee = pixel.g
            typedPointer.advanced(by: offset + 3).pointee = pixel.b
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let finalContext = CGContext(
            data: typedPointer,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        )
        guard let image = finalContext?.makeImage() else {
            fatalError()
        }
        
        return UIImage(
            cgImage: image,
            scale: scale,
            orientation: imageOrientation)
    }
}
