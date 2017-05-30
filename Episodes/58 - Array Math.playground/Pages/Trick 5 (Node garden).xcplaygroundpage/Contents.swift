import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    struct Node {
        let x:Float
        let y:Float
    }
    
    var nodes = [Node]()
    let maxDist:Float = 100
    
    override func setup() {
        for _ in 0 ..< 100 {
            nodes.append(
                Node(
                    x: Float.random() * 600,
                    y: Float.random() * 600
                )
            )
        }
    }
    
    override func update(context: CGContext) {
        for node in nodes {
            context.beginPath()
            context.addArc(
                center: CGPoint(x: node.x, y: node.y),
                radius: 2,
                startAngle: -CGFloat.pi,
                endAngle: CGFloat.pi,
                clockwise: false
            )
            context.fillPath()
        }
        
        var i = 0
        while i < nodes.count - 1 {
            let nodeA = nodes[i]
            var j = i + 1
            while j < nodes.count {
                let nodeB = nodes[j]
                let dx = nodeB.x - nodeA.x
                let dy = nodeB.y - nodeA.y
                let dist = sqrt(dx * dx + dy * dy)
                if dist < maxDist {
                    context.setLineWidth(CGFloat(1 - dist / maxDist))
                    context.beginPath()
                    context.move(to: CGPoint(
                        x: nodeA.x,
                        y: nodeA.y)
                    )
                    context.addLine(to: CGPoint(
                        x: nodeB.x,
                        y: nodeB.y)
                    )
                    context.strokePath()
                }
            
                j += 1
            }
            i += 1
        }
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = SampleView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
