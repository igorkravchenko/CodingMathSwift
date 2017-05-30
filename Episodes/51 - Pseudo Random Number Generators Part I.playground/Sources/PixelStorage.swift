import UIKit

public class PixelStorage {
    var pixels = Set<Pixel>()
    var image:UIImage?
    
    public init(image:UIImage) {
        self.image = image
    }
    
    @inline (__always) func setPixel(x:Int, y:Int, black:Bool) {
        pixels.insert( black ? Pixel(x: x, y: y, a: 0xFF, r: 0, g: 0, b: 0) : Pixel(x: x, y: y, a: 0xFF, r: 0xFF, g: 0xFF, b: 0xFF) )
    }
    
    public func render() {
        image = image?.setPixels(pixels)
        pixels.removeAll()
    }
    
}
