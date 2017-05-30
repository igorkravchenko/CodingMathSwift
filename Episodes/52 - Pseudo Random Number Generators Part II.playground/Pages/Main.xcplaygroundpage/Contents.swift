//: Playground - noun: a place where people can play

import GameplayKit

/*
do {
    let random = GKShuffledDistribution(
        randomSource: GKMersenneTwisterRandomSource(seed: 999),
        lowestValue: 0,
        highestValue: 20000
    )
    
    for _ in 0 ..< 10 {
        print(random.nextInt())
    }
}
*/
do {
    srand48(110)

    for _ in 0 ..< 10 {
        print(drand48())
    }
}


let message = "hello world one two three"

func encode(message:String, seed:Int) -> String {
    var result = ""
    let unicodeScalars = message.unicodeScalars
    srand48(seed)
    for i in unicodeScalars {
        let charCode = UInt32(i) + UInt32(drand48() * 1000)
        guard let unicodeScalar = UnicodeScalar(charCode) else {
            continue
        }
        
        result += String(describing:unicodeScalar)
    }
    return result
}

func decode(message:String, seed:Int) -> String {
    var result = ""
    let unicodeScalars = message.unicodeScalars
    srand48(seed)
    for i in unicodeScalars {
        let offset = drand48() * 1000
        let charCode = UInt32(i) - UInt32(offset)
        guard let unicodeScalar = UnicodeScalar(charCode) else {
            continue
        }
        
        result += String(describing:unicodeScalar)
    }
    return result
}

let encoded = encode(message: message, seed: 100)

print("result:", decode(message:encoded, seed:100))
