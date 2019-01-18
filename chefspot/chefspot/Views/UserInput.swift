//
//  UserInput.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/11/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class UserInput: UITextField {
    
    init(frame: CGRect, placeHolderText: String) {
        super.init(frame: frame)
        placeholder = placeHolderText
        setDefaultAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setDefaultAttributes() {
        setDarkTheme()
        textAlignment = .center
        isUserInteractionEnabled = true
        autocapitalizationType = .sentences
        adjustsFontSizeToFitWidth = true
        font = Theme.Fonts.titleBold.font
        text = ""
        tintColor = Theme.Colors.primaryPurple.color
    }
    
    func setUserNameAttributes() {
        autocapitalizationType = .words
    }
    
    func setDarkTheme() {
        textColor = Theme.Colors.primaryText.color
        backgroundColor = .clear
        if let plaeholderText = placeholder {
            attributedPlaceholder = NSAttributedString(string: plaeholderText, attributes: [NSAttributedStringKey.foregroundColor: Theme.Colors.hintGray.color])
        }
    }
    
    func setLightTheme() {
        textColor = Theme.Colors.primaryTextLight.color
        backgroundColor = .clear
        if let plaeholderText = placeholder {
            attributedPlaceholder = NSAttributedString(string: plaeholderText, attributes: [NSAttributedStringKey.foregroundColor: Theme.Colors.hintGray.color])
        }
    }
    
    func setBoxedTheme() {
        textAlignment = .left
        clearButtonMode = .whileEditing
        borderStyle = .roundedRect
    }
    
    func setDefaultAttributesWithColor(foregroundColor: UIColor, strokeColor: UIColor) {
        let memeTextAttributes:[String: Any] = [
            NSAttributedStringKey.strokeColor.rawValue: strokeColor,
            NSAttributedStringKey.foregroundColor.rawValue: foregroundColor,
            NSAttributedStringKey.strokeWidth.rawValue: 1.0]
        defaultTextAttributes = memeTextAttributes
    }
    
    func charactersNotAllowed(type: String? = "general") -> CharacterSet {
        let characterSetNotAllowed = NSMutableCharacterSet()
        characterSetNotAllowed.formUnion(with: .symbols)
        if type == "name" {
            characterSetNotAllowed.addCharacters(in: Constants.Strings.nameInputCharactersNotAllowed)
        } else {
            characterSetNotAllowed.addCharacters(in: Constants.Strings.generalInputCharactersNotAllowed)
        }
        return characterSetNotAllowed as CharacterSet
    }
}
