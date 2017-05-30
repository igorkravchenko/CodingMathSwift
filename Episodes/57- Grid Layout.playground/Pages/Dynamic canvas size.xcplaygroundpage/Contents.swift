
import UIKit
import PlaygroundSupport

let cellWidth:Float = 50
let cellHeight:Float = 50
let rows = 10
let cols = 10

class SampleView : BaseView {
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
        
        for i in 0 ..< rows {
            for j in 0 ..< cols {
                context.saveGState()
                context.translateBy(x: CGFloat(Float(j) * cellWidth), y: CGFloat(Float(i) * cellHeight))
                context.fill(CGRect(x: 5, y: 5, width: CGFloat(cellWidth - 10), height: CGFloat(cellHeight - 10)))
                
                context.restoreGState()
            }
        }

    }
}

let rect = CGRect(x: 0, y: 0, width: cellWidth * Float(cols), height: cellHeight * Float(rows))

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = SampleView(frame: rect)
