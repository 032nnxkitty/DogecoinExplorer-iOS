//
//  String+Formatting.swift
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
        return formatter.string(for: number) ?? self
    }
}
