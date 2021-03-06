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
    var p0:Point!
    var p1:Point!
    var branchAngleA:Float = 0
    var branchAngleB:Float = 0
    var trunkRatio:Float = 0
    
    override func setup() {
        p0 = Point(x: width / 2, y: height - 50)
        p1 = Point(x: width / 2, y: 50)
        branchAngleA = randomRange(min: -Float.pi / 2, max: Float.pi / 2)
        branchAngleB = randomRange(min: -Float.pi / 2, max: Float.pi / 2)
        trunkRatio = randomRange(min: 0.25, max: 0.75)
    }
    
    func tree(context:CGContext, p0:Point, p1:Point, limit:Int) {
        let dx = p1.x - p0.x
        let dy = p1.y - p0.y
        let dist = sqrt(dx * dx + dy * dy)
        let angle = atan2(dy, dx)
        let branchLength = dist * (1 - trunkRatio)
        let pA = Point(
            x: p0.x + dx * trunkRatio,
            y: p0.y + dy * trunkRatio
        )
        let pB = Point(
            x: pA.x + cos(angle + branchAngleA) * branchLength,
            y: pA.y + sin(angle + branchAngleA) * branchLength
        )
        let pC = Point(
            x: pA.x + cos(angle - branchAngleA) * branchLength,
            y: pA.y + sin(angle - branchAngleA) * branchLength
        )
        
        context.beginPath()
        context.move(to: p0.cgPoint)
        context.addLine(to: pA.cgPoint)
        context.strokePath()
        
        if (limit > 0) {
            tree(context: context, p0: pA, p1: pC, limit: limit - 1)
            tree(context: context, p0: pA, p1: pB, limit: limit - 1)
        }
        else {
            context.beginPath()
            context.move(to: pB.cgPoint)
            context.addLine(to: pA.cgPoint)
            context.addLine(to: pC.cgPoint)
            context.strokePath()
        }
        branchAngleA += randomRange(min: -0.02, max: 0.02)
        branchAngleB += randomRange(min: -0.02, max: 0.02)
        trunkRatio += randomRange(min: -0.02, max: 0.02)
    }
    
    func randomRange(min:Float, max:Float) -> Float {
        return min + Float.random() * (max - min)
    }
    
    override func update(context: CGContext) {
        tree(context: context, p0: p0, p1: p1, limit: 8)
    }
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
