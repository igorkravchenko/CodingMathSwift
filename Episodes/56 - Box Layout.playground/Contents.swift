import PlaygroundSupport
import UIKit

class SampleView : BaseView {
    struct Item {
        let w:Float
        let h:Float
    }
    
    enum Alignment {
        case bottom, center
    }
    
    override func update(context: CGContext) {
        context.setFillColor(
            UIColor(
                red: 0xCC / 0xFF,
                green: 0xCC / 0xFF,
                blue: 0xCC / 0xFF,
                alpha: 1
            ).cgColor
        )
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.fill(rect)
        context.setFillColor(UIColor.black.cgColor)
        
        var items = [Item]()
        for _ in 0 ..< 35 {
            items.append(
                Item(
                    w: 20 + Float.random() * 80,
                    h: 20 + Float.random() * 80
                )
            )
        }
        
        hbox(context: context, items: items, spacing: 10,  alignment: .center, wrap: true)
    }
    
    func hbox(context:CGContext, items:[Item], spacing:Float, alignment:Alignment, wrap: Bool = false) {
        var x:Float = spacing
        var y:Float = spacing
        var maxHeight:Float = 0
        var ypos:Float = 0
        
        for item in items {
            maxHeight = max(maxHeight, item.h)
        }
        
        for item in items {
            if wrap && x + item.w + spacing > width {
                x = spacing
                y += maxHeight + spacing
            }
            
            if alignment == .bottom {
                ypos = maxHeight - item.h
            }
            else if alignment == .center {
                ypos = (maxHeight - item.h) / 2
            }
            
            let rect = CGRect(x: x, y: y + ypos, width: item.w, height: item.h)
            context.fill(rect)
            x += item.w + spacing
        }
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = SampleView(
    frame: CGRect(
        x: 0,
        y: 0,
        width: 800,
        height: 600
    )
)
