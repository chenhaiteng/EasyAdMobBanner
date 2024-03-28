//
//  DebugLog.swift
//  EasyAdMobBanner
//
//  Created by Chen Hai Teng on 3/28/24.
//

import OSLog


@available(macOS 11.0, iOS 14.0, *)
extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let logger = Logger(subsystem: subsystem, category: "EasyAdMob")
}
