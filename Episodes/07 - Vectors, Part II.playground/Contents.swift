//let v1 = Vector(x:10, y:5)
//print(v1.getX())
//print(v1.getY())
//print(v1.getAngle())
//print(v1.getLength())

//----------------

//let v1 = Vector(x:10, y:5)
//v1.setAngle(Float.pi / 6.0)
//v1.setLength(100)
//print(v1.getX())
//print(v1.getY())

//----------------

//let v1 = Vector(x: 10, y: 5)
//let v2 = Vector(x: 3, y: 4)
//let v3 = v1.add(v2)
//print(v3.getX(), v3.getY())

//----------------

//let v1 = Vector(x: 10, y: 5)
//print(v1.getLength())

//let v2 = v1.multiply(2)
//print(v2.getLength())

//----------------

let v1 = Vector(x: 10, y: 5)
let v2 = Vector(x: 3, y: 4)

v1.addTo(v2)

print(v1.getX(), v1.getY())