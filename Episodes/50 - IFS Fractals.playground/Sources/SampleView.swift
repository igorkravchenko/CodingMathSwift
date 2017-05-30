import UIKit

struct Rule {
    let a:Float
    let b:Float
    let c:Float
    let d:Float
    let tx:Float
    let ty:Float
    let weight:Float
    let color:CGColor
}

public class SampleView : BaseView {
    let rules = [
        Rule(
            a: 0.85,
            b: 0.04,
            c: -0.04,
            d: 0.85,
            tx: 0,
            ty: 1.6,
            weight: 0.85,
            color: UIColor.red.cgColor
        ),
        Rule(
            a: -0.15,
            b: 0.28,
            c: 0.26,
            d: 0.24,
            tx: 0,
            ty: 0.44,
            weight: 0.07,
            color: UIColor.green.cgColor
        ),
        Rule(
            a: 0.2,
            b: -0.26,
            c: 0.23,
            d: 0.22,
            tx: 0,
            ty: 1.6,
            weight: 0.07,
            color: UIColor.blue.cgColor
        ),
        Rule(
            a: 0,
            b: 0,
            c: 0,
            d: 0.16,
            tx: 0,
            ty: 0,
            weight: 0.01,
            color: UIColor.yellow.cgColor
        ),
        ]
    
    var x:Float = 0
    var y:Float = 0
    var bitmapContext:CGContext?
    var bitapImage:CGImage?
    
    override public func setup() {
        x = Float.random()
        y = Float.random()
        let w = Int(width)
        let h = Int(height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let pixels = CFDataCreateMutable(nil, w * h) else { fatalError() }
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let bitmapContext = CGContext(
            data: CFDataGetMutableBytePtr( pixels ),
            width: w,
            height: h,
            bitsPerComponent: 8,
            bytesPerRow: w * 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
            ) else {
                fatalError()
        }
        
        bitmapContext.setFillColor(UIColor.white.cgColor)
        bitmapContext.fill(self.bounds)
        bitmapContext.translateBy(x: CGFloat(width / 2), y: CGFloat(height))
        
        guard let provider = CGDataProvider(data: pixels) else { fatalError() }
        guard let image = CGImage(
            width: w,
            height: h,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: w * 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            provider: provider,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent) else {
                fatalError()
        }
        bitapImage = image
        self.bitmapContext = bitmapContext
    }
    
    let color = UIColor.black.cgColor
    
    func iterate(context:CGContext) {
        let rule = getRule() as Rule
        let x1 = x * rule.a + y * rule.b + rule.tx
        let y1 = y * rule.c + y * rule.d + rule.ty
        x = x1
        y = y1
        plot(context: context, x: x * 50, y: -y * 50, color: rule.color)
    }
    
    func plot(context:CGContext, x:Float, y:Float, color:CGColor) {
        context.setFillColor(color)
        context.fill(CGRect(x: x, y: y, width: 0.5, height: 0.5))
    }
    
    func getRule() -> Rule {
        var rand = Float.random()
        for rule in rules {
            if rand < rule.weight {
                return rule
            }
            rand -= rule.weight
        }
        
        return rules[0]
    }
    
    override public func update(context: CGContext) {
        if let bitmapContext = self.bitmapContext {
            for _ in 0 ..< 100 {
                iterate(context:bitmapContext)
            }
            
            if let bitapImage = self.bitapImage {
                context.draw(bitapImage, in: self.bounds)
            }
        }
        requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
    }
}

