import UIKit

struct Circle {
    var x:Float
    var y:Float
    var r:Float
}

public class SampleView : BaseView {
    var circles = [Circle]()
    let min:Float = 5
    let max:Float = 100
    var imageRenderer:UIGraphicsImageRenderer?
    let imageView = UIImageView()
    
    override public func setup() {
        imageRenderer = UIGraphicsImageRenderer(bounds: bounds)
        imageView.frame = bounds
        addSubview(imageView)
        draw()
        
    }
    
    func draw() {
        var c = createCircle()
        var counter = 0
        while !isValid(c) {
            c.x = Float.random() * 600
            c.y = Float.random() * 600
            counter += 1
            if counter > 100000 {
                return
            }
        }
        
        while isValid(c) {
            c.r += 1
        }
        
        c.r -= 2
        
        circles.append(c)
        drawCircle(c)
        requestAnimationFrame(#selector(draw as () -> ()))
    }
    
    func isValid(_ c:Circle) -> Bool {
        if c.r > max {
            return false
        }
        
        for c2 in circles {
            let dx = c2.x - c.x
            let dy = c2.y - c.y
            let dist = sqrt(dx * dx + dy * dy)
                
            if dist < c2.r + c.r {
                return false
            }
        }
        
        return true
    }
    
    func createCircle() -> Circle {
        return Circle(
            x: Float.random() * 600,
            y: Float.random() * 600,
            r: min
        )
    }
    
    let color = UIColor.black
    func drawCircle(_ circle:Circle) {
        if circle.r > max * 0.5 {
            return
        }
        
        
        guard let renderer = imageRenderer else {
            return
        }
        
        imageView.image =
        renderer.image {
            [unowned self] rendererContext in
            let context = rendererContext.cgContext
            self.imageView.image?.draw(at: CGPoint.zero)
            
            context.setShadow(offset: CGSize(width: 5, height: 5), blur: 10)
            context.beginPath()
            context.addArc(
                center: CGPoint(x: circle.x, y: circle.y),
                radius: CGFloat(circle.r),
                startAngle: -CGFloat.pi,
                endAngle: CGFloat.pi,
                clockwise: false
            )
            context.fillPath()
        }
    }
}
