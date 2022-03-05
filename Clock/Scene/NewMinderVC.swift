//
//  NewMinderVC.swift
//  Clock
//
//  Created by 정진균 on 2022/03/05.
//

import Cocoa

protocol NewReminderVCDelegate {
    func onSubmit(_ sender: NSButton, reminder: Reminder) -> Void
}

class NewReminderVC: NSViewController {
    @IBOutlet weak var taskTitle: NSTextField!
    @IBOutlet var taskDescr: NSTextView!
    @IBOutlet weak var datePicker: NSDatePicker!
    
    var delegate: NewReminderVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTitle.stringValue = ""
        taskDescr.string = ""
        
        datePicker.calendar = Calendar.current
        datePicker.dateValue = Date.now
    }
    
    @IBAction func onSubmit(_ sender: NSButton) {
        let reminder = Reminder(taskTitle.stringValue,
                                description: taskDescr.string,
                                fireOnDate: datePicker.dateValue,
                                tag: nil
        )
        
        delegate.onSubmit(sender, reminder: reminder)
    }
}
