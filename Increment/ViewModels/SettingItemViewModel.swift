//
//  SettingItemViewModel.swift
//  Increment
//
//  Created by Chirag's on 30/09/20.
//

import Foundation
extension SettingsViewModel {
    struct SettingsItemViewModel {
        let title: String
        let iconName: String
        let type: SettingItemType
    }
    
    enum SettingItemType {
        case account
        case mode
        case privacy
    }
}
