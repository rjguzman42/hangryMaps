//
//  UserEditView.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/11/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class UserEditView: UIView {
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: Constants.Sizes.profileImageLarge.width, height: Constants.Sizes.profileImageLarge.height)
        view.clipsToBounds = true
        view.layer.cornerRadius = view.bounds.size.width / 2
        view.isUserInteractionEnabled = true
        view.backgroundColor = Theme.Colors.backgroundBlack.color
        return view
    }()
    let cameraImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        view.image = UIImage(named: "ic_camera")
        view.tintColor = .white
        return view
    }()
    lazy var userNameEdit: UserInput = {
        let input = UserInput(frame: CGRect(), placeHolderText: Constants.Strings.userNameHint)
        input.setBoxedTheme()
        input.setUserNameAttributes()
        input.tag = 0
        input.delegate = self
        return input
    }()
    let userManager = UserManager.sharedInstance
    let utility = AppUtility.sharedInstance
    let libraryAPI = LibraryAPI.sharedInstance
    var imageWasEdited = false
    var nameWasEdited = false
    var chosenImage: UIImage?
    lazy var picker: UIImagePickerController? = {
        let cameraPicker = UIImagePickerController()
        return cameraPicker
    }()
    lazy var currentViewController = utility.getCurrentViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        addUserInfo()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        backgroundColor = Theme.Colors.reallyWhite.color
        
        //profileImageView
        addSubview(profileImageView)
        addConstraintsWithFormat(format: "H:[v0(\(Constants.Sizes.profileImageLarge.width))]", views: profileImageView)
        addConstraintsWithFormat(format: "V:|-20-[v0(\(Constants.Sizes.profileImageLarge.height))]", views: profileImageView)
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        //userNameEdit
        addSubview(userNameEdit)
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: userNameEdit)
        addConstraintsWithFormat(format: "V:[v1]-25-[v0(\(Constants.Sizes.userInputHeight))]", views: userNameEdit, profileImageView)
        userNameEdit.delegate = self
        
        //cameraImageView
        addSubview(cameraImageView)
        addConstraintsWithFormat(format: "H:[v0(\(Constants.Sizes.cameraImage.width))]", views: cameraImageView)
        addConstraintsWithFormat(format: "V:[v0(\(Constants.Sizes.cameraImage.height))]", views: cameraImageView)
        addConstraint(NSLayoutConstraint(item: cameraImageView, attribute: .centerX, relatedBy: .equal, toItem: profileImageView, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: cameraImageView, attribute: .centerY, relatedBy: .equal, toItem: profileImageView, attribute: .centerY, multiplier: 1, constant: 0))
        
        addGestures()
    }
    
    func addUserInfo() {
        if let name = userManager.localUser?.name {
            userNameEdit.text = name
        }
        if let profileImageData = userManager.localUser?.profileImageData {
            profileImageView.image = UIImage(data: profileImageData)
        } else if let profileImagePath = userManager.localUser?.profileImagePath {
            libraryAPI.downloadImageWithPath(path: profileImagePath, completion: { [weak self] image, data in
                if image != nil {
                    self?.profileImageView.image = image
                }
            })
        }
    }
    
    
    //MARK: Actions
    
    func addGestures() {
        userNameEdit.addTarget(self, action:#selector(userNametextFieldEdited), for:UIControlEvents.editingChanged)
        
        let tapGesture = UITapGestureRecognizer(target:self, action:#selector(profileImageViewTapped(_ :)))
        profileImageView.addGestureRecognizer(tapGesture)
        
        let tapTwoGesture = UITapGestureRecognizer(target:self, action:#selector(profileImageViewTapped(_ :)))
        cameraImageView.addGestureRecognizer(tapTwoGesture)
    }
    
    @objc func userNametextFieldEdited() {
        //replace any space characters with a "_"
        let text = userNameEdit.text?.replacingOccurrences(of: " ", with: "_")
        userNameEdit.text = text
    }
    
    @objc func profileImageViewTapped(_ sender: AnyObject?) {
        userNameEdit.resignFirstResponder()
        showCameraPrompt()
    }
    
    func showCameraPrompt() {
        let alert = UIAlertController(title: Constants.Strings.chooseImage, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: Constants.Strings.camera, style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: Constants.Strings.gallery, style: .default) {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: Constants.Strings.cancel, style: .cancel) {
            UIAlertAction in
        }
        
        picker?.delegate = self
        picker?.allowsEditing = true
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = profileImageView
            presenter.sourceRect = profileImageView.bounds
        }
        currentViewController?.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            picker!.sourceType = .camera
            currentViewController?.present(picker!, animated: true, completion: nil)
        } else {
            openGallery()
        }
    }
    func openGallery() {
        picker!.sourceType = .photoLibrary
        if UIDevice.current.userInterfaceIdiom == .phone || UIDevice.current.userInterfaceIdiom == .pad {
            self.currentViewController?.present(picker!, animated: true, completion: {
                self.picker!.navigationBar.topItem?.rightBarButtonItem?.tintColor = .black
            })
        } else {
            
        }
    }
}


//MARK: UITextFieldDelegate

extension UserEditView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textFieldToChange.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if(textFieldToChange.tag == 0) {
            let charactersNotAllowed = userNameEdit.charactersNotAllowed(type: "name")
            if let _ = string.rangeOfCharacter(from: charactersNotAllowed, options: .    caseInsensitive) {
                return false
            } else {
                nameWasEdited = true
                return true
            }
        }
        return true
    }
}


//MARK: UIImagePickerControllerDelegate

extension UserEditView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageWasEdited = true
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        chosenImage = image
        profileImageView.image = image
        cameraImageView.image = nil
        let _ = info[UIImagePickerControllerCropRect]
        picker.dismiss(animated: true, completion: {
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
