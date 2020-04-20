//
//  UIDevice.swift
//
//  Created by Kent on 7/22/19.
//

import SystemConfiguration
import UIKit

extension UIDevice {
    
    public enum DeviceName: String {
        case iphone4 = "iPhone 4", iPhone4s
        case iphone5 = "iPhone 5"
        case iphone5C = "iPhone 5c"
        case iphone5S = "iPhone 5s"
        case iphone6 = "iPhone 6"
        case iphone6S = "iPhone 6s"
        case iphone7 = "iPhone 7"
        case iphone8 = "iPhone 8"
        case iphone6P = "iPhone 6 Plus"
        case iphone6SP = "iPhone 6s Plus"
        case iphone7P = "iPhone 7 Plus"
        case iphone8P = "iPhone 8 Plus"
        case iphoneX = "iPhone X"
        case iphoneSE = "iPhone SE"
        case iPhoneXS = "iPhone XS"
        case iPhoneXSM = "iPhone XS Max"
        case iPhoneXR = "iPhone XR"
        
        case iPodTouch5, iPodTouch6
        
        case iPad2, iPad3, iPad4, iPadAir, iPadAir2, iPad5, iPadMini, iPadMini2, iPadMini3, iPadMini4,
        iPadPro9_7, iPadPro12_9, iPadPro12_9Gen2, iPadPro10_5
        
        case unknown
    }
    
    enum UIUserInterfaceIdiom : Int {
        case unspecified
        
        case phone  // iPhone and iPod touch style UI
        case pad    // iPad style UI
    }
    
    /// pares the deveice name as the standard name
    public var name: DeviceName {
        // UIDevice.current.name
        #if targetEnvironment(simulator)
        let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        #endif
        
        switch identifier {
        case "iPod5,1":                                 return .iPodTouch5
        case "iPod7,1":                                 return .iPodTouch6
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return .iphone4
        case "iPhone4,1":                               return .iPhone4s
        case "iPhone5,1", "iPhone5,2":                  return .iphone5
        case "iPhone5,3", "iPhone5,4":                  return .iphone5C
        case "iPhone6,1", "iPhone6,2":                  return .iphone5S
        case "iPhone7,2":                               return .iphone6
        case "iPhone7,1":                               return .iphone6P
        case "iPhone8,1":                               return .iphone6S
        case "iPhone8,2":                               return .iphone6SP
        case "iPhone9,1", "iPhone9,3":                  return .iphone7
        case "iPhone9,2", "iPhone9,4":                  return .iphone7P
        case "iPhone8,4":                               return .iphoneSE
        case "iPhone10,1", "iPhone10,4":                return .iphone8
        case "iPhone10,2", "iPhone10,5":                return .iphone8P
        case "iPhone10,3", "iPhone10,6":                return .iphoneX
        case "iPhone11,2":                              return .iPhoneXS
        case "iPhone11,4", "iPhone11,6":                return .iPhoneXSM
        case "iPhone11,8":                              return .iPhoneXR
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return .iPad2
        case "iPad3,1", "iPad3,2", "iPad3,3":           return .iPad3
        case "iPad3,4", "iPad3,5", "iPad3,6":           return .iPad4
        case "iPad4,1", "iPad4,2", "iPad4,3":           return .iPadAir
        case "iPad5,3", "iPad5,4":                      return .iPadAir2
        case "iPad6,11", "iPad6,12":                    return .iPad5
        case "iPad2,5", "iPad2,6", "iPad2,7":           return .iPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6":           return .iPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9":           return .iPadMini3
        case "iPad5,1", "iPad5,2":                      return .iPadMini4
        case "iPad6,3", "iPad6,4":                      return .iPadPro9_7//"iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return .iPadPro12_9//"iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return .iPadPro12_9Gen2//"iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return .iPadPro10_5//"iPad Pro 10.5 Inch"
        default:                                        return .unknown
        }
    }
    
    public func isIphone4Inch() -> Bool {
        return (name == DeviceName.iphone5) ||
            (name == DeviceName.iphone5C) ||
            (name == DeviceName.iphone5S) ||
            (name == DeviceName.iphoneSE)
    }
    
    func isIphone4_7Inch() -> Bool {
        return (name == DeviceName.iphone6) ||
            (name == DeviceName.iphone6S) ||
            (name == DeviceName.iphone7) ||
            (name == DeviceName.iphone8)
    }
    
    func isIphone5_5Inch() -> Bool {
        return (name == DeviceName.iphone6P) ||
            (name == DeviceName.iphone6SP) ||
            (name == DeviceName.iphone7P) ||
            (name == DeviceName.iphone8P)
    }
    
    func isIphone5_8Inch() -> Bool {
        return (name == DeviceName.iphoneX)
        
    }
    
    func isIphoneXOrLater() -> Bool {
        return !(isIphone4_7Inch() || isIphone4Inch() || isIphone5_5Inch() || UIDevice.current.userInterfaceIdiom == .pad)
    }
    
    func isIpad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
