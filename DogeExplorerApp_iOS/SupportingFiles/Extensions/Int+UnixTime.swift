//
//  Int+UnixTime.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 18.04.2023.
//

import Foundation

enum TimeStyle {
    case full
    case short
}

extension Int {
    func formatUnixTime(style: TimeStyle) -> String {
        let date = Date(timeIntervalSince1970: Double(self))
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        switch style {
        case .full:
            dateFormatter.dateFormat = "E, d MMM yyyy, HH:mm:ss"
        case .short:
            dateFormatter.dateFormat = "d MMM yyyy"
        }
        return dateFormatter.string(from: date)
    }
}
