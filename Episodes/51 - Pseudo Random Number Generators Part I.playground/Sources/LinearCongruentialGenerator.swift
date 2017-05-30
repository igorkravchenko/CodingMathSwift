import Foundation

public class LinearCongruentialGenerator {
    let a:Int
    let c:Int
    let m:Int
    var seed:Int
    public init(a:Int, c:Int, m:Int, seed:Int) {
        self.a = a
        self.c = c
        self.m = m
        self.seed = seed
    }
    
    public func nextRand() -> Int {
        seed = (a * seed + c) % m
        return seed
    }
    
    public func nextRandFloat() -> Double {
        return Double(nextRand()) / Double(m)
    }
}

import UIKit

public class LinearCongruentialGeneratorExample {
    let pixelStorage:PixelStorage
    let width:Int
    let height:Int
    let generator:LinearCongruentialGenerator
    
    public var image:UIImage? {
        return pixelStorage.image
    }
    
    public var step:() -> () = {}
    
    public init(image:UIImage, a:Int, c:Int, m:Int, seed:Int) {
        pixelStorage = PixelStorage(image: image)
        guard let cgImage = image.cgImage else {
            fatalError()
        }
        width = cgImage.width
        height = cgImage.height
        generator = LinearCongruentialGenerator(a: a, c: c, m: m, seed: seed)
    }
    
    var y = 0
    public func draw() {
        for x in 0 ..< width {
            let black = generator.nextRandFloat() < 0.5
            if black {
                pixelStorage.setPixel(x: x, y: y, black: true)
            }
        }
        y += 1
        if (y < height) {
            pixelStorage.render()
            step()
        }

    }
    
    
}
