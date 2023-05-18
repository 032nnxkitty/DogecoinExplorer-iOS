//
//  Int+UnixTime.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 18.04.2023.
//

import Foundation

extension Int {
    func formatUnixTime() -> String {
        let date = Date(timeIntervalSince1970: Double(self))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "d MMM yyyy"
        return dateFormatter.string(from: date)
    }
}
