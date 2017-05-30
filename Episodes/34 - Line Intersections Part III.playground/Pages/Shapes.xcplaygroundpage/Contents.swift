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

class Star : XYProvidable {
    var x:Float
    var y:Float
    
    init(x:Float, y:Float) {
        self.x = x
        self.y = y
    }
    
    var points = [
        Point(x: 0, y:0),
        Point(x: 0, y:0),
        Point(x: 0, y:0),
        Point(x: 0, y:0),
        Point(x: 0, y:0),
        Point(x: 0, y:0),
        Point(x: 0, y:0),
        Point(x: 0, y:0),
        Point(x: 0, y:0),
        Point(x: 0, y:0)
    ]
    var offset = [
        Point(x: 100,   y:0),
        Point(x: 40,    y:29),
        Point(x: 31,    y:95),
        Point(x: -15,   y:48),
        Point(x: -81,   y:59),
        Point(x: -50,   y:0),
        Point(x: -81,   y:-59),
        Point(x: -15,   y:-48),
        Point(x: 31,    y:-95),
        Point(x: 40,    y:-29)
    ]
}

class SampleView : BaseView {
    
    let star0 = Star(x: 200, y: 200)
    let star1 = Star(x: 600, y: 200)

    let blackColor = UIColor.black.cgColor
    let redColor = UIColor.red.cgColor
    
    override func update(context: CGContext) {
        updateStar(star0)
        updateStar(star1)
        
        if checkStarCollision(star0, star1) {
            context.setFillColor(redColor)
        }
        else {
            context.setFillColor(blackColor)
        }
        
        drawStar( star0, inContext: context)
        drawStar( star1, inContext: context)
    }
    
    
    override func handleTouchMoved(touchX: Float, touchY: Float) {
        star0.x = touchX
        star0.y = touchY
        setNeedsDisplay()
    }
    
    func checkStarCollision(_ starA:Star, _ starB:Star) -> Bool {
        for i in 0 ..< starA.points.count {
            let p0 = starA.points[i]
            let p1 = starA.points[(i + 1) % starA.points.count]
            
            for j in 0 ..< starB.points.count {
                let p2 = starB.points[j]
                let p3 = starB.points[(j + 1) % starB.points.count]
                
                if let _ = segmentIntersect(p0: p0, p1: p1, p2: p2, p3: p3) {
                    return true
                }
            }
        }
        return false
    }
    
    func updateStar(_ star:Star) {
        for i in 0 ..< star.points.count {
            star.points[i].x = star.x + star.offset[i].x
            star.points[i].y = star.y + star.offset[i].y
        }
    }
    
    func drawStar(_ star:Star, inContext context:CGContext) {
        context.beginPath()
        context.move(to: star.points[0].cgPoint)
        for i in 1 ..< star.points.count {
            context.addLine(to: star.points[i].cgPoint)
        }
        context.closePath()
        context.fillPath()
    }
    
    func segmentIntersect(p0:XYProvidable, p1:XYProvidable, p2:XYProvidable, p3:XYProvidable) -> XYProvidable? {
        let A1 = p1.y - p0.y
        let B1 = p0.x - p1.x
        let C1 = A1 * p0.x + B1 * p0.y
        let A2 = p3.y - p2.y
        let B2 = p2.x - p3.x
        let C2 = A2 * p2.x + B2 * p2.y
        let denominator = A1 * B2 - A2 * B1
        
        if denominator == 0 {
            return nil
        }
        
        let intersectX = (B2 * C1 - B1 * C2) / denominator
        let intersectY = (A1 * C2 - A2 * C1) / denominator
        let rx0 = (intersectX - p0.x) / (p1.x - p0.x)
        let ry0 = (intersectY - p0.y) / (p1.y - p0.y)
        let rx1 = (intersectX - p2.x) / (p3.x - p2.x)
        let ry1 = (intersectY - p2.y) / (p3.y - p2.y)
        if ((rx0 >= 0 && rx0 <= 1) || (ry0 >= 0 && ry0 <= 1)) &&
            ((rx1 >= 0 && rx1 <= 1) || (ry1 >= 0 && ry1 <= 1)) {
            return Point(x: intersectX, y: intersectY)
        }
        
        return nil
    }
    
    
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
