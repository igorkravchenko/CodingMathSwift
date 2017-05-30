import UIKit
import PlaygroundSupport

let w = 600
let h = 600
let rect = CGRect(x: 0, y: 0, width: w, height: h)

class SampleView : BaseView {
    
    override func update(context: CGContext) {
        let seed = 1000
        
        srand48(seed)
        context.beginPath()
        var x = 0
        while x < 600 {
            let y = Int(100 + drand48() * 50)
            let p = CGPoint(x: x, y: y)
            if x == 0 {
                context.move(to: p)
            }
            else {
                context.addLine(to: p)
            }
            x += 20
        }
        context.strokePath()
        
        srand48(seed)
        context.beginPath()
        x = 0
        while x < 600 {
            let y = Int(300 + drand48() * 50)
            let p = CGPoint(x: x, y: y)
            if x == 0 {
                context.move(to: p)
            }
            else {
                context.addLine(to: p)
            }
            x += 20
        }
        context.strokePath()

        srand48(seed)
        context.beginPath()
        x = 0
        while x < 600 {
            let y = Int(500 + drand48() * 50)
            let p = CGPoint(x: x, y: y)
            if x == 0 {
                context.move(to: p)
            }
            else {
                context.addLine(to: p)
            }
            x += 20
        }
        context.strokePath()
    }
}

let view = SampleView(frame: rect)
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true