import UIKit
import PlaygroundSupport

struct Prize {
    let prize:String
    let chance:Float
}

class SampleView : BaseView {
    
    override func setup() {
        
    }
    
    let lose:Float = 0.5
    let goldPiece:Float = 0.25
    let treasureChest:Float = 0.07
    let poison:Float = 0.08
    let food:Float = 0.1
    
    let prizes = [
        Prize(prize: "nothing", chance: 0.5),
        Prize(prize: "a gold piece", chance: 0.25),
        Prize(prize: "a treasure chest", chance: 0.07),
        Prize(prize: "poison", chance: 0.08),
        Prize(prize: "food", chance: 0.1),
    ]
    
    override func handleTouchUp(touchX: Float, touchY: Float) {
        let prize = getPrize()
        print("You won", prize)
    }
    
    func getPrize() -> String {
        var total:Float = 0
        for prize in prizes {
            total += prize.chance
        }
        
        var rand = Float.random() * total
        
        for prize in prizes {
            if rand < prize.chance {
                return prize.prize
            }
            rand -= prize.chance
        }
        return ""
    }
}

let view = SampleView(frame:CGRect(x:0, y:0, width:800, height:600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true

