//
//  Int+Extension.swift.swift
//  Clock
//
//  Created by 정진균 on 2022/03/05.
//

import Foundation

extension Int {
    /// --
    /// var n: Int = 5
    /// n = n.safeString
    /// print(n) // "05"
    /// --
    
    var safeString: String {
        return self >= 10 ? "\(self)" : "0\(self)"
    }
}
