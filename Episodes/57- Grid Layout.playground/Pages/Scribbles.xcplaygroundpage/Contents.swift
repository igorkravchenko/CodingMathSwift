
import UIKit
import PlaygroundSupport

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
        
        let rows = 10
        let cols = 10
        let cellWidth:Float = width / Float(cols)
        let cellHeight:Float = height / Float(rows)
        
        for i in 0 ..< rows {
            for j in 0 ..< cols {
                context.saveGState()
                context.translateBy(x: CGFloat(Float(j) * cellWidth), y: CGFloat(Float(i) * cellHeight))
                
                context.beginPath()
                context.move(to: CGPoint.zero)
                for _ in 0 ..< 50 {
                    let p = CGPoint(x: Float.random() * cellWidth, y: Float.random() * cellHeight)
                    context.addLine(to: p)
                }
                context.strokePath()
                context.restoreGState()
            }
        }
        
    }
}


let rect = CGRect(x: 0, y: 0, width: 600, height: 600)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = SampleView(frame: rect)
