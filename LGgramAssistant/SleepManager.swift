//
//  SleepManager.swift
//  LGgramAssistant
//
//  Created by Le Bao Hiep on 9/8/20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

final class SleepManager {
    private static var isOSDloaded = false

    static func goToSleep() {
        if (!isOSDloaded) {
            isOSDloaded = _loadOSDFramework()
        }
        if (isOSDloaded) {
            _goToSleep()
        }
    }
}
