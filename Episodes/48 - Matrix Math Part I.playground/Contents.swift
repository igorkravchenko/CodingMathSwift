
import UIKit

// One of the matrix purposes: 2D Transformations
// - Rotation
// - Translation
// - Scaling

// Matrix is simply a table of values (analogy in programming - array)
// Sometimes matrix is defined as array of values
// When we talk about a size of the matrix we usually say number of rows by the number of columns

// Examples:
let matrix_1x6 = [7, 3, 4, 5, 2, 1] // 1x6
let matrix_4x1 = [
    4,
    3,
    2,
    1
] // 4x1
let matrix2x3 = [
    2, 7, 12,
    3, 8, 18
] // 2x3

// Matrices are used for all sorts of mathematical purposes
// But in general in everyday computing they are used for 2D and 3D transformations
// Transformations are applied to 2D and 3D points

// Matrices can be added together  (or subtracted). This is actually a translation
let x0 = 4
let y0 = 5
let matrix0 = [
    x0,
    y0
]
let x1 = 2
let y1 = 3
let matrix1 = [
    x1,
    y1
]
let matrix3 = [
    matrix0[0] + matrix1[0],
    matrix0[1] + matrix1[1]
]

matrix3[0] == x0 + x1 && matrix3[1] == y0 + y1 && matrix3 == [6, 8]

// Multiplication gets a lot more complex
// The are two types of matrix multiplication
// First: matrix can be multiplied by single value (this value is known as scalar)
let matrix4 = [
    3,
    4
]

let scalar = 2

let matrix5 = [
    matrix4[0] * scalar,
    matrix4[1] * scalar
]

// Second: matrix and multiplied by another matrix using rule: number of columns in the first matrix must be equal to the number or rows in the second matrix

let matrixA = [
    1, 2, 3,
    4, 5, 6
] // 3 columns

let matrixB = [
    2, 4,
    3, 5,
    4, 6
] // 3 rows

let matrixC = [
    1 * 2 + 2 * 3 + 3 * 4,  1 * 4 + 2 * 5 + 3 * 6,
    4 * 2 + 5 * 3 + 6 * 4,  4 * 4 + 5 * 5 + 6 * 6
]

// Scaling matrix
let sx = 2
let sy = 3
let scaledMatrix = [
    sx, 0,
    0 , sy
]

let scaleMatrix = [
    4,
    5
]

let scaleResultMatrix = [
    sx * 4 + 0 * 5, 0 * 4 + sy * 5
]

// Rotation matrix
// NOTE: -sinA is specific to canvas (TL as 0 for x and y)
// [                                        [                               [
//      cosA,    sinA            x               x,              =               cosA * x + sinA * y,
//     -sinA,    cosA                            y                              -sinA * x + cosA * y
// ]                                        ]                               ]

// Scale + Translate                        [x,                     [sx * x + 0 * y + tx * 1,                   [sx * x + tx,
// [sx, 0,  tx,                              y,         =            0 * x + sy * y + ty * 1]           =        sy * y + ty]
// [0,  sy, ty]                 x            1]

// Rotation + Translation
// [
//      cosA,   sinA,   tx,                     [   x,                          [cosA * x + sinA * y + tx * 1,
//     -sinA,   cosA,   ty      x                   y,              =           -sinA * x + cosA * y + ty * 1]
// ]                                                1   ]
