//
//  String+Extension.swift
//
//

import Foundation
import UIKit
import CommonCrypto

postfix operator &
let CCSHA256DIGESTLENGTH   =  32

postfix func & <T>(element: T?) -> String {
    return (element == nil) ? "" : "\(element!)".trim()
}

postfix func & <T>(element: T) -> String {
    return "\(element)".trim()
}


public extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidPhone() -> Bool {
        let phoneRegEx1 = "^[0-9]{6,14}$"
        let phoneTest1 = NSPredicate(format:"SELF MATCHES %@", phoneRegEx1)
        let phoneRegEx2 = "^[+][0-9]{6,14}$"
        let phoneTest2 = NSPredicate(format:"SELF MATCHES %@", phoneRegEx2)
        return phoneTest1.evaluate(with: self) || phoneTest2.evaluate(with: self)
    }
    
    var htmlAttributedString: NSAttributedString? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,
                                          options: [
                                            .documentType: NSAttributedString.DocumentType.html,
                                            .characterEncoding: String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    init?(utf16chars : [UInt16]) {
        var unicodeScalars: [Unicode.Scalar] = []
        var iterator = utf16chars.makeIterator()
        var utf16 = UTF16()
        end: while true {
            switch utf16.decode(&iterator) {
            case .emptyInput:
                break end
            case .scalarValue(let unicodeScalar):
                unicodeScalars.append(unicodeScalar)
            case .error:
                return nil
            }
        }
        self.init(UnicodeScalarView(unicodeScalars))
    }
    
    func convertHexToString() -> String?{
        let text = self.replacingOccurrences(of: "\\u", with: " ").split(separator: " ")
        var utf16array = [UInt16]()
        for item in text {
            if let value = Int(item, radix: 16) {
                utf16array.append(UInt16(value))
            }
        }
        
        if let str = String(utf16chars: utf16array){
            return str
        }
        return nil
    }
    
    func convertStringToHex() -> String {
        var strings = [String]()
        for c in Array(self) {
            strings.append(String(c))
        }
        var hexString = ""
        for s in strings {
            if s.count == s.utf8.count {
                if let data = s.data(using: .utf8, allowLossyConversion: true) {
                    let hex = data.map{ String(format:"\\u%04x", $0 as CVarArg) }.joined()
                    hexString += hex
                }
            } else {
                if let data = s.data(using: .utf16BigEndian, allowLossyConversion: true) {
                    let hex = data.map{ String(format:"%.2x", $0 as CVarArg) }.joined()
                    if hex.count == 3 {
                        hexString += "\\u0" + hex
                    }
                    else if hex.count == 2 {
                        hexString += "\\u00" + hex
                    } else {
                        hexString += "\\u" + hex
                    }
                    
                }
            }
        }
        return hexString
    }
    
    func convertDateToString(fromDate: String = "yyyy-MM-dd HH:mm:ss.S", toDate: String = "dd/MM/yyyy, hh:mm a") -> String? {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = fromDate
        
        if let date = dateFormat.date(from: self) {
            dateFormat.dateFormat = toDate
            return dateFormat.string(from: date)
        }
        return nil
    }
    
    func convertBase64ToImage() -> UIImage? {
        let imgBase64 = self.replacingOccurrences(of: "data:image/jpeg;base64,", with: "").replacingOccurrences(of: "data:image/png;base64,", with: "").replacingOccurrences(of: "\\", with: "")
        if let dataDecoded : Data = Data(base64Encoded: imgBase64, options: .ignoreUnknownCharacters) {
            return UIImage(data: dataDecoded)
        }
        return nil
    }
    
    func sha512Hex() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        if let data = self.data(using: String.Encoding.utf8) {
            let value =  data as NSData
            CC_SHA512(value.bytes, CC_LONG(data.count), &digest)
            
        }
        var digestHex = ""
        for index in 0..<Int(CC_SHA512_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
}

extension StringProtocol where Index == String.Index {
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}




public extension String {
    
    func htmlDecoded() -> String {
        
        guard (self != "") else { return self }
        
        var newStr = self
        // from https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
        let entities = [ //a dictionary of HTM/XML entities.
            "&quot;": "\"",
            "&amp;": "&",
            "&apos;": "'",
            "&lt;": "<",
            "&gt;": ">",
            "&deg;": "º"
        ]
        
        for (name, value) in entities {
            newStr = newStr.replacingOccurrences(of: name, with: value)
        }
        return newStr
    }
    
    func htmlEncoded() -> String {
        
        guard (self != "") else { return self }
        
        var newStr = self
        // from https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
        let entities = [ //a dictionary of HTM/XML entities.
            "&quot;": "\"",
            "&amp;": "&",
            "&apos;": "'",
            "&lt;": "<",
            "&gt;": ">",
            "&deg;": "º"
        ]
        
        for (name, value) in entities {
            newStr = newStr.replacingOccurrences(of: value, with: name)
        }
        return newStr
    }
    
    func isValidEmpty() -> Bool {
        if self.cutWhiteSpace().isEmpty {
            return true
        }
        return (self.cutWhiteSpace().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "")
    }
    
    func cutWhiteSpace() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func toDouble() -> Double {
        let nsString = self as NSString
        return nsString.doubleValue
    }
    
    func imageFromBase64() -> UIImage? {
        guard let data = Data(base64Encoded: self) else { return nil }
        
        return UIImage(data: data)
    }
}

// MARK: validate
public extension String {
    func phoneString() -> String? {
        return self.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    }
    
    func sha256Ma() -> String {
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    private func digest(input: NSData) -> NSData {
        let digestLength = Int(CCSHA256DIGESTLENGTH)
        let hash = [UInt8](repeating: 0, count: digestLength)
        //        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format: "%02x", UInt8(byte))
        }
        
        return hexString
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isEmptyIgnoreNewLine() -> Bool {
        return self.trim().isEmpty
    }
    
//    func isValidEmail() -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
//        return emailTest.evaluate(with: self)
//    }
//
    func hasVNChar() -> Bool {
        let listVietNamese = "ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ"
        return self.reduce(false) { $0 || listVietNamese.contains($1) }
    }
    
    func hasSpecialCharacters() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9 _ .].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: self.count)) {
                return true
            }
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
        return false
    }
    
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    func attributedString(fontSize: Float) -> NSAttributedString? {
        if(self == "") {
            return nil
        }
        let oldString = String(format: "<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(fontSize)\">%@</span>", self)
        
        guard let data = oldString.data(using: String.Encoding.utf8,
                                        allowLossyConversion: false) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue,
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html
            
        ]
        let htmlString = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
        
        // Removing this line makes the bug reappear
        htmlString?.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear, range: NSRange(location: 0, length: 1))
        
        return htmlString
    }
    
    func attributedString() -> NSAttributedString? {
        if(self == "") {
            return nil
        }
        guard let data = self.data(using: String.Encoding.utf8,
                                   allowLossyConversion: false) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue,
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html
        ]
        let htmlString = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
        
        // Removing this line makes the bug reappear
        htmlString?.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear, range: NSRange(location: 0, length: 1))
        
        return htmlString
    }
}

