import UIKit
import PlaygroundSupport

class Point : XYProvidable {
    var x:Float
    var y:Float
    var oldx:Float
    var oldy:Float
    var pinned:Bool
    
    init(x:Float = 0, y:Float = 0, oldx:Float = 0, oldy:Float = 0, pinned:Bool = false) {
        self.x = x
        self.y = y
        self.oldx = oldx
        self.oldy = oldy
        self.pinned = pinned
    }
}

extension Point {
    var cgPoint:CGPoint {
        return CGPoint(x: x, y: y)
    }
}

protocol StickPoint : XYProvidable {
    var pinned:Bool { get set }
}

struct Stick {
    let p0:Point
    let p1:Point
    let length:Float
    let hidden:Bool
    let color:CGColor
    let width:Float
    
    init(p0:Point, p1:Point, length:Float, hidden:Bool = false, color:CGColor = UIColor.black.cgColor, width:Float = 1) {
        self.p0 = p0
        self.p1 = p1
        self.length = length
        self.hidden = hidden
        self.color = color
        self.width = width
    }
}

struct Engine {
    let baseX:Float
    let baseY:Float
    let range:Float
    var angle:Float
    let speed:Float
    let point:Point
}

struct Form {
    let path:[Point]
    let color:CGColor
}

struct Image {
    let path:[Point]
    let img:UIImage
}

class SampleView : BaseView {
    let points = [
        Point(
            x: 100,
            y: 100,
            oldx: 100 + Float.random() * 50 - 25,
            oldy: 100 + Float.random() * 50 - 25
        ),
        Point(
            x: 200,
            y: 100,
            oldx: 200,
            oldy: 100
        ),
        
        Point(
            x: 200,
            y: 200,
            oldx: 200,
            oldy: 200
        ),
        
        Point(
            x: 100,
            y: 200,
            oldx: 100,
            oldy: 200
        ),
        
        Point(
            x: 400,
            y: 200,
            oldx: 400,
            oldy: 200
        ),

        Point(
            x: 250,
            y: 200,
            oldx: 250,
            oldy: 200
        )
    ]
    
    var sticks = [Stick]()
    var forms = [Form]()
    var images = [Image]()
    
    let bounce:Float = 0.9
    let gravity:Float = 0.5
    let friction:Float = 0.999
    var engine = Engine(
        baseX: 450,
        baseY: 100,
        range: 100,
        angle: 0,
        speed: 0.05,
        point: Point(
            x: 550,
            y: 100,
            pinned: true
        )
    )
    
    override func setup() {
        sticks += [
            Stick(
                p0: points[0],
                p1: points[1],
                length : distance(p0: points[0], p1: points[1])
            ),
            Stick(
                p0: points[1],
                p1: points[2],
                length: distance(p0: points[1], p1: points[2])
            ),
            Stick(
                p0: points[2],
                p1: points[3],
                length: distance(p0: points[2], p1: points[3])
            ),
            Stick(
                p0: points[3],
                p1: points[0],
                length: distance(p0: points[3], p1: points[0])
            ),
            Stick(
                p0: points[0],
                p1: points[2],
                length: distance(p0: points[0], p1: points[2]),
                hidden: true
            ),
            Stick(
                p0: engine.point,
                p1: points[4],
                length: distance(p0: engine.point, p1: points[4])
            ),
            Stick(
                p0: points[4],
                p1: points[5],
                length: distance(p0: points[4], p1: points[5])
            ),
            Stick(
                p0: points[5],
                p1: points[0],
                length: distance(p0: points[5], p1: points[0])
            ),
        ]
        
        forms.append(
            Form(
                path: [
                    points[0],
                    points[1],
                    points[2],
                    points[3]
                ],
                color: UIColor.green.cgColor
            )
        )
        
        images.append(
            Image(
                path: [
                    points[0],
                    points[1],
                    points[2],
                    points[3]
                ],
                img: UIImage(named:"cat.jpg")!
            )
        )
        
    }
    
    func distance(p0:Point, p1:Point) -> Float {
        let dx = p1.x - p0.x
        let dy = p1.y - p0.y
        return sqrt(dx * dx + dy * dy)
    }
    override func update(context: CGContext) {
        updateEngine()
        updatePoints()
        for _ in 0 ..< 3 {
            updateSticks()
            constrainPoints()
        }
        //renderPoints(context: context)
        renderSticks(context: context)
        renderEngine(context: context)
        //renderForms(context: context)
        //renderImages(context: context)
        requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
    }
    
