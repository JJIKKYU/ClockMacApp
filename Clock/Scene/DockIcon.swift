//
//  DockIcon.swift
//  Clock
//
//  Created by 정진균 on 2022/03/05.
//

import Foundation
import AppKit

struct DockIcon {
    static var standard = DockIcon()
    
    var isVisible: Bool {
        get {
            return NSApp.activationPolicy() == .regular
        }
        set {
            setVisibility(newValue)
        }
    }
    
    @discardableResult
    func setVisibility(_ state: Bool) -> Bool {
        if state {
            NSApp.setActivationPolicy(.regular)
        } else {
            NSApp.setActivationPolicy(.accessory)
        }
        
        return isVisible
    }
}
