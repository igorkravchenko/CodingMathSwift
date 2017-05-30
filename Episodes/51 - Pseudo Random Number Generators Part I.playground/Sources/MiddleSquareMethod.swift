import UIKit


public class MiddleSquareMethod {
    let digits:Int
    var seed:Int
    let floatDevisor:Double
    
    public init(digits:Int, seed:Int) {
        self.digits = digits
        self.seed = seed
        let step = "9"
        var stringDevisor = ""
        
        for _ in 0 ..< digits {
            stringDevisor += step
        }
        print(stringDevisor)
        floatDevisor = Double(stringDevisor) ?? 1
    }

    func nextRand() -> Int {
        var n = "\(seed * seed)"
        //print(n)
        while n.characters.count < digits * 2 {
            n = ("0" + String(n))
        }
        let start = Int( digits / 2 )
        let end = digits//start + digits
        let startIndex = n.index(n.startIndex, offsetBy: start)
        let endIndex = n.index(startIndex, offsetBy: end)
        let range = Range(uncheckedBounds: (lower: startIndex, upper: endIndex))
        seed = Int(n[range]) ?? 0
        return seed
    }
    
    func nextRandFloat() -> Double {
        return Double(nextRand()) / floatDevisor
    }
    
    func checkResults() {
        var results = Set<Int>()
        var  j = 0
        for i in 0 ..< 100 {
            j = i
            let rand = nextRand()
            if results.contains(rand) {
                break
            }
            results.insert(rand)
        }
        
        print(j)
    }
    
    let pixelStorage = PixelStorage(image: UIImage.image(color: .white, size: CGSize(width: 600, height: 600)))
    public var image:UIImage? {
        return pixelStorage.image
    }
    
    public var step:() -> () = {}
    var y:Int = 0
    public func draw() {
        for x in 0 ..< 600 {
            let black = nextRandFloat() < 0.5
            if  black {
                pixelStorage.setPixel(x: x, y: y, black: true)
            }
        }
        y += 1
        if (y < 600) {
           render()
           step()
        }
    }
    
    public func render() {
        pixelStorage.render()
    }
}
