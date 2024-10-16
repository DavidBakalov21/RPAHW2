
import Foundation

//!!!!!!!!! TASK1 !!!!!!!!!


//!!! PART1 !!!
/*
class Apartment {
    let number: Int
    weak var tenant: Person? //Adding weak solves retain cycle. The point of that is because apartment can be even without a person
    
    init(number: Int) {
        self.number = number
    }
    
    func getInfo() {
        print("Apartment \(number) hosting \(tenant?.name.description ?? "empty")")
    }
    
    deinit {
        print("Apartment deinitialized")
    }
}

class Person {
    let name: String
    var apartment: Apartment?
    
    init(name: String) {
        self.name = name
    }
    
    func setupApartment(_ apartment: Apartment) {
        self.apartment = apartment
    }
    
    func getInfo() {
        print("Person \(name) is in Apartment \(apartment?.number.description ?? "empty")")
    }
    
    deinit {
        print("Person deinitialized")
    }
}

var person: Person? = Person(name: "Fresh meat")

person?.setupApartment(Apartment(number: 42))

person?.apartment?.tenant = person
person?.getInfo()
person?.apartment?.getInfo()


person = nil
*/


// !!! PART 2 !!!

class Apartment {
    let number: Int
    weak var tenant: Person?
    
    init(number: Int) {
        self.number = number
    }
    
    func getInfo() {
        print("Apartment \(number) hosting \(tenant?.name.description ?? "empty")")
    }
    
    deinit {
        print("Apartment deinitialized")
    }
}

class Person {
    let name: String
    weak var apartment: Apartment?
    
    init(name: String) {
        self.name = name
    }
    
    func setupApartment(_ apartment: Apartment) {
        self.apartment = apartment
    }
    
    func getInfo() {
        print("Person \(name) is in Apartment \(apartment?.number.description ?? "empty")")
    }
    
    deinit {
        print("Person deinitialized")
    }
}

var person: Person? = Person(name: "Fresh meat")
print(1)
var apartment: Apartment?=Apartment(number: 42)
person?.setupApartment(apartment!)  //COMMENT if we will add apartment this way apartment won't be deinitialized instantly
//person?.setupApartment(Apartment(number: 42))


print(2)
person?.apartment?.tenant = person
print(3)
person?.getInfo()
person?.apartment?.getInfo()
print("all objects weren't deinitialized for now")
//apartment=nil//Marked code
//person?.apartment//Marked code
apartment = nil
person = nil
 

//We can use unowned insetead of weak in both cases and break the retain cycle, However in case of marked code if we use unowoend with apartment then we'll get a runtime error. So it is better to use weak if we are not sure about the variable's "path" in program

//So We need to use weak since the apartment and tenant are optionals,so it means that they can potentionaly become nil

//Interesting observation. When we only add weak to the var tenant: Person? in Appartment all works as intended. However, when we add weak to the var apartment: Apartment? in Person, then Appartment deinitializes at this step person?.setupApartment(Apartment(number: 42)). It happens because when we create an instance of the Apartmen class inside person weak reference doesn't increse the apartment's reference count and so ARC kills it.

//If both var apartment: Apartment? and var tenant: Person? are weak nothing interesting happened (just the break of retain cycle)

//!!!!!!!!! TASK2 !!!!!!!!!
print("*****************************")
print("*****************************")
class WeakNeighbor{
    weak var node: Node?
    init(node: Node?) {
        self.node = node
    }
    deinit{
        guard let value=node?.value else{
            print("Unknown value was deinitialized")
            return
        }
        print("Node with value \(value)")
    }
}
class Node{
    var children: [Node]
    var value: Int
    var neighbors: [WeakNeighbor]?
    
    func addNode(child: Node){
        children.append(child)
    }
    func addNeighbor(_ node: Node?) {
        neighbors?.append(WeakNeighbor(node: node))
    }
    init(value: Int) {
        self.children = []
        self.neighbors = []
        self.value = value
    }
}

var node1: Node? = Node(value: 1) // values is just an example to show that nodes are different
var node2: Node? = Node(value: 2)
var node3: Node? = Node(value: 3)
node1?.addNeighbor(node2)
node3?.addNeighbor(node1)
node1?.addNeighbor(node3)



node3 = nil
node1 = nil
//Lil description of the results and why they happened. As you can see we have a weak keyword  near node property in WeakNeighbor class (not "unowned" because it is possible and it actuly happened that node becomes nill ). In this example we see that node1 and node3 are referencing to one another. without weak keyword it would create a retain cylce and won't call deinit of WeakNeighbor when node1=nil and node3=nil, yet still with weak strong reference wasn't formed and ARC allows them to deinit.
    //    When we set node3 to nil we also deallocate its weak neighbors (weak node created from node1). When node1=nil we also deallocate its weak neighbors (weak nodes created from node3 and node2), but since node 3 was already deallocate it will print "Unknown value was deinitialized"

print("*****************************")
print("*****************************")
print("Task 3")
print("*****************************")
print("*****************************")
//https://medium.com/@alexslkmain/copy-on-write-cow-in-swift-144d99c56c8b
class DataClass{
    var array: [Int]
    init(array: [Int]) {
        self.array = array
    }
   
}

class MyData{
    var data:DataClass
    init(array: [Int]) {
        self.data = DataClass(array: array)
    }
    func getArray() -> [Int] {
           return data.array
       }
    func change(array:[Int]){
        if isKnownUniquelyReferenced(&data) {
            data.array=array
            print("1")
           
        }else{
            print(2)
            data=DataClass(array: data.array)
        }
    }
}

var data:MyData=MyData(array: [0,5,6,7])
var dataClone=MyData(array: data.getArray())
func printAddress(address add: UnsafeRawPointer ) {
    print(String(format: "%p", Int(bitPattern: add)))
}

print(data.getArray())
print(dataClone.getArray())

printAddress(address: data.getArray())
printAddress(address: dataClone.getArray())

print("after change")

dataClone.change(array: [0,5,6,7,0])
print(data.getArray())
print(dataClone.getArray())
printAddress(address: data.getArray())
printAddress(address: dataClone.getArray())

print("*****************************")
print("*****************************")
print("Task 4")
print("*****************************")
print("*****************************")
