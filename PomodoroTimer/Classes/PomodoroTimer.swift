//
//  PomodoroTimer.swift
//  PomodoroTimer
//
//  Created by Mijo Gracanin on 22/09/2018.
//  Copyright © 2018 MijoCoder. All rights reserved.
//

import Cocoa


class PomodoroTimer {
    
    private var timer: Timer?
    private let statusItem: NSStatusItem
    private let workInterval: TimeInterval = 25 * 60
    private let restInterval: TimeInterval = 5 * 60
    private var selectedInterval: TimeInterval = 0
    private var startDate = Date()
    private var pomodoroCount = 0
    private var notificationShown = false
    
    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength) // 42
        statusItem.button?.title = "Pomodoro"
        statusItem.target = self
        
        setupMenu()
    }
}

// MARK: - Private
private extension PomodoroTimer {
    
    private func setupMenu() {
        let menu = NSMenu(title: "Pomodoro")
        menu.addItem(withTitle: "Work", action: #selector(startWorkTimer), keyEquivalent: "").target = self
        menu.addItem(withTitle: "Rest", action: #selector(startRestTimer), keyEquivalent: "").target = self
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Quit", action: #selector(terminate), keyEquivalent: "").target = self
        statusItem.menu = menu
    }
    
    @objc private func startWorkTimer() {
        startTimer(timeInterval: workInterval, onTimeChange: { [weak self] timer in
            self?.update(workTimer: timer)
        })
    }
    
    @objc private func startRestTimer() {
        startTimer(timeInterval: restInterval, onTimeChange: { [weak self] timer in
            self?.update(restTimer: timer)
        })
    }
    
    @objc private func terminate() {
        timer?.invalidate()
        NSApp.terminate(self)
    }
    
    private func startTimer(timeInterval: TimeInterval, onTimeChange: @escaping (Timer) -> Void) {
        selectedInterval = timeInterval
        startDate = Date()
        timer?.invalidate()
        notificationShown = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5,
                                     repeats: true,
                                     block: onTimeChange)
    }
    
    private func update(workTimer: Timer) {
        let elapsedTime = Date().timeIntervalSince(startDate)
        let remainingTime = selectedInterval - elapsedTime
        
        if remainingTime < 0 {
            workTimer.invalidate()
            pomodoroCount += 1
            showNotification(title: "++Pomodoro")
            statusItem.button?.title =  "Pomodoro count: \(pomodoroCount)"
        }
        else {
            statusItem.button?.title = PomodoroTimer.formatTime(seconds: remainingTime)
        }
    }
    
    private func update(restTimer: Timer) {
        let elapsedTime = Date().timeIntervalSince(startDate)
        let remainingTime = selectedInterval - elapsedTime
        
        if remainingTime < 0 && !notificationShown {
            showNotification(title: "Rest is over!")
        }

        statusItem.button?.title = PomodoroTimer.formatTime(seconds: remainingTime)
    }
    
    private func showNotification(title: String) {
        let notification = NSUserNotification()
        notification.title = title
        notification.soundName = "Blow"
        NSUserNotificationCenter.default.deliver(notification)
        notificationShown = true
    }
    
    private static func formatTime(seconds: TimeInterval) -> String {
        let positivityPrefix = seconds >= 0 ? "" : "-"
        let absSeconds = abs(seconds)
        let minutes = Int(absSeconds / 60)
        let remainingSeconds = Int(absSeconds) % 60
        return String(format:"%@%02d:%02d", positivityPrefix, minutes, remainingSeconds)
    }
}
