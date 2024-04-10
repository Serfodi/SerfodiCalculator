//
//  ColorAppearance.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 30.03.2024.
//

import UIKit

enum EnvironmentColorAppearance {
    static let mainBackgroundColor = SchemeColor(light: .white, dark: .black)
    static let mainTextColor = SchemeColor(light: .black, dark: .init(white: 0.9, alpha: 1))
    static let mainErrorColor = SchemeColor(light: #colorLiteral(red: 0.9568627477, green: 0.8265123661, blue: 0.7767734047, alpha: 1), dark: #colorLiteral(red: 0.9568627477, green: 0.8265123661, blue: 0.7767734047, alpha: 1))
}

enum DisplayLabelAppearance {
    static let titleColor = EnvironmentColorAppearance.mainTextColor
    static let focusColor = SchemeColor(light: .black.withAlphaComponent(0.07), dark: .white.withAlphaComponent(0.2))
    static let backgroundColor = UIColor.clear
}

enum NumpadAppearance {
    
    static let numpadColor = SchemeColor(light: #colorLiteral(red: 0.9729686379, green: 0.9481814504, blue: 0.8923994303, alpha: 1), dark: #colorLiteral(red: 0.1254901961, green: 0.1215686275, blue: 0.1411764706, alpha: 1))
    
    enum NumberButton {
        static let titleColor = SchemeColor(light: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), dark: #colorLiteral(red: 0.737254902, green: 0.7411764706, blue: 0.7529411765, alpha: 1))
        static let normalColor = SchemeColor(light: #colorLiteral(red: 0.5803921569, green: 0.8156862745, blue: 0.9921568627, alpha: 1), dark: #colorLiteral(red: 0.2039215686, green: 0.1764705882, blue: 0.3137254902, alpha: 1))
    }
    
    enum OperatingButton {
        enum BGColor {
            static let normal = SchemeColor(light: #colorLiteral(red: 1, green: 0.5486019254, blue: 0.635882616, alpha: 1), dark: #colorLiteral(red: 0.537254902, green: 0.3333333333, blue: 0.4588235294, alpha: 1))
            static let selected = SchemeColor(light: .white, dark: .black)
        }
        enum TitleColor {
            static let normal = SchemeColor(light: #colorLiteral(red: 0.4549019608, green: 0.1294117647, blue: 0.2117647059, alpha: 1), dark: #colorLiteral(red: 0.7882352941, green: 0.7137254902, blue: 0.7450980392, alpha: 1))
            static let highlighted = SchemeColor(light: #colorLiteral(red: 0.9689275622, green: 0.4173462987, blue: 0.5241467357, alpha: 1), dark: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
            static let selected = SchemeColor(light: #colorLiteral(red: 0.9529411765, green: 0.5725490196, blue: 0.6392156863, alpha: 1), dark: #colorLiteral(red: 0.537254902, green: 0.3333333333, blue: 0.4588235294, alpha: 1))
        }
    }
    
    enum OperatingSecondButton {
        static let titleColor = SchemeColor(light: #colorLiteral(red: 0.1294117647, green: 0.3058823529, blue: 0.2039215686, alpha: 1), dark: #colorLiteral(red: 0.7882352941, green: 0.7137254902, blue: 0.7450980392, alpha: 1))
        static let normalColor = SchemeColor(light: #colorLiteral(red: 0.7882352941, green: 0.7960784314, blue: 0.6470588235, alpha: 1), dark: #colorLiteral(red: 0.537254902, green: 0.3333333333, blue: 0.4588235294, alpha: 1))
        static let selectedColor = SchemeColor(light: .white, dark: .black)
    }
    
    enum ServiceButton {
        static let titleColor = SchemeColor(light: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), dark: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        static let normalColor = SchemeColor(light: #colorLiteral(red: 0.9921568627, green: 0.8196078431, blue: 0.5803921569, alpha: 1), dark: #colorLiteral(red: 0.7098039216, green: 0.6470588235, blue: 0.6274509804, alpha: 1))
    }
    
    enum PullButton {
        static let normalColor = SchemeColor(light: .black.withAlphaComponent(0.07), dark: .white.withAlphaComponent(0.2))
        static let highlightedColor = SchemeColor(light: .black.withAlphaComponent(0.04), dark: .white.withAlphaComponent(0.3))
    }
    
}

enum NavigationAppearance {
    
    static let backgroundColor = EnvironmentColorAppearance.mainBackgroundColor
    static let leftBarButtonColor = SchemeColor(light: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), dark: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
}

enum HistoryAppearance {
    
    static let backgroundBlurColor = SchemeColor(light: .clear, dark: .black.withAlphaComponent(0.1))
    static let exampleColor = EnvironmentColorAppearance.mainTextColor
    static let backgroundColor = UIColor.clear
    
    enum HistoryCellExample {
        static let numberColor = SchemeColor(light: UIColor(white: 0.5, alpha: 0.70), dark: UIColor(white: 0.5, alpha: 0.70))
        static let signColor = SchemeColor(light: UIColor(white: 0.25, alpha: 0.70), dark:  UIColor(white: 0.75, alpha: 0.70))
        static let equalColor = SchemeColor(light: UIColor(white: 0, alpha: 0.70), dark: UIColor(white: 1, alpha: 0.70))
        static let resultColor = EnvironmentColorAppearance.mainTextColor
    }
}

enum SettingColorAppearance {
    
    enum ButtonCell {
        static let titleColor = SchemeColor(light: .white, dark: .init(white: 0.9, alpha: 1))
        static let normalColor = SchemeColor(light: #colorLiteral(red: 0.2941176471, green: 0.6509803922, blue: 0.9764705882, alpha: 1), dark: #colorLiteral(red: 0.2941176471, green: 0.6509803922, blue: 0.9764705882, alpha: 1))
    }
    
}
