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

extension UIButton {
    static func buttonWithText(_ text:String) -> UIButton {
        let button = UIButton(type: .roundedRect)
        button.setTitle(text, for: .normal)
        button.frame = CGRect(
            x: 0,
            y: 0, width: 44.0,
            height: 44.0
        )
        return button
    }
}

class SampleView : BaseView {
    static let tileWidth:Float = 60
    static let tileHeight:Float = 30
    
    var tileWidth:Float {
        return SampleView.tileWidth
    }
    
    var tileHeight:Float {
        return SampleView.tileHeight
    }
    
    var img:UIImage?
    
    var charX:Float = 0.5
    var charY:Float = 9.5
    
    let leftButton = UIButton.buttonWithText("←")
    let rightButton = UIButton.buttonWithText("→")
    let upButton = UIButton.buttonWithText("↑")
    let downButton = UIButton.buttonWithText("↓")
    
    /*
     let grid = [
     ["blue", "blue", "blue",  "blue", "blue",   "blue",    "blue", "blue", "blue", "blue"],
     ["blue", "red",  "red",   "red",  "red",    "red",     "red",  "red",  "red", "blue"],
     ["blue", "red",  "red",   "red",  "red",    "red",     "red",  "red",  "red", "blue"],
     ["blue", "red",  "red",   "red",  "red",    "red",     "red",  "red",  "red", "blue"],
     ["blue", "red",  "red",   "red",  "yellow", "yellow",  "red",  "red",  "red", "blue"],
     ["blue", "red",  "red",   "red",  "yellow", "yellow",  "red",  "red",  "red", "blue"],
     ["blue", "red",  "red",   "red",  "red",    "red",     "red",  "red",  "red", "blue"],
     ["blue", "red",  "red",   "red",  "red",    "red",     "red",  "red",  "red", "blue"],
     ["blue", "red",  "red",   "red",  "red",    "red",     "red",  "red",  "red", "blue"],
     ["blue", "blue", "blue",  "blue", "blue",   "blue",    "blue", "blue", "blue", "blue"],
     ]
     */
    /*
     let grid = [
     [1, 1, 1,  1, 1,  1,  1, 1, 1, 1],
     [1, 0, 0,  0, 0,  0,  0, 0, 0, 1],
     [1, 0, 0,  0, 0,  0,  0, 0, 0, 1],
     [1, 0, 0,  0, 0,  0,  0, 0, 0, 1],
     [1, 0, 0,  0, 2,  2,  0, 0, 0, 1],
     [1, 0, 0,  0, 2,  2,  0, 0, 0, 1],
     [1, 0, 0,  0, 0,  0,  0, 0, 0, 1],
     [1, 0, 0,  0, 0,  0,  0, 0, 0, 1],
     [1, 0, 0,  0, 0,  0,  0, 0, 0, 1],
     [1, 1, 1,  1, 1,  1,  1, 1, 1, 1],
     ]
     */
    
    let grid = [
        [15, 15, 15, 14, 13, 10, 3, 2, 1, 0],
        [15, 15, 14, 13, 10, 10, 3, 2, 1, 0],
        [15, 14, 13, 10, 10, 3, 3, 2, 1, 0],
        [14, 13, 10, 9, 3, 3, 2, 1, 0, 0],
        [13, 10, 9, 7, 3, 2, 1, 0, 0, 0],
        [10, 9, 7, 6, 3, 2, 1, 0, 0, 0],
        [9, 7, 6, 5, 3, 2, 1, 1, 1, 1],
        [7, 6, 5, 3, 3, 2, 2, 2, 2, 2],
        [6, 5, 5, 3, 3, 3, 3, 3, 3, 3],
        [5, 5, 5, 5, 5, 5, 5, 5, 5, 3]
    ]
    
