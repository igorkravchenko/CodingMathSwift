import UIKit
import PlaygroundSupport

class Point : XYProvidable {
    var x:Float
    var y:Float
    
    init(x:Float = 0, y:Float = 0) {
        self.x = x
        self.y = y
    }
}

extension Point {
    var cgPoint:CGPoint {
        return CGPoint(x: x, y: y)
    }
}

class SampleView : BaseView {
    let branchAngleA = -Float.pi / 4
    
    func tree(context:CGContext, x:Float, y:Float, size:Float, angle:Float, limit:Float) {
        context.saveGState()
        context.translateBy(x: CGFloat(x), y: CGFloat(y))
        context.rotate(by: CGFloat(angle))
        context.fill(CGRect(x: 0, y: 0, width: size, height: -size))
        
        // left branch
        let x0:Float = 0
        let y0:Float = -size
        let size0:Float = abs(cos(branchAngleA) * size)
        let angle0 = branchAngleA
        
        if limit > 0 {
            tree(context: context, x: x0, y: y0, size: size0, angle: angle0, limit: limit - 1)
        }
        else {
            context.saveGState()
            context.translateBy(x: CGFloat(x0), y: CGFloat(y0))
            context.rotate(by: CGFloat(angle0))
            context.fill(CGRect(x: 0, y: 0, width: size0, height: -size0))
            context.restoreGState()
        }
        
        // right branch
        let x1 = x0 + cos(angle0) * size0
        let y1 = y0 + sin(angle0) * size0
        let size1 = abs(sin(branchAngleA) * size)
        let angle1 = angle0 + Float.pi / 2
        
        if limit > 0 {
            tree(context: context, x: x1, y: y1, size: size1, angle: angle1, limit: limit - 1)
        }
        else {
            context.saveGState()
            context.translateBy(x: CGFloat(x1), y: CGFloat(y1))
            context.rotate(by: CGFloat(angle1))
            context.fill(CGRect(x: 0, y: 0, width: size1, height: -size1))
            context.restoreGState()
        }

        context.restoreGState()
    }
    
    override func update(context: CGContext) {
        tree(context: context, x: width / 2 - 75, y: height, size: 150, angle: 0, limit: 12)
    }
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
