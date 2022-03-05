//
//  NSMenu+Extension.swift
//  Clock
//
//  Created by 정진균 on 2022/03/05.
//

import Foundation
import AppKit

extension NSMenu {
    func addSeparator() -> Void {
        addItem(.separator())
    }
    
    func addItems(_ items: NSMenuItem...) {
        for item in items {
            addItem(item)
        }
    }
}
