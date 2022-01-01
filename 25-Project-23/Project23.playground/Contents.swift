import UIKit

//var name = "Taylor"
//
//for letter in name {
//    print("Give me in \(letter)")
//}
//
//
//let letter = name[name.index(name.startIndex, offsetBy: 3)]
//
//
//extension String{
//    subscript(i:Int) -> String{
//        return String(self[index(startIndex, offsetBy: i)])
//    }
//}
//
//let str = name[3]
//
//let password = "123456"
//
//password.hasPrefix("123")
//password.hasSuffix("456")
//
//extension String{
//    func deletionPrefix(_ prefix:String) -> String{
//        guard self.hasPrefix(prefix) else {return self}
//        return String(self.dropFirst(prefix.count))
//    }
//    func deletionSuffix(_ suffix:String) -> String{
//        guard self.hasSuffix(suffix) else {return self}
//        return String(self.dropLast(suffix.count))
//    }
//}
//
//print(password)
//
//let weather = "it's going to rain"
//print(weather.capitalized)
//
//
//extension String{
//    var capitalazedFirst:String{
//        guard let letterFirst = self.first else {return ""}
//        return letterFirst.uppercased() + self.dropFirst()
//    }
//}
//
//
//let language = "Swift hacking"
//language.contains("Swift")
//
//let array = ["Python", "Swift"]
//array.contains("Swift")
//
//extension String{
//    func containsAny(of array:[String])->Bool{
//        for item in array{
//            if self.contains(item){
//                return true
//            }
//        }
//        return false
//    }
//}
//
//language.containsAny(of: array)
//
//array.contains(where: language.contains)


let string = "This is a test string"

//let atributes: [NSAttributedString.Key:Any] = [
//    .foregroundColor:UIColor.white,
//    .backgroundColor: UIColor.red,
//    .font: UIFont.boldSystemFont(ofSize: 36)
//
//]
//
//let atrributedStrong = NSAttributedString(string: string, attributes: atributes)

let atributedString = NSMutableAttributedString(string: string)
atributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
atributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
atributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
atributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
atributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))


//var string2 = "salam"
//
//extension String{
//    func withPrefix(_ prefix:String) -> String{
//        if self.contains(prefix){
//            return self
//        }else{
//            return String(prefix + self)
//        }
//    }
//}
//string2.withPrefix("sal")

//var string3 = "salam"
//
//extension String{
//
//
//    func isNumeric()->Bool{
//        var arrayNumber = [1,2,3,4,5,6,7,8,9,0]
//        for num in arrayNumber{
//            if self.contains(String(num)){
//                return true
//            }
//        }
//        return false
//    }
//}
//string3.isNumeric()

var string3 = "salam/alekum/haha"

extension String{
    var lines:[Substring]{
        return self.split(separator: "/")
    }
}
string3.lines
