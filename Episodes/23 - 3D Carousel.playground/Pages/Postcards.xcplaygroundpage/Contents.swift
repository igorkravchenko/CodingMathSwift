import UIKit
import PlaygroundSupport

class Card {
    var x:Float = 0
    var y:Float = 0
    var z:Float = 0
    var img:UIImage?
}



class SampleView : BaseView {
    let fl:Float = 300
    var cards = [Card]()
    let numCards:Int = 21
    
    override func setup() {
        for i in 0 ..< numCards {
            let card = Card()
            card.x = Utils.randomRange(min: -1000, max: 1000)
            card.y = Utils.randomRange(min: -1000, max: 1000)
            card.z = Utils.randomRange(min: 0, max: 5000)
            card.img = UIImage(named:"postcard\(i % 7).jpg")
            cards.append(card)
        }
    }
    
    let zeroPoint = CGPoint()
    
    override func update(context: CGContext) {
        context.translateBy(x: CGFloat(width / 2), y: CGFloat(height / 2))
        
        let screenScale = UIScreen.main.scale
        
        for card in cards {
            let perspective = fl / (fl + card.z)
            context.saveGState()
            context.translateBy(x: CGFloat(card.x * perspective), y: CGFloat(card.y * perspective))
            context.scaleBy(x: CGFloat(perspective), y: CGFloat(perspective))
            
            guard let img = card.img else { continue }
            guard let cgImg = img.cgImage else { continue }
            context.translateBy(x: -CGFloat(cgImg.width) / screenScale / 2, y: -CGFloat(cgImg.height) / screenScale / 2)
            img.draw(at: zeroPoint)
            
            context.restoreGState()
            
            card.z -= 5
            if card.z < 0 {
                card.z = 5000
            }
        }
        requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
    }
}


let starsView = UIImageView(image:UIImage(named:"stars"))
starsView.contentMode = .scaleAspectFill
starsView.frame = CGRect(x: 0, y: 0, width: 3200 / 5, height: 1800 / 5)
let view = SampleView(frame:starsView.frame)
view.backgroundColor = UIColor.clear
starsView.addSubview(view)
PlaygroundPage.current.liveView = starsView
PlaygroundPage.current.needsIndefiniteExecution = true
