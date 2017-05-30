import UIKit
import PlaygroundSupport

class Card {
    var x:Float = 0
    var y:Float = 0
    var z:Float = 0
    var img:UIImage?
    var angle:Float = 0
}



class SampleView : BaseView {
    let fl:Float = 300
    var cards = [Card]()
    let numCards:Int = 7
    let centerZ:Float = 1000 * 1.5
    let radius:Float = 1000
    var baseAngle:Float = 0
    var rotationSpeed:Float = 0.01
    
    override func setup() {
        for i in 0 ..< numCards {
            let card = Card()
            card.y = 0
            card.angle = Float.pi * 2 / Float(numCards) * Float(i)
            card.img = UIImage(named:"postcard\(i).jpg")
            card.x = cosf(card.angle + baseAngle) * radius
            card.z = centerZ + sinf(card.angle) * radius
            cards.append(card)
        }
    }

    override func handleTouchMoved(touchX: Float, touchY: Float) {
        rotationSpeed = (touchX - width / 2) * 0.00005
    }
    
    let zeroPoint = CGPoint()
    
    override func update(context: CGContext) {
        baseAngle += rotationSpeed
        cards.sort(by: zsort)
        context.translateBy(x: CGFloat(width / 2), y: CGFloat(height / 2))
        
        let screenScale = UIScreen.main.scale
        
        for card in cards {
            let perspective = fl / (fl + card.z)
            context.saveGState()
            context.scaleBy(x: CGFloat(perspective), y: CGFloat(perspective))
            context.translateBy(x: CGFloat(card.x), y: CGFloat(card.y))
            
            guard let img = card.img else { continue }
            guard let cgImg = img.cgImage else { continue }
            context.translateBy(x: -CGFloat(cgImg.width) / screenScale / 2, y: -CGFloat(cgImg.height) / screenScale / 2)
            img.draw(at: zeroPoint)
            
            context.restoreGState()
            
            card.x = cosf(card.angle + baseAngle) * radius
            card.z = centerZ + sinf(card.angle + baseAngle) * radius
        }
        requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
    }
    
    func zsort(_ cardA:Card, _ cardB:Card) -> Bool {
        return cardA.z > cardB.z
    }
}


let starsView = UIImageView(image:UIImage(named:"stars"))
starsView.isUserInteractionEnabled = true
starsView.contentMode = .scaleAspectFill
starsView.frame = CGRect(x: 0, y: 0, width: 3200 / 3, height: 1800 / 3)
let view = SampleView(frame:starsView.frame)
view.backgroundColor = UIColor.clear
starsView.addSubview(view)
PlaygroundPage.current.liveView = starsView
PlaygroundPage.current.needsIndefiniteExecution = true

