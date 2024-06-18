//
//  SwiftUIView.swift
//  
//
//  Created by Chen Hai Teng on 6/18/24.
//

import SwiftUI

public enum EasyAdMobMode {
    case normal
    case mock
}

public struct EasyAdMobModeKey: EnvironmentKey {
    public static var defaultValue: EasyAdMobMode = .normal
}

public extension EnvironmentValues {
    var easyAdMode: EasyAdMobMode {
        get { self[EasyAdMobModeKey.self] }
        set { self[EasyAdMobModeKey.self] =  newValue }
    }
}
