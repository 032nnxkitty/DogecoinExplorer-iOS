//
//  Int+UnixTime.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 18.04.2023.
//

import Foundation

extension Int {
    enum TimeStyle {
        case shorten
        case detailed
    }
    
    func formatUnixTime(style: TimeStyle) -> String {
        let date = Date(timeIntervalSince1970: Double(self))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        switch style {
        case .shorten:
            dateFormatter.dateFormat = "d MMM yyyy"
        case .detailed:
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        }
        return dateFormatter.string(from: date)
    }
}
