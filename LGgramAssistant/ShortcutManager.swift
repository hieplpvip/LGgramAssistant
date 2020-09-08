//
//  ShortcutManager.swift
//  LGgramAssistant
//
//  Created by Matt on 17.04.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import Cocoa

final class ShortcutManager {
    static let mirroringMonitorShortcut = Shortcut(key: .f16, modifiers: [])
    static let disableWlanShortcut = Shortcut(key: .f19, modifiers: [])
    static let disableBluetoothShortcut = Shortcut(key: .f19, modifiers: [.leftShift])
    static let systemPrefsShortcut = Shortcut(key: .f17, modifiers: [])
    static let nightShiftShortcut = Shortcut(key: .f18, modifiers: [])
    static let sleepShortcut = Shortcut(key: .f20, modifiers: [])
    // static let backlightOffShortcut = Shortcut(key: .f16, modifiers: [.leftShift])
    // static let backlightDimmedShortcut = Shortcut(key: .f16, modifiers: [.rightShift])
    // static let backlightBrightShortcut = Shortcut(key: .f19, modifiers: [.leftShift])

    static func register() {
        ShortcutMonitor.shared.register(systemPrefsShortcut, withAction: {
            startApp(withBundleIdentifier: "com.apple.systempreferences")
        })

        ShortcutMonitor.shared.register(disableBluetoothShortcut, withAction: {
            if(BluetoothManager.isEnabled() == true){
                HUD.showImage(Icons.bluetoothOff, status: NSLocalizedString("Bluetooth\ndisabled", comment: ""))
                BluetoothManager.disableBluetooth()
            } else {
                HUD.showImage(Icons.bluetoothOn, status: NSLocalizedString("Bluetooth\nenabled", comment: ""))
                BluetoothManager.enableBluetooth()
            }
        })

        ShortcutMonitor.shared.register(nightShiftShortcut, withAction: {
            NightShiftManager.toggleCBBlueLight()
        })

        ShortcutMonitor.shared.register(sleepShortcut, withAction: {
            SleepManager.goToSleep()
        })

        ShortcutMonitor.shared.register(disableWlanShortcut, withAction: {
            if(WifiManager.isPowered() == nil){
                return
            } else if(WifiManager.isPowered() == true){
                HUD.showImage(Icons.wlanOff, status: NSLocalizedString("Wi-Fi\ndisabled", comment: ""))
                WifiManager.disableWifi()
            } else {
                HUD.showImage(Icons.wlanOn, status: NSLocalizedString("Wi-Fi\nenabled", comment: ""))
                WifiManager.enableWifi()
            }
        })

        ShortcutMonitor.shared.register(mirroringMonitorShortcut, withAction: {
            if(DisplayManager.isDisplayMirrored() == true){
                DispatchQueue.background(background: {
                    DisplayManager.disableHardwareMirroring()
                }, completion:{
                    HUD.showImage(Icons.extending, status: NSLocalizedString("Screen\nextending", comment: ""))
                })
            } else {
                DispatchQueue.background(background: {
                    DisplayManager.enableHardwareMirroring()
                }, completion:{
                    HUD.showImage(Icons.mirroring, status: NSLocalizedString("Screen\nmirroring", comment: ""))
                })
            }
        })

        // ShortcutMonitor.shared.register(backlightOffShortcut, withAction: {
        //     HUD.showImage(Icons.backlightOff, status: NSLocalizedString("Backlight\noff", comment: ""))
        // })

        // ShortcutMonitor.shared.register(backlightDimmedShortcut, withAction: {
        //     HUD.showImage(Icons.backlightDimmed, status: NSLocalizedString("Backlight\ndimmed", comment: ""))
        // })

        // ShortcutMonitor.shared.register(backlightBrightShortcut, withAction: {
        //     HUD.showImage(Icons.backlightBright, status: NSLocalizedString("Backlight\nbright", comment: ""))
        // })
    }

    static func unregister() {
        ShortcutMonitor.shared.unregisterAllShortcuts()
    }

    private static func startApp(withBundleIdentifier: String){
        let focusedApp = NSWorkspace.shared.frontmostApplication?.bundleIdentifier

        if(withBundleIdentifier == focusedApp){
            NSRunningApplication.runningApplications(withBundleIdentifier: focusedApp!).first?.hide()
        } else {
            NSWorkspace.shared.launchApplication(withBundleIdentifier: withBundleIdentifier, options: NSWorkspace.LaunchOptions.default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
        }
    }
}
