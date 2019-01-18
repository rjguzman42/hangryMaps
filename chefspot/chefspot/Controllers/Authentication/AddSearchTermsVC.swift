//
//  AddSearchTermsVC.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/16/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class AddSearchTermsVC: UIViewController {
    
    let nextButton: FlatButton = {
        let button = FlatButton(frame: CGRect(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: Constants.Sizes.flatButtonHeight))
        button.setTitle(Constants.Strings.next, for: .normal)
        button.setLargeTheme()
        return button
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.headerReferenceSize = Constants.Sizes.addSearchTermView
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Theme.Colors.reallyWhite.color
        cv.contentInset = UIEdgeInsetsMake(0,0,0,0)
        cv.isPagingEnabled = false
        cv.bounces = true
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.tag = 1
        return cv
    }()
    let addSearchTermsView: AddSearchTermsView = {
        let view = AddSearchTermsView(frame: CGRect(x: 0, y: 10, width: Constants.Sizes.addSearchTermView.width, height: 200))
        return view
    }()
    let gridSize: Int = 3
    let dataManager = DataManager.sharedInstance
    let utility = AppUtility.sharedInstance
    var termsDidChange: Bool = false
    var setDone: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSavedData()
        setupSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        utility.hideStatusBar(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if termsDidChange {
            notifyOfUpdate()
        }
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        view.backgroundColor = Theme.Colors.reallyWhite.color
        title = ""
    
        //nextButton
        view.addSubview(nextButton)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: nextButton)
        view.addConstraintsWithFormat(format: "V:[v0(\(Constants.Sizes.flatButtonHeight))]-20-|", views: nextButton)
        
        //collectionView
        view.addSubview(collectionView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat(format: "V:|[v0]-10-[v1]", views: collectionView, nextButton)
        collectionView.register(SearchTermCell.self, forCellWithReuseIdentifier: Constants.Cells.searchTermCellId)
        collectionView.addSubview(addSearchTermsView)
        collectionView.contentInset = UIEdgeInsetsMake(45, 0, 0, 0)
        
        addGestures()
    }
    
    func setDoneButton() {
        //change title
        nextButton.setTitle(Constants.Strings.done, for: .normal)
        
        //remove previous gestures
        for gesture in nextButton.gestureRecognizers ?? [] {
            nextButton.removeGestureRecognizer(gesture)
        }
        
        //add new gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backAction))
        nextButton.addGestureRecognizer(tapGesture)
    }
    
    
    //MARK: Content
    
    func loadSavedData() {
        dataManager.getSearchTerms(type: SearchTermType.saved)
    }
    
    func addTermByName(_ term: String, selectedIconName: String) {
        let lastOrder = dataManager.savedSearchTerms.last?.order ?? 0
        dataManager.saveSearchTerm(term, imageName: selectedIconName, type: SearchTermType.saved, order: Int(lastOrder + 1))
        updatedTerms()
    }
    
    func removeTerm(_ term: SearchTerm) {
        dataManager.removeSearchTerm(term)
        updatedTerms()
    }
    
    func updatedTerms() {
        collectionView.reloadData()
        termsDidChange = true
    }
    
    func checkSearchTermCount() -> Bool {
        if dataManager.savedSearchTerms.count >= 3 {
            return true
        }
        utility.showAlert(Constants.Alerts.notEnoughSavedSearchesTitle, message: Constants.Alerts.notEnoughSavedSearchesDescription, vc: self)
        return false
    }
    
    
    //MARK: Notifications
    
    func notifyOfUpdate() {
        NotificationCenter.default.post(name: .savedFoodItemsUpdated, object: self)
    }
    
    
    //MARK: Actions
    
    func addGestures() {
        if setDone {
            setDoneButton()
        } else {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNextButtonTapped))
            nextButton.addGestureRecognizer(tapGesture)
        }
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeViewGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleNextButtonTapped() {
        if checkSearchTermCount() {
            presentCreateUserVC()
        }
    }
    
    @objc func handleSwipeViewGesture(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.right:
            break
        case UISwipeGestureRecognizerDirection.down:
            //hide keyboards
            addSearchTermsView.termInput.resignFirstResponder()
            break
        case UISwipeGestureRecognizerDirection.left:
            break
        case UISwipeGestureRecognizerDirection.up:
            break
        default:
            break
        }
    }
    
    func presentCreateUserVC() {
        let createUserInfoVC = CreateUserInfoVC()
        navigationController?.pushViewController(createUserInfoVC, animated: true)
    }
    
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: UICollectionViewDelegate

extension AddSearchTermsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.savedSearchTerms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let term = dataManager.savedSearchTerms[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.searchTermCellId, for: indexPath) as! SearchTermCell
        cell.title.text = term.name
        if let imageName = term.imageName {
            let size = Constants.Strings.foodItemSizeLarge
            let sizedName = size + imageName
            cell.termIcon.image = UIImage(named: sizedName)
        }
        return cell
    }
    
    
    //MARK: CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let term = dataManager.savedSearchTerms[indexPath.row]
        let name = term.name ?? ""
        utility.showAlertWithHandler("\(Constants.Alerts.removeTermTitle) \(name)?", message: "", approveTitle: Constants.Alerts.yes, dismissTitle: Constants.Strings.cancel, vc: self, completion: {[weak self] alert, dismissed in
            if !dismissed {
                self?.removeTerm(term)
            }
        })
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    //MARK: CollectionView Delegate Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.getFittedSizeForItem(numberOfColumns: gridSize)
    }
}