public extension String {
    func capitalizedFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizedFirstLetter()
    }
}

public extension String {
    func toAttributedString(color: UIColor, font: UIFont? = nil, isUnderLine: Bool = false) -> NSAttributedString {
        if let font = font {
            if isUnderLine {
                return NSAttributedString(string: self, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.underlineColor: color, NSAttributedString.Key.underlineStyle: 1])
            }
            return NSAttributedString(string: self, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
        } else {
            return NSAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor: color])
        }
        
    }
    
    
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    subscript (bounds: Int) -> String {
        let start = index(startIndex, offsetBy: bounds)
        return String(self[start])
    }
}

public extension String {
    func toDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        return nil
    }
}

public extension String {
    func rePlaceBr() -> String {
        return self.replacingOccurrences(of: "</br>", with: "\n")
    }
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    func removeTextInBase64() -> String {
        var str = self
        str = str.replacingOccurrences(of: "data:image/jpeg;base64,", with: "")
        str = str.replacingOccurrences(of: "data:image/png;base64,", with: "")
        str = str.replacingOccurrences(of: "data:image/jpg;base64,", with: "")
        
        return str
    }
    
    func toUIImage() -> UIImage? {
        let dataString = Data(base64Encoded: self, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        guard let data = dataString else { return nil }
        return UIImage(data: data)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func formatNumber(type: String) -> String {
        if self.count < 4 {
            return self
        }
        let firstValue = self.count - Int(self.count / 3) * 3
        var tempValue = ""
        var index = 0
        self.forEach({ (character) in
            if (index - firstValue) % 3 == 0 && index != 0 {
                tempValue += "\(type)\(character)"
            } else {
                tempValue += "\(character)"
            }
            index += 1
        })
        return tempValue
    }
    
    func getNumberListFromString() -> [Int] {
        var numList = [Int]()
        let stringArray = self.components(separatedBy: CharacterSet.decimalDigits.inverted)
        for item in stringArray {
            if let number = Int(item) {
                numList.append(number)
            }
        }
        return numList
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func HTMLImageCorrector() -> String {
        let htmlString: String =  "<html><meta name='viewport' content='width=device-width, initial-scale=1'><head><link href='https://fonts.googleapis.com/css?family=Sofia' rel='stylesheet'><style>body { background: white; font-family: 'Open Sans' !important; font-size: 15px; } </style> </head> <body> <img align=\"middle\">" + self + "</body></html>"
        return htmlString
    }
}

public extension String {
    func convertDate(fromDateFormat: String = AppDateFormat.yyyyMMddHHmm.formatString, toDateFormat: String = AppDateFormat.HHmmddMMyyyy.formatString) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromDateFormat
        
        if let date = dateFormatter.date(from: self) {
            return date.toString(formatString: toDateFormat)
        } else {
            return nil
        }
    }
    
}

public extension StringProtocol {
    var firstCapitalized: String {
        guard let first = first else { return "" }
        return String(first).capitalized + dropFirst()
    }
}

public extension String {
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary
        let version = dictionary?["CFBundleShortVersionString"] as? String
        let build = dictionary?["CFBundleVersion"] as? String
        return "*******************************************\nKhind: version \(version ?? "") build \(build ?? "")\n*******************************************"
    }
}

