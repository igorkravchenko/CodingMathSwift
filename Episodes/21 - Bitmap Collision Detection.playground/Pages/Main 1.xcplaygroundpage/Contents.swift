import UIKit
import PlaygroundSupport

guard let image = UIImage(named:"milky_way.jpg") else { fatalError() }
let view = SampleView(frame:CGRect(x:0, y:0, width:1024, height:1024))
let imageView = UIImageView(image: image)
imageView.sizeToFit()
imageView.addSubview(view)
imageView.addSubview(view.collisionView)
PlaygroundPage.current.liveView = imageView
PlaygroundPage.current.needsIndefiniteExecution = true
