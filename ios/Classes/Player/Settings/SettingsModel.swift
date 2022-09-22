//
//  SettingsModel.swift
//  Runner
//
//  Created by Sunnatillo Shavkatov on 21/04/22.
//


import UIKit

struct SettingModel {
    var leftIcon,title,configureLabel: String
    
    init(leftIcon: String,title: String, configureLabel: String){
        self.leftIcon = leftIcon
        self.title = title
        self.configureLabel = configureLabel
    }
}
