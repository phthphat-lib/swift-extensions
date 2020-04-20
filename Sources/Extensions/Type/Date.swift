//
//  Date+Extensions.swift
//
//  Created by Edward Nguyen on 6/25/18.
//

import Foundation

public enum AppDateFormat: String {
    
    case ddMMMyyCommahhmma          = "dd MMM yyyy, hh:mm a"
    case ddMMMyyyySpacehhmma        = "dd MMM yyyy hh:mm a"
    case ddMMyyyyhhmmma             = "dd-MM-yyyy hh:mm"
    case ddMMMyyyy                  = "dd MMM yyyy"
    case ddMMyyyy                   = "dd/MM/yyyy"
    case MMyyyy                     = "MM yyyy"
    case MMMMyyyy                   = "MMMM yyyy"
    case hhmma                      =  "hh:mm a"
    case weekdayddMMMyyy            = "EE, dd MMM yyyy"
    //    case dd_MM_YYYY                 = "dd-MM-YYYY"
    case HHmmddMMyyyy               = "HH:mm dd-MM-yyyy"
    //    case dd_MM_yyyyHHmmm            = "dd-MM-yyyy HH:mm"
    case ddMMyyyyHHmmm              = "dd MM yyyy HH:mm"
    case yyyyMMddHHmm               = "yyyy-MM-dd HH:mm"
    case MMMyyyy = "MMM yyyy"
    case ddMMYYYY = "dd/MM/YYYY"
    case yyyyMMdd = "yyyy-MM-dd"
    case HHmm = "HH:mm"
    case ha = "ha"
    
    public var formatString: String {
        return self.rawValue
    }
}


public extension Date {
    var isInThePast: Bool {
        let now = Date()
        return self.compare(now) == ComparisonResult.orderedAscending
    }
        
    /// SwifterSwift: ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSS) from date.
    ///
    ///     Date().iso8601String -> "2017-01-12T14:51:29.574Z"
    ///
    var iso8601String: String {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: self).appending("Z")
    }
    
    /// SwifterSwift: Create date object from ISO8601 string.
    ///
    ///     let date = Date(iso8601String: "2017-01-12T16:48:00.959Z") // "Jan 12, 2017, 7:48 PM"
    ///
    /// - Parameter iso8601String: ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSSZ).
    init?(iso8601String: String) {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: iso8601String) {
            self = date
        } else {
            return nil
        }
    }
    
    init?(gtFormat: String, gfFormat: AppDateFormat) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = gfFormat.formatString
        if let date = dateFormatter.date(from: gtFormat) {
            self = date
        } else {
            return nil
        }
    }
    
    var isToday: Bool {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.isDateInToday(self)
    }
    
    /**
     *  Determine if date is within the day tomorrow
     */
    var isTomorrow: Bool {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.isDateInTomorrow(self)
    }
    
    /**
     *  Determine if date is within yesterday
     */
    var isYesterday: Bool {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.isDateInYesterday(self)
    }
    
    /**
     *  Determine if date is in a weekend
     */
    var isWeekend: Bool { return (weekday == 7 || weekday == 1) }
    
    // MARK: - Components
    
    /**
     *  Convenience getter for the date's `era` component
     */
    var era: Int { return component(.era) }
    
    /**
     *  Convenience getter for the date's `year` component
     */
    var year: Int { return component(.year) }
    
    /**
     *  Convenience getter for the date's `month` component
     */
    var month: Int { return component(.month) }
    
    /**
     *  Convenience getter for the date's `week` component
     */
    var week: Int { return component(.weekday) }
    
    /**
     *  Convenience getter for the date's `day` component
     */
    var day: Int { return component(.day) }
    
    /**
     *  Convenience getter for the date's `hour` component
     */
    var hour: Int { return component(.hour) }
    
    /**
     *  Convenience getter for the date's `minute` component
     */
    var minute: Int { return component(.minute) }
    
    /**
     *  Convenience getter for the date's `second` component
     */
    var second: Int { return component(.second) }
    
    /**
     *  Convenience getter for the date's `weekday` component
     */
    var weekday: Int { return component(.weekday) }
    
    /**
     *  Convenience getter for the date's `weekdayOrdinal` component
     */
    var weekdayOrdinal: Int { return component(.weekdayOrdinal) }
    
    /**
     *  Convenience getter for the date's `quarter` component
     */
    var quarter: Int {
        return component(.quarter)
    }
    
    /**
     *  Convenience getter for the date's `weekOfYear` component
     */
    var weekOfMonth: Int {
        return component(.weekOfMonth)
    }
    
    /**
     *  Convenience getter for the date's `weekOfYear` component
     */
    var weekOfYear: Int {
        return component(.weekOfYear)
    }
    
    /**
     *  Convenience getter for the date's `yearForWeekOfYear` component
     */
    var yearForWeekOfYear: Int {
        return component(.yearForWeekOfYear)
    }
    
    /**
     *  Convenience getter for the date's `daysInMonth` component
     */
    var daysInMonth: Int {
        let calendar = Calendar.autoupdatingCurrent
        let days = calendar.range(of: .day, in: .month, for: self)
        return days!.count
    }
    
    func component(_ component: Calendar.Component) -> Int {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.component(component, from: self)
    }
    
    func toString(formatString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.string(from: self)
    }
}
