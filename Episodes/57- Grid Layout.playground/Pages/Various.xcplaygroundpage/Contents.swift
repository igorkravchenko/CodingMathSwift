
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
        
        let rows = 50
        let cols = 50
        let cellWidth:Float = width / Float(cols)
        let cellHeight:Float = height / Float(rows)
        let radius = min(cellWidth, cellHeight) / 2
        for i in 0 ..< rows {
            for j in 0 ..< cols {
                context.saveGState()
                context.translateBy(x: CGFloat(Float(j) * cellWidth), y: CGFloat(Float(i) * cellHeight))
                let s = sin(Float(j * i) * 0.25) * 0.25 + 0.75
                context.beginPath()
                let p = CGPoint(x: cellWidth / 2, y: cellHeight / 2 )
                context.addArc(
                    center: p,
                    radius: CGFloat(radius * s),
                    startAngle: -CGFloat.pi,
                    endAngle: CGFloat.pi,
                    clockwise: false
                )
                context.fillPath()
                context.restoreGState()
            }
        }
    }
}

let rect = CGRect(x: 0, y: 0, width: 600, height: 600)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = SampleView(frame: rect)
