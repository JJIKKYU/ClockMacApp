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

        statusButton.title = Date.now.stringTimeWithSeconds
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateStatusText),
                                     userInfo: nil,
                                     repeats: true
        )
        
        /*
         This will update 'title' of 'statusBarItem' even if is highligheted.
         */
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    @objc
    func updateStatusText(_ sender: Timer) {
        guard let statusButton = statusBarItem.button else { return }
//        let randNum = Int.random(in: 0...4)
//        statusButton.title = text[randNum]
        
        statusButton.title = Date.now.stringTimeWithSeconds
        print("\(Date.now.stringTimeWithSeconds)")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

