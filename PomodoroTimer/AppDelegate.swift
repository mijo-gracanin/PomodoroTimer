//
//  AppDelegate.swift
//  PomodoroTimer
//
//  Created by Mijo Gracanin on 26/03/2017.
//  Copyright © 2017 MijoCoder. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var timer: Timer?
    private let statusItem = NSStatusBar.system().statusItem(withLength: 42)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.action = #selector(terminate)
        
        let startDate = Date()
        let pomodoroInterval: Double = 25 * 60
        
        self.statusItem.title = formatTime(seconds: pomodoroInterval)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] timer in
            guard let `self` = self else { return }
            let remainingTime = pomodoroInterval - Date().timeIntervalSince(startDate)
            
            if remainingTime < 0 {
                timer.invalidate()
                let notification = NSUserNotification()
                notification.title = "Pomodoro!"
                notification.soundName = "Blow"
                NSUserNotificationCenter.default.deliver(notification)
            }
            else {
                self.statusItem.title = self.formatTime(seconds: remainingTime)
            }
        })
    }
    
    func formatTime(seconds: TimeInterval) -> String {
        let minutes = Int(seconds / 60)
        let remainingSeconds = Int(seconds) % 60
        return String(format:"%02d:%02d", minutes, remainingSeconds)
    }

    func terminate() {
        NSApp.terminate(self)
    }
}
