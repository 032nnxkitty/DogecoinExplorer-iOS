//
//  String+Ext.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 15.04.2023.
//

import UIKit

extension String {
    func shorten(prefix: Int, suffix: Int) -> String {
        return "\(self.prefix(prefix))...\(self.suffix(suffix))"
    }
    
    func formatNumberString() -> String {
        guard let number = Decimal(string: self) else { return self }
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        if let result = formatter.string(for: number) {
            return "\(result) DOGE"
        } else {
            return self
        }
    }
    
    func getRange(of substring: String) -> NSRange {
        return (self as NSString).range(of: substring)
    }
}
