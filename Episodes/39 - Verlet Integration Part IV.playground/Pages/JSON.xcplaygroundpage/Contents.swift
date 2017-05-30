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



extension Point {
    convenience init(raw:[String : Any]) {
        let x = raw["x"] as? Float ?? 0
        let y = raw["y"] as? Float ?? 0
        let oldx = raw["oldx"] as? Float ?? 0
        let oldy = raw["oldy"] as? Float ?? 0
        let pinned = raw["pinned"] as? Bool ?? false
        self.init(x: x, y: y, oldx: oldx, oldy: oldy, pinned: pinned)
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

extension Stick {
    init(raw:[String : Any], points:[Point]) {
        //let p = Point(x: 0, y: 0, oldx: 0, oldy: 0, pinned: false)
        //self.init(p0:p, p1:p, length: 1)
        let i0 = raw["p0"] as? Int ?? 0
        let i1 = raw["p1"] as? Int ?? 0
        let hidden = raw["hidden"] as? Bool ?? false
        self.init(p0: points[i0], p1: points[i1], length: Utils.distance(points[i0], points[i1]), hidden: hidden)
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
    var points = [Point]()
    
    var sticks = [Stick]()
    let bounce:Float = 0.9
    let gravity:Float = 0.5
    let friction:Float = 0.999
    var engine:Engine!
    
    override func setup() {
        getJSON()
        engine = Engine(
            baseX: 450,
            baseY: 100,
            range: 100,
            angle: 0,
            speed: 0.05,
            point: points[4]
        )

        setNeedsDisplay()
    }
    
    func getJSON() {
        guard let filePath = Bundle.main.path(forResource: "model", ofType: "json") else { fatalError() }
        
        // get the contentData
        guard let contentData = FileManager.default.contents(atPath: filePath) else { fatalError() }
        
        
        
        // get the string
        //let content = String(data: contentData, encoding: .utf8)
        guard let raw = try? JSONSerialization.jsonObject(with: contentData, options: JSONSerialization.ReadingOptions(rawValue:0)) as! [String : [ [String : Any] ]] else { fatalError() }
        
        guard let rawPoints = raw["points"] else { fatalError() }
        
        for rawPoint in rawPoints {
            points.append(Point(raw: rawPoint))
        }
        
        guard let rawSticks = raw["sticks"] else { fatalError() }
        
        for rawStick in rawSticks {
            sticks.append(Stick(raw: rawStick, points: points))
        }
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
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
