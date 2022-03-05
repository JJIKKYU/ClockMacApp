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


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("앱 실행 완료")
        
        guard let statusButton = statusBarItem.button else { return }
        statusButton.title = "Advanced Clock"
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

