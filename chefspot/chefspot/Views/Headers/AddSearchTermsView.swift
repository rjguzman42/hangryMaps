//
//  AddSearchTermsView.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/18/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation

class AddSearchTermsView: UIView {
    
    let addButton: FlatButton = {
        let button = FlatButton(frame: CGRect(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: Constants.Sizes.flatButtonHeight))
        button.setTitle(Constants.Strings.add, for: .normal)
        button.setBoxedTheme()
        return button
    }()
    lazy var termInput: UserInput = {
        let input = UserInput(frame: CGRect(), placeHolderText: Constants.Strings.addTermHint)
        input.setBoxedTheme()
        input.tag = 0
        input.delegate = self
        return input
    }()
    let myItemsTitleView: TitleHeaderView = {
        let view = TitleHeaderView()
        view.titleLabel.text = Constants.Strings.myItems
        return view
    }()
    let addItemTitleView: TitleHeaderView = {
        let view = TitleHeaderView()
        view.titleLabel.text = Constants.Strings.addItem
        return view
    }()
    let termAppearanceView: TermAppearanceView = {
        let view = TermAppearanceView(frame: CGRect(x: 0, y: 0, width: Constants.Sizes.termAppearanceView.width, height: Constants.Sizes.termAppearanceView.height))
        return view
    }()
    let utility = AppUtility.sharedInstance
    var selectedIcon: String = {
        let dataManager = DataManager.sharedInstance
        return dataManager.availableTermIcons.first!
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        
       backgroundColor = Theme.Colors.reallyWhite.color
        
        //addItemTitleView
        addSubview(addItemTitleView)
        addConstraintsWithFormat(format: "H:|-10-[v0]-80-|", views: addItemTitleView)
        addConstraintsWithFormat(format: "V:|[v0]", views: addItemTitleView)
        
        //termInput
        addSubview(termInput)
        addConstraintsWithFormat(format: "H:|-10-[v0]-80-|", views: termInput)
        addConstraintsWithFormat(format: "V:[v1]-10-[v0(\(Constants.Sizes.userInputHeight))]", views: termInput, addItemTitleView)
        addConstraint(NSLayoutConstraint(item: termInput, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -(bounds.size.height / 4)))
        
        //addButton
        addSubview(addButton)
        addConstraintsWithFormat(format: "H:[v1]-5-[v0]-10-|", views: addButton, termInput)
        addConstraintsWithFormat(format: "V:[v0(\(Constants.Sizes.userInputHeight))]", views: addButton)
        addConstraint(NSLayoutConstraint(item: addButton, attribute: .centerY, relatedBy: .equal, toItem: termInput, attribute: .centerY, multiplier: 1, constant: 0))
        
        //termAppearanceView
        addSubview(termAppearanceView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: termAppearanceView)
        addConstraintsWithFormat(format: "V:[v1]-10-[v0(\(Constants.Sizes.termAppearanceView.height))]", views: termAppearanceView, termInput)
        termAppearanceView.iconTapped = {[weak self] imageName in
            if self != nil {
                self?.handleSelectedIcon(imageName)
            }
        }
        
        //myItemsTitleView
        addSubview(myItemsTitleView)
        addConstraintsWithFormat(format: "H:|-10-[v0]-80-|", views: myItemsTitleView)
        addConstraintsWithFormat(format: "V:[v1]-40-[v0(\(myItemsTitleView.titleLabel.font.pointSize))]", views: myItemsTitleView, termAppearanceView)
        
        addGestures()
    }
    
    
    //MARK: Actions
    
    func addGestures() {
        let tapAddGesture = UITapGestureRecognizer(target: self, action: #selector(handleAddButtonTapped))
        addButton.addGestureRecognizer(tapAddGesture)
    }

    @objc func handleAddButtonTapped() {
        if let termName = termInput.text {
            if let addTermsVC = self.parentViewController as? AddSearchTermsVC {
                addTermsVC.addTermByName(termName, selectedIconName: selectedIcon)
            }
            termInput.text = ""
        }
    }
    
    func handleSelectedIcon(_ imageName: String) {
        selectedIcon = imageName
    }
}

//MARK: UITextFieldDelegate

extension AddSearchTermsView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textFieldToChange.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if(textFieldToChange.tag == 0) {
            let charactersNotAllowed = termInput.charactersNotAllowed()
            if let _ = string.rangeOfCharacter(from: charactersNotAllowed, options: .    caseInsensitive) {
                return false
            } else {
                return true
            }
        }
        return true
    }
}
