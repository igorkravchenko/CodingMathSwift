import UIKit

public class SampleView : BaseView {
    
    var typedPointer:UnsafePointer<UInt8>?
    let imageWidth = 200
    let imageHeight = 200
    public override func setup() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: imageWidth, height: imageHeight))
        let image = renderer.image {
            rendererContext in
            let context = rendererContext.cgContext
            var i = 0
            while i < imageWidth {
                var j = 0
                while j < imageHeight {
                    context.setFillColor(UIColor(
                        red: CGFloat(Float.random()),
                        green: CGFloat(Float.random()),
                        blue: CGFloat(Float.random()),
                        alpha: 1).cgColor)
                    context.fill(CGRect(x: i, y: j, width: 20, height: 20))
                    j += 20
                }
                i += 20
            }
        }
        
        let imageView = UIImageView(image: image)
        imageView.sizeToFit()
        addSubview(imageView)
        print(image.size)
        guard let cfData = image.cgImage?.dataProvider?.data else { fatalError() }
        typedPointer = CFDataGetBytePtr(cfData)
    }
    
    public override func handleTouchUp(touchX: Float, touchY: Float) {
        guard let typedPointer = self.typedPointer else { return }
        let x = min(Int(touchX), imageWidth)
        let y = min(Int(touchY), imageHeight)
        let width = imageWidth
        let offset = 4 * (width * y + x)
        let b = typedPointer.advanced(by: offset).pointee
        let g = typedPointer.advanced(by: offset + 1).pointee
        let r = typedPointer.advanced(by: offset + 2).pointee
        let a = typedPointer.advanced(by: offset + 3).pointee
        let color = UIColor(red: CGFloat(r) / 0xFF, green: CGFloat(g) / 0xFF, blue: CGFloat(b) / 0xFF, alpha: CGFloat(a) / 0xFF)
        self.backgroundColor = color
    }
}
