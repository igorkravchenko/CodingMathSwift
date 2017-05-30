import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    
    override func setup() {
        let view = UIView(frame:CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = UIColor.black
        addSubview(view)
        
        // [sx, 0,  tx,      or          [cos, sin, tx,
        //  0,  sy, ty]                  -sin, cos, ty]
        
        // [a, b, e,         or          [a, b, tx,
        //  c, d, f]                      c, d, ty]
        
        let angle = -CGFloat.pi / 4
        let cosine = cos(angle) as CGFloat
        let sine = sin(angle) as CGFloat
        
        // Order matters:
        
        // Rotation                 // Scaling
        // [cos, sin,       x       [sx, 0,
        // -sin, cos]                 0, sy]
        
        
        // Rotation + Scaling
        // [cos * sx + sin * 0, cos * 0 + sin * sy,         =       [cos * sx, sin * sy,
        // [-sin * sx + cos * 0, -sin * 0 + cos * sy]               -sin * sx, cos * sy]
        
        
        // Scale                        // Rotate
        // [sx, 0           x           [cos, sin,          =       [sx * cos + 0 * -sin, sx * sin + 0 * cos,           =           [sx * cos, sx * sin,
        //  0, sy]                      -sin, cos]                   0 * cos + sy * -sin, 0 * sin + sy * cos]                       sy * -sin, sy * cos]

        // rotation + scaling
        
        //let sx:CGFloat = 2
        //let sy:CGFloat = 1
        //let transform = CGAffineTransform(a: cosine * sx, b: sine * sy, c: -sine * sx, d: cosine * sy, tx: 200, ty: 300)
        //view.transform = transform
        
        // scaling + rotation
        let sx:CGFloat = 1
        let sy:CGFloat = 0.5
        let transform = CGAffineTransform(a: cosine * sx, b: sine * sx, c: -sine * sy, d: cosine * sy, tx: 200, ty: 300)
        view.transform = transform
    }
    

    
    override func update(context: CGContext) {
        
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:600, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true

