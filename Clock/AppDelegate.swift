//
//  AppDelegate.swift
//  Clock
//
//  Created by 정진균 on 2022/03/05.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var timer: Timer? = nil
    
    let text: Array<String> = [
        "👍",
        "🤖",
        "🥰",
        "😶‍🌫️",
        "👽"
    ]

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("앱 실행 완료")
        
        guard let statusButton = statusBarItem.button else { return }

        statusButton.title = Preference.showSeconds ? Date.now.stringTimeWithSeconds : Date.now.stringTime
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateStatusText),
                                     userInfo: nil,
                                     repeats: true
        )
        
        let  statusMenu: NSMenu = NSMenu()
        
        statusMenu.addItem(withTitle: "안녕하세요", action: nil, keyEquivalent: "")
        statusMenu.addSeparator()
        
        let toggleFlashingSeparatorsItem: NSMenuItem = {
            let item = NSMenuItem(title: "Flashing separators",
                                  action: #selector(toggleFlashingSeparators),
                                  keyEquivalent: ""
            )
            item.tag = 1
            item.target = self
            item.state = Preference.useFlashDots.stateValue
            
            return item
        }()
        
        let toggleDockIconItem: NSMenuItem = {
            let item = NSMenuItem(title: "Toggle Dock Icon",
                                  action: #selector(toggleDockIcon),
                                  keyEquivalent: ""
            )
            item.tag = 2
            item.target = self
            item.state = Preference.showDockIcon.stateValue
            
            return item
        }()
        
        let toggleSecondsItem: NSMenuItem = {
            let item = NSMenuItem(title: "Show Seconds",
                                  action: #selector(toggleSeconds),
                                  keyEquivalent: ""
            )
            item.tag = 3
            item.target = self
            item.state = Preference.showSeconds.stateValue
            
            return item
        }()
        
        let quitApplicationItem: NSMenuItem = {
            let item = NSMenuItem(title: "Quit",
                                  action: #selector(terminate),
                                  keyEquivalent: "q"
            )
            item.target = self
            return item
        }()
        
        statusMenu.addItems(
            toggleFlashingSeparatorsItem,
            toggleDockIconItem,
            
                .separator(),
            
            toggleSecondsItem,
            
                .separator(),
            
            quitApplicationItem
        )
        
        statusBarItem.menu = statusMenu
        
        /*
         This will update 'title' of 'statusBarItem' even if is highligheted.
         */
        RunLoop.main.add(timer!, forMode: .common)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

/*
 * -----------------------
 * MARK: - Actions
 * ------------------------
 */
extension AppDelegate {
    @objc
    func updateStatusText(_ sender: Timer) {
        guard let statusButton = statusBarItem.button else { return }
        statusButton.title = Preference.showSeconds ? Date.now.stringTimeWithSeconds : Date.now.stringTime
    }
    
    @objc
    func toggleFlashingSeparators(_ sender: NSMenuItem) {
        Preference.useFlashDots = !Preference.useFlashDots
        
        if let menu = statusBarItem.menu, let item = menu.item(withTag: 1) {
            item.state = Preference.useFlashDots.stateValue
        }
    }
    
    
    @objc
    func toggleDockIcon(_ sender: NSMenuItem) {
        Preference.showDockIcon = !Preference.showDockIcon
        
        if let menu = statusBarItem.menu, let item = menu.item(withTag: 2) {
            item.state = Preference.showDockIcon.stateValue
        }
    }
    
    @objc
    func toggleSeconds(_ sender: NSMenuItem) {
        Preference.showSeconds = !Preference.showSeconds
        
        if let menu = statusBarItem.menu, let item = menu.item(withTag: 3) {
            item.title = "Show seconds"
            item.state = Preference.showSeconds.stateValue
        }
    }
    
    @objc
    func terminate(_ sender: NSMenuItem) {
        NSApp.terminate(sender)
    }
}