    func updateEngine() {
        engine.point.x = engine.baseX + cos(engine.angle) * engine.range
        engine.point.y = engine.baseY + sin(engine.angle) * engine.range
        engine.angle += engine.speed
    }
    
    func updatePoints() {
        for p in points {
            if !p.pinned {
                let vx = (p.x - p.oldx) * friction
                let vy = (p.y - p.oldy) * friction
                p.oldx = p.x
                p.oldy = p.y
                p.x += vx
                p.y += vy
                p.y += gravity
            }
        }
    }
    
    func constrainPoints() {
        for p in points {
            if !p.pinned {
                let vx = (p.x - p.oldx) * friction
                let vy = (p.y - p.oldy) * friction
                
                if p.x > width {
                    p.x = width
                    p.oldx = p.x + vx * bounce
                }
                else if p.x < 0 {
                    p.x = 0
                    p.oldx = p.x + vx * bounce
                }
                if p.y > height {
                    p.y = height
                    p.oldy = p.y + vy * bounce
                }
                else if p.y < 0 {
                    p.y = 0
                    p.oldy = p.y + vy * bounce
                }
            }
        }
    }

    
    func updateSticks() {
        for s in sticks {
            let dx = s.p1.x - s.p0.x
            let dy = s.p1.y - s.p0.y
            let distance = sqrt(dx * dx + dy * dy)
            let difference = s.length - distance
            let percent = difference / distance / 2
            let offsetX = dx * percent
            let offsetY = dy * percent
            
            if !s.p0.pinned {
                s.p0.x -= offsetX
                s.p0.y -= offsetY
            }
            if !s.p1.pinned {
                s.p1.x += offsetX
                s.p1.y += offsetY
            }
        }
    }
    
    func renderPoints(context:CGContext) {
        for p in points {
            context.beginPath()
            context.addArc(center: p.cgPoint, radius: 5, startAngle: -CGFloat.pi, endAngle: CGFloat.pi, clockwise: false)
            context.fillPath()
        }
    }
    
    func renderSticks(context:CGContext) {
        for s in sticks {
            if !s.hidden {
                context.beginPath()
                context.setStrokeColor(s.color)
                context.setLineWidth(CGFloat(s.width))
                context.move(to: s.p0.cgPoint)
                context.addLine(to: s.p1.cgPoint)
                context.strokePath()
            }
        }
    }
    
    func renderEngine(context:CGContext) {
        context.beginPath()
        /*
        context.addRect(CGRect(
                x: engine.baseX - engine.range,
                y: engine.baseY - 5,
                width: engine.range * 2,
                height: 10
            )
        )
        */
        context.addArc(
            center: CGPoint(x: engine.baseX, y: engine.baseY),
            radius: CGFloat(engine.range),
            startAngle: -CGFloat.pi,
            endAngle: CGFloat.pi,
            clockwise: false)
        
        context.strokePath()
        context.addArc(
            center: engine.point.cgPoint,
            radius: 5,
            startAngle: -CGFloat.pi, endAngle:
            CGFloat.pi,
            clockwise: false
        )
        context.fillPath()
        
    }
    
    /*
    override func handleTouchDown(touchX: Float, touchY: Float) {
        points[4].pinned = !points[4].pinned
    }
    */
    // remove
    func renderForms(context:CGContext) {
        for f in forms {
            context.beginPath()
            context.setFillColor(f.color)
            context.move(to: f.path[0].cgPoint)
            for i in 1 ..< f.path.count {
                context.addLine(to: f.path[i].cgPoint)
            }
            context.fillPath()
        }
    }
    
    func renderImages(context:CGContext) {
        for image in images {
            let w = distance(p0: image.path[0], p1: image.path[1])
            let h = distance(p0: image.path[0], p1: image.path[3])
            let dx = image.path[1].x - image.path[0].x
            let dy = image.path[1].x - image.path[0].y
            let angle = atan2(dy, dx)
            
            context.saveGState()
            context.translateBy(x: CGFloat(image.path[0].x), y: CGFloat(image.path[0].y))
            context.rotate(by: CGFloat(angle))
            image.img.draw(in: CGRect(x: 0, y: 0, width: w, height: h))
            context.restoreGState()
         }
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
