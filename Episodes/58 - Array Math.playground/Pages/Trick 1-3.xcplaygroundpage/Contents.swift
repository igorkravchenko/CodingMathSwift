//: **Trick #1: store array length**
do {
    let array = [3, 4, 5, 6, 7, 8, 9, 0]
    let len = array.count
    var i = 0
    while i < len {
        let element = array[i]
        print(element)
        i += 1
    }
}

//: **Trick #2: Reverse looping**
do {
    var array = [3, 4, 5, 5, 6, 7, 8, 9, 0]
    var i = array.count - 1
    while i >= 0 {
        let element = array[i]
        if element == 5 {
            array.remove(at: i)
        }
        i -= 1
    }
}

//: **Trick #3: Make single dimensional array act like two-dimensional array**
do {
    let numCols = 10
    let numRows = 10
    var grid = [String](repeating: "", count: numRows * numCols)
    func get(row:Int, col:Int) -> String {
        return grid[row * numCols + col]
    }
    
    func set(row:Int, col:Int, value:String) {
        grid[row * numCols + col] = value
    }
    
    set(row: 4, col: 5, value: "hello world")
    get(row: 4, col: 5)
}