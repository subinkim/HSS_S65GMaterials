
import UIKit



protocol Animal {
    var name: String { get }
}

extension Animal {
    var name: String { return "some kind of animal" }
}

struct Cow: Animal {
    var name = "Cow"
}

var cow = Cow()
cow.name
print(cow.name)

struct Dog: Animal {
    
}

var animal: Animal? = nil
animal = Dog()

animal?.name
print (animal?.name ?? "dunno")

animal = Cow()
animal?.name
print (animal?.name ?? "dunno")


protocol ValueWrapper {
    associatedtype Wrapped
    var value: Wrapped { get }
    init(_ value: Wrapped)
}

extension ValueWrapper {
}

struct Value<T>: ValueWrapper {
    typealias Wrapped = T
    
    var value: T
    init(_ value: T) {
        self.value = value
    }
}

let wrappedInt = Value<Int>(12)

let wrappedDouble = Value<Double>(47.0)


let a: [[Int]] = [
    [1,2],
    [3,4],
    [5,6]
]

let maxRows = a.reduce(0) { return $1[0] > $0 ? $1[0] : $0 }
let maxCols = a.reduce(0) { return $1[1] > $0 ? $1[1] : $0 }
(maxRows, maxCols)

typealias Position = (row: Int, col: Int)
a.forEach {
    let pos = Position(row: $0[0], col: $0[1])
}







