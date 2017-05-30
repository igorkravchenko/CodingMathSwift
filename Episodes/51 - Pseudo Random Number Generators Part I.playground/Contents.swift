//: Playground - noun: a place where people can play
import UIKit
import PlaygroundSupport

// PRNG

// Middle Square Method

var seed = Int(sqrt(Double( (Int.max - 1234545454) / 10)))
let digits = "\(seed)".characters.count

let middleSquare = MiddleSquareMethod(digits: digits, seed: seed)


let w = 600
let h = 600
let rect = CGRect(x: 0, y: 0, width: w, height: h)
let view = UIImageView(frame:rect)
let image = UIImage.image(color: UIColor.white, size: rect.size)


func tryMiddleSquare() {
    middleSquare.step = {
        if let image = middleSquare.image {
            view.image = image
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            
            middleSquare.draw()
        }
        
    }
    
    middleSquare.draw()
}

func tryLinearCongruentialGenerator() {
    let sample = LinearCongruentialGeneratorExample(image: image, a: 1103515245, c: 12345, m: Int(pow(2 as Double, 31)), seed: 1)
    sample.step = {
        
        let image = sample.image
        view.image = image
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            sample.draw()
        }
    }
    sample.draw()
}

view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
//tryLinearCongruentialGenerator()
tryMiddleSquare()