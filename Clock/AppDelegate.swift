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
        "🍺 마시고싶다마시고싶다마시고싶다",
        "🍔 먹고싶다마시고싶다",
        "🎬 보고싶다마시고싶다마시고싶다마시고싶다마시고싶다",
        "🎤 부르고싶다",
        "🎮 하고싶다"
    ]
    
    var separatorStatus: NSControl.StateValue = .on
    
    var reminders: [Reminder] = [] {
        didSet {
            if let menu = statusBarItem.menu, let item = menu.item(withTag: 5) {
                item.submenu = self.getRemindersMenu()
                item.isEnabled = reminders.count > 0
            }
        }
    }


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("앱 실행 완료")
        
        guard let statusButton = statusBarItem.button else { return }
        
        let randNum = Int.random(in: 0...4)
        statusButton.title = text[randNum]
//        statusButton.imageScaling = .scaleAxesIndependently
        
//        statusButton.title = Preference.showSeconds ? Date.now.stringTimeWithSeconds : Date.now.stringTime
        
        
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
        
        let reminderItem: NSMenuItem = {
            let item = NSMenuItem(title: "Reminders",
                                  action: nil,
                                  keyEquivalent: ""
            )
            item.tag = 5
            
            let menu = NSMenu()
            
            for reminder in self.reminders {
                menu.addItems(.init(title: reminder.title, action: nil, keyEquivalent: ""))
            }
            
            item.isEnabled = reminders.count > 0
            
            return item
        }()
        
        let addReminderItem: NSMenuItem = {
            let item = NSMenuItem(title: "New Reminder", action: #selector(addReminder), keyEquivalent: "")
            item.tag = 6
            item.target = self
            return item
        }()
        
        statusMenu.addItems(
            toggleFlashingSeparatorsItem,
            toggleDockIconItem,
            
                .separator(),
            
            toggleSecondsItem,
            
                .separator(),
            
            reminderItem,
            addReminderItem,
            
            quitApplicationItem
        )
        
        statusBarItem.menu = statusMenu
        
        /*
         This will update 'title' of 'statusBarItem' even if is highligheted.
         */
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        if Preference.firstRunGone == false {
            Preference.firstRunGone = true
            Preference.restore()
        }
        
        DockIcon.standard.setVisibility(Preference.showDockIcon)
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
        var title: String = (Preference.showSeconds ? Date.now.stringTimeWithSeconds : Date.now.stringTime)

        if Preference.useFlashDots && Date.now.seconds % 2 == 0 {
            title = title.replacingOccurrences(of: ":", with: " ")
        }

        // statusButton.title = title
        let randNum = Int.random(in: 0...4)
        statusButton.title = text[randNum]
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
        
        DockIcon.standard.setVisibility(Preference.showDockIcon)
        
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
    
    @objc
    func addReminder(_ sender: NSMenuItem) {
        if let vc = WindowsManager.getVC(withIdentifier: "NewReminderVC", ofType: NewReminderVC.self) {
            vc.delegate = self
            let window: NSWindow = {
                let w = NSWindow(contentViewController: vc)
                
                w.styleMask.remove(.fullScreen)
                w.styleMask.remove(.resizable)
                w.styleMask.remove(.miniaturizable)
                
                w.level = .floating
                
                return w
            }()
            
//            if REMINDERS_WINDOW_CONTROLLER.window == nil {
//                REMINDERS_WINDOW_CONTROLLER.window = window
//            }
//
//            REMINDERS_WINDOW_CONTROLLER.showWindow(self)
        }
    }
}

extension AppDelegate: NewReminderVCDelegate, ReminderDelegate {
    
    // On submit close the window and save the reminder
    func onSubmit(_ sender: NSButton, reminder: Reminder) {
        reminder.delegate = self
        if reminder.tag == nil {
            reminder.tag = reminders.count
        }
        
//        REMINDERS_WINDOW_CONTROLLER.close()
        reminders.append(reminder)
    }
    
    // Once a reminder is fired, let's delete it
    func onReminderFired(_ reminder: Reminder) {
        reminders.removeAll(where: { $0.tag == reminder.tag })
    }
}

/*
 * -----------------------
 * MARK: - Utilities
 * ------------------------
 */
extension AppDelegate {
    private func getRemindersMenu() -> NSMenu {
        let menu = NSMenu()
        
        for reminder in self.reminders {
            menu.addItem(.init(title: reminder.title, action: nil, keyEquivalent: ""))
        }
        
        return menu
    }
}
