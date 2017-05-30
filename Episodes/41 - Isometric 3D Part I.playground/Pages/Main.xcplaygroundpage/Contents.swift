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

extension UIColor {
    convenience init(color24:Int) {
        let r = color24 >> 16
        let g = color24 >> 8 & 0xFF
        let b = color24 & 0xFF
        self.init(red:CGFloat(r) / 0xFF, green:CGFloat(g) / 0xFF, blue:CGFloat(b) / 0xFF, alpha: 1)
    }
}

class SampleView : BaseView {
    let tileWidth:Float = 100
    let tileHeight:Float = 50
    
    override func setup() {
        
    }
    
    func drawTile(context:CGContext, x:Float, y:Float, color:CGColor) {
        context.saveGState()
        context.translateBy(x: CGFloat((x - y) * tileWidth / 2), y: CGFloat((x + y) * tileHeight / 2))
        context.beginPath()
        context.move(to: CGPoint.zero)
        context.addLine(to: CGPoint(x: tileWidth / 2, y: tileHeight / 2))
        context.addLine(to: CGPoint(x: 0, y: tileHeight))
        context.addLine(to: CGPoint(x: -tileWidth / 2, y: tileHeight / 2))
        context.closePath()
        context.setFillColor(color)
        context.fillPath()
        context.restoreGState()
    }
    
    override func update(context: CGContext) {
        context.translateBy(x: CGFloat(width / 2), y: 50)
        //drawTile(context: context, x: 0, y: 0, color: UIColor.red.cgColor)
        //drawTile(context: context, x: 1, y: 0, color: UIColor.green.cgColor)
        //drawTile(context: context, x: 2, y: 0, color: UIColor.blue.cgColor)
        //drawTile(context: context, x: 0, y: 1, color: UIColor.yellow.cgColor)
        //drawTile(context: context, x: 0, y: 2, color: UIColor.purple.cgColor)
        for x in 0 ..< 10 {
            for y in 0 ..< 10 {
                //drawTile(context: context, x: Float(x), y: Float(y), color: randomColor())
                drawBlock(context: context, x: Float(x), y: Float(y), z: floor(Float.random() * 4))
                
            }
        }
        
    }
    
    func drawBlock(context:CGContext, x:Float, y:Float, z:Float) {
        let top = 0xeeeeee
        let right = 0xcccccc
        let left = 0x999999
        
        context.saveGState()
        context.translateBy(x: CGFloat((x - y) * tileWidth / 2), y: CGFloat((x + y) * tileHeight / 2))
        // draw top
        context.beginPath()
        context.move(to: CGPoint(x: 0, y: -z * tileHeight))
        context.addLine(to: CGPoint(x: tileWidth / 2, y: tileHeight / 2 - z * tileHeight))
        context.addLine(to: CGPoint(x: 0, y: tileHeight - z * tileHeight))
        context.addLine(to: CGPoint(x: -tileWidth / 2, y: tileHeight / 2 - z * tileHeight))
        context.closePath()
        context.setFillColor(UIColor(color24: top).cgColor)
        context.fillPath()
        // draw left
        context.beginPath()
        context.move(to: CGPoint(x: -tileWidth / 2, y: tileHeight / 2 - z * tileHeight))
        context.addLine(to: CGPoint(x: 0, y: tileHeight - z * tileHeight))
        context.addLine(to: CGPoint(x: 0, y: tileHeight))
        context.addLine(to: CGPoint(x: -tileWidth / 2, y: tileHeight / 2))
        context.closePath()
        context.setFillColor(UIColor(color24: left).cgColor)
        context.fillPath()
        // draw right
        context.beginPath()
        context.move(to: CGPoint(x: tileWidth / 2, y: tileHeight / 2 - z * tileHeight))
        context.addLine(to: CGPoint(x: 0, y: tileHeight - z * tileHeight))
        context.addLine(to: CGPoint(x: 0, y: tileHeight))
        context.addLine(to: CGPoint(x: tileWidth / 2, y: tileHeight / 2))
        context.closePath()
        context.setFillColor(UIColor(color24: right).cgColor)
        context.fillPath()
        
        context.restoreGState()

    }
    
    func randomColor() -> CGColor {
        let r = Float.random()
        let g = Float.random()
        let b = Float.random()
        return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1).cgColor
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
