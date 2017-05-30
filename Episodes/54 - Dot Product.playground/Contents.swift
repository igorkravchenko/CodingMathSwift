//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

class Point : XYAssignable {
    var x:Float = 0
    var y:Float = 0
    
    init(x:Float, y:Float) {
        self.x = x
        self.y = y
    }
}

extension XYAssignable {
    var cgPoint:CGPoint {
        return CGPoint(x: x, y: y)
    }
}

class Vec {
    let x:Float
    let y:Float
    
    init(x:Float, y:Float) {
        self.x = x
        self.y = y
    }
}


class SampleView : BaseView {
    let p0 = Point(
        x: 200,
        y: 400
    )
    
    let p1 = Point(
        x: 250,
        y: 200
    )
    
    let p2 = Point(
        x: 350,
        y: 150
    )
    
    func vec(p0:Point, p1:Point) -> Vec {
        return Vec(
            x: p1.x - p0.x,
            y: p1.y - p0.y
        )
    }
    
    func dotProduct(v0:Vec, v1:Vec) -> Float {
        return v0.x * v1.x + v0.y * v1.y
    }
    
    override func setup() {
        setNeedsDisplay()
    }
    
    func mag(v:Vec) -> Float {
        return sqrt(v.x * v.x + v.y * v.y)
    }
    
    func normalize(v:Vec) -> Vec {
        let m = mag(v: v)
        return Vec (
            x: v.x / m,
            y: v.y / m
        )
    }
    
    func angleBetween(v0:Vec, v1:Vec) -> Float {
        let dp = dotProduct(v0: v0, v1: v1)
        let mag0 = mag(v: v0)
        let mag1 = mag(v: v1)
        return acos(dp / mag0 / mag1)
    }
    
    
    override func update(context: CGContext) {
        drawPoint(context: context, p: p0)
        drawPoint(context: context, p: p1)
        drawPoint(context: context, p: p2)
        drawLines(context: context)
        
        let v0 = vec(p0: p1, p1: p0)
        let v1 = vec(p0: p2, p1: p0)
        let angle =  round( angleBetween(v0: v0, v1: v1) * 180 / Float.pi)
        ("\(angle)" as NSString).draw(at: CGPoint.zero, withAttributes: nil)
    }
    
    func drawPoint(context: CGContext, p: Point) {
        context.beginPath()
        context.addArc(
            center: p.cgPoint,
            radius: 10,
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        context.strokePath()
    }
    
    func drawLines(context:CGContext) {
        context.beginPath()
        context.move(to: p1.cgPoint)
        context.addLine(to: p0.cgPoint)
        context.addLine(to: p2.cgPoint)
        context.strokePath()
    }
    
    var dragPoint:Point?
    override func handleTouchDown(touchX: Float, touchY: Float) {
        guard let dragPoint = findDragPoint(x: touchX, y: touchY) else {
            self.dragPoint = nil
            return
        }
        
        dragPoint.x = touchX
        dragPoint.y = touchY
        self.dragPoint = dragPoint
        setNeedsDisplay()
    }
    
    override func handleTouchMoved(touchX: Float, touchY: Float) {
        dragPoint?.x = touchX
        dragPoint?.y = touchY
        setNeedsDisplay()
    }
    
    func findDragPoint(x:Float, y:Float) -> Point? {
        if hitTest(p: p0, x: x, y: y) { return p0 }
        if hitTest(p: p1, x: x, y: y) { return p1 }
        if hitTest(p: p2, x: x, y: y) { return p2 }
        return nil
    }
    
    func hitTest(p:Point, x:Float, y:Float) -> Bool {
        let dx = p.x - x
        let dy = p.y - y
        return sqrt(dx * dx + dy * dy) <= 10
    }
}

let rect = CGRect(x: 0, y: 0, width: 600, height: 600)
let view = SampleView(frame: rect)
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
