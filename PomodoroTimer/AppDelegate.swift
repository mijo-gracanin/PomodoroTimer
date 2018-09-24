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
    
    var pomodoroTimer: PomodoroTimer?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        pomodoroTimer = PomodoroTimer()
    }
    

}