    init(frame: CGRect, charView:CharacterView) {
        _charView = charView
        super.init(frame: frame)
        addSubview(_charView)
        
        leftButton.center = CGPoint(x: 44, y: height - 44)
        addSubview(leftButton)
        leftButton.addTarget(self, action: #selector(moveCharacter(_:)), for: .touchUpInside)
        rightButton.center = CGPoint(x: 88, y: height - 44)
        addSubview(rightButton)
        rightButton.addTarget(self, action: #selector(moveCharacter(_:)), for: .touchUpInside)
        upButton.center = CGPoint(x: 66, y: height - 66)
        addSubview(upButton)
        upButton.addTarget(self, action: #selector(moveCharacter(_:)), for: .touchUpInside)
        downButton.center = CGPoint(x: 66, y: height - 22)
        addSubview(downButton)
        downButton.addTarget(self, action: #selector(moveCharacter(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setup() {
        img = UIImage(named: "tileset")
        drawCharacter(x: charX, y: charY)
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
        draw(context: context)
        
    }
    
    func moveCharacter(_ button:UIButton) {
        switch button {
        case leftButton:
            if canMove(x: charX - 1, y: charY) {
                charX -= 1
                drawCharacter(x: charX, y: charY)
            }
        case rightButton:
            if canMove(x: charX + 1, y: charY) {
                charX += 1
                drawCharacter(x: charX, y: charY)
            }
        case upButton:
            if canMove(x: charX, y: charY - 1) {
                charY -= 1
                drawCharacter(x: charX, y: charY)
            }
        case downButton:
            if canMove(x: charX, y: charY + 1) {
                charY += 1
                drawCharacter(x: charX, y: charY)
            }
            
        default:
            break
        }
    }
    
    func draw(context:CGContext) {
        for y in 0 ..< grid.count {
            let row = grid[y]
            for x in 0 ..< row.count {
                drawImageTile(context: context, x: Float(x), y: Float(y), index: row[x])
            }
        }
    }
    
    func canMove(x:Float, y:Float) -> Bool {
        let x = Int(floor(x))
        let y = Int(floor(y))
        if y < 0 || y >= grid.count {
            return false
        }
        if x < 0 || y >= grid[y].count {
            return false
        }
        let tile = grid[y][x]
        if tile < 4 || tile > 14 {
            return false
        }
        return true
    }
    
    func drawImageTile(context:CGContext, x:Float, y:Float, index:Int) {
        guard let cgImg = self.img?.cgImage else { fatalError() }
        context.saveGState()
        context.translateBy(x: CGFloat((x - y) * tileWidth / 2), y: CGFloat((x + y) * tileHeight / 2 - 11 + (index < 4 ? 5 : 0)))
        let tileRect = CGRect(x: Float(index) * tileWidth, y: 0, width: tileWidth, height: Float(cgImg.height))
        guard let tileCgImg = cgImg.cropping(to: tileRect) else { fatalError() }
        UIImage(cgImage: tileCgImg).draw(in: CGRect(x: -tileWidth / 2, y: 0, width: tileWidth, height: Float(cgImg.height)))
        context.restoreGState()
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
    
    unowned private var _charView:CharacterView
    
    func drawCharacter(x:Float, y:Float) {
        _charView.issueRenderChar(x: x, y: y)
    }
}

class CharacterView : BaseView {
    
    var tileWidth:Float {
        return SampleView.tileWidth
    }
    
    var tileHeight:Float {
        return SampleView.tileHeight
    }
    
    var character:UIImage?
    
    override func setup() {
        backgroundColor = UIColor.clear
        character = UIImage(named: "ball")
    }
    
    func drawCharacter(context:CGContext, character:UIImage, x:Float, y:Float) {
        context.saveGState()
        guard let image = character.cgImage else { fatalError() }
        context.translateBy(x: CGFloat((x - y) * tileWidth / 2), y: CGFloat((x + y) * tileHeight / 2))
        
        character.draw(at: CGPoint(x: Float(-image.width) / 2, y: Float(-image.height)))
        
        context.restoreGState()
    }
    
    override func update(context: CGContext) {
        context.translateBy(x: CGFloat(width / 2), y: 50)
        guard let image = character else {
            fatalError()
        }
        drawCharacter(context: context, character: image, x: charX, y: charY)        
    }
    
    var charX:Float = 0
    var charY:Float = 0
    
    func issueRenderChar(x:Float, y:Float) {
        charX = x
        charY = y
        setNeedsDisplay()
    }
}

let rect = CGRect(x:0, y:0, width:800, height:600)
let charView = CharacterView(frame: rect)
let view = SampleView(frame:rect, charView: charView)
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
