import UIKit

struct Point : XYAssignable {
    var x:Float = 0
    var y:Float = 0
}

extension Point {
    var cgPoint:CGPoint {
        return CGPoint(x: x, y: y)
    }
}

extension UIView {
    func colorOfPoint(_ point:CGPoint) -> UIColor {
        let components = colorComponentsAt(x: Float(point.x), y: Float(point.y))
        let color = UIColor(red: CGFloat(components.r) / 255.0, green: CGFloat(components.g) / 255.0, blue: CGFloat(components.b) / 255.0, alpha: CGFloat(components.a) / 255.0)
        return color
    }
    
    func colorComponentsAt(x:Float, y:Float) -> (r:UInt8, g:UInt8, b:UInt8, a:UInt8) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let pixel = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let context = CGContext.init(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            fatalError()
        }
        context.translateBy(x: -CGFloat(x), y: -CGFloat(y))
        self.layer.render(in: context)
        let components = (r:pixel[0], g:pixel[1], b:pixel[2], a:pixel[3])
        pixel.deallocate(capacity: 4)
        return components
    }
}

public class SampleView : BaseView {
    var p:Particle!
    
    public var collisionView:TargetView!
    
    var imageRenderer:UIGraphicsImageRenderer!
    
    public override func setup() {
        self.backgroundColor = UIColor.clear
        
        p = Particle(x: 0, y: height / 2, speed: 10, direction: 0)
        
        imageRenderer = UIGraphicsImageRenderer(size: CGSize(width:width, height:height))
        collisionView = TargetView(frame: self.bounds)
        collisionView.destructableImage =
            imageRenderer.image {
                rendererContext in
                
                let context:CGContext = rendererContext.cgContext
                
                context.setFillColor(UIColor.black.cgColor)
                context.beginPath()
                context.addArc(
                    center: CGPoint(x: width / 2, y: height / 2),
                    radius: 200,
                    startAngle: -CGFloat.pi,
                    endAngle: CGFloat.pi,
                    clockwise: false
                )
                
                context.fillPath()
        }
    }
    
    override public func update(context: CGContext) {
        p.update()
        context.beginPath()
        context.addArc(
            center: CGPoint(x: p.x, y: p.y),
            radius: 4,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
        let colorComponents = collisionView.colorComponentsAt(x: p.x, y: p.y)
        if colorComponents.a > 0 {
            collisionView.drawHole(x: p.x, y: p.y)
            resetParticle()
        }
        else if (p.x > width) {
            resetParticle()
        }
        
        requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
    }
    
    func resetParticle() {
        p.x = 0
        p.y = height / 2
        p.setHeading(Utils.randomRange(min: -0.1, max: 0.1))
    }
    
    public class TargetView : BaseView {
        var alphaPixels:CGContext?
        var resultImage:UIImage?
        var destructableImage:UIImage? {
            willSet {
                if let cgImage = newValue?.cgImage {
                    let w = cgImage.width
                    let h = cgImage.height
                    
                    let colorSpace = CGColorSpaceCreateDeviceGray()
                    guard let pixels = CFDataCreateMutable(nil, w * h) else { fatalError() }
                    
                    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
                    
                    guard let alphaPixels =  CGContext(data: CFDataGetMutableBytePtr( pixels ), width: w , height: h , bitsPerComponent: 8 , bytesPerRow: w , space: colorSpace , bitmapInfo: bitmapInfo.rawValue) else { fatalError() }
                    guard let provider = CGDataProvider(data: pixels) else { fatalError() }
                    alphaPixels.setFillColor(UIColor.black.cgColor)
                    alphaPixels.fill(CGRect(x: 0, y: 0, width: w, height: h))
                    
                    guard let mask = CGImage(maskWidth: Int(w), height: Int(h), bitsPerComponent: 8, bitsPerPixel: 8, bytesPerRow: Int(w), provider: provider, decode: nil, shouldInterpolate: false) else { fatalError() }
                    
                    guard let maskedResultImage = cgImage.masking(mask) else { fatalError() }
                    resultImage = UIImage(cgImage: maskedResultImage)
                    self.alphaPixels = alphaPixels
                }
            }
        }

        override public func setup() {
            backgroundColor = UIColor.clear
            isOpaque = false
        }
        
        let zeroPoint = CGPoint()
        
        override public func update(context: CGContext) {
            resultImage?.draw(in: bounds)
        }
        
        let whiteColor = UIColor.white.cgColor
        
        func drawHole(x:Float, y:Float) {
            guard let bitmapContext = alphaPixels else { return }
            let scale = Float(UIScreen.main.scale)
            let p = CGPoint(x: x * scale, y: height * scale - y * scale)
            bitmapContext.setFillColor(whiteColor)
            bitmapContext.beginPath()
            bitmapContext.addArc(
                center: p,
                radius: 20,
                startAngle: -CGFloat.pi,
                endAngle: CGFloat.pi,
                clockwise: false
            )
            bitmapContext.fillPath()
            setNeedsDisplay()
        }
    }
}
