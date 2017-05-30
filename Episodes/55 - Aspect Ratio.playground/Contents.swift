
import UIKit
import PlaygroundSupport

class SampleView : BaseView {
    
    enum ScaleMode {
        case fill, showAll
    }
    
    let scaleMode:ScaleMode = .showAll
    
    override func setup() {
        backgroundColor = .black
        guard let image = UIImage(named: "raccoons.jpg") else { fatalError() }
        let imageView = UIImageView(image: image)
        imageView.sizeToFit()
        addSubview(imageView)
        
        func getWidthFirst(scaleMode:ScaleMode, imageAspectRatio:Float, containerAspectRatio:Float) -> Bool {
            if scaleMode == .showAll {
                return imageAspectRatio > containerAspectRatio
            }
            else {
                return imageAspectRatio < containerAspectRatio
            }
        }
        
        let imageWidth:Float
        let imageHeight:Float
       
        let imageAspectRatio = Float(image.size.width / image.size.height)
        let containerAspectRatio = width / height
        
        let widthFirst:Bool = getWidthFirst(scaleMode:scaleMode, imageAspectRatio: imageAspectRatio, containerAspectRatio: containerAspectRatio)
        
        if widthFirst {
            imageWidth = width
            imageHeight = imageWidth / imageAspectRatio
        }
        else {
            imageHeight = height
            imageWidth = imageHeight * imageAspectRatio
        }
    
        let rect = CGRect(x: (width / imageWidth) / 2, y: (height - imageHeight) / 2, width: imageWidth, height: imageHeight)
        imageView.frame = rect
        
        
    }
}

let rect = CGRect(x: 0, y: 0, width: 640, height: 640)
let view = SampleView(frame: rect)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = view
