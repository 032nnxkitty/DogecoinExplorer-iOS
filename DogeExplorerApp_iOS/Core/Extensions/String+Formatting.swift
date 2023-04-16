//
//  String+Formatting.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 15.04.2023.
//

import UIKit

extension String {
    func shortenAddress() -> String {
        return "\(prefix(8))...\(suffix(5))"
    }
    
    func formatNumberString() -> String {
        guard let number = Decimal(string: self) else { return self }
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.numberStyle = .decimal
        return formatter.string(for: number) ?? self
    }
}
