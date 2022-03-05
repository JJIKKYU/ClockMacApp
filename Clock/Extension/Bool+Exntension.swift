//
//  Bool+Exntension.swift
//  Clock
//
//  Created by 정진균 on 2022/03/05.
//

import Foundation
import AppKit

extension Bool {
    var stateValue: NSControl.StateValue {
        return self.toStateValue()
    }
    
    private func toStateValue() -> NSControl.StateValue {
        return self ? .on : .off
    }
}
