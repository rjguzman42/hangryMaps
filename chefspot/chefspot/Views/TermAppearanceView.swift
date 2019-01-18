//
//  TermAppearanceView.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/19/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class TermAppearanceView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Strings.appearance
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = Theme.Fonts.primaryMedium.font
        label.textColor = Theme.Colors.hintGray.color
        label.textAlignment = .left
        return label
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width =  Constants.Sizes.termAppearanceCell.width
        let height = Constants.Sizes.termAppearanceCell.height
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
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
    let dataManager = DataManager.sharedInstance
    var selectedIcon: String = {
        let dataManager = DataManager.sharedInstance
        return dataManager.availableTermIcons.first!
    }()
    var selectedIndex: Int = 0
    var iconTapped: ((_ imageName: String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        backgroundColor = Theme.Colors.reallyWhite.color
        
        //titleLabel
        addSubview(titleLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: titleLabel)
        addConstraintsWithFormat(format: "V:|[v0]", views: titleLabel)
        
        //collectionView
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:[v1]-10-[v0]|", views: collectionView, titleLabel)
        collectionView.register(TermIconCell.self, forCellWithReuseIdentifier: Constants.Cells.termIconCellId)
    }
    
    func handleIconTapped(indexPath: IndexPath, name: String) {
        if iconTapped != nil {
            
            //deselect previous term
            if let cell = collectionView.cellForItem(at: IndexPath(row: selectedIndex, section: 0)) as? TermIconCell {
                cell.selectTerm(false)
            }
            
            //set new term
            selectedIndex = indexPath.row
            selectedIcon = name
            iconTapped!(name)
        }
    }
    
}

//MARK: UICollectionViewDelegate

extension TermAppearanceView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.availableTermIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.termIconCellId, for: indexPath) as! TermIconCell
        let imageName = dataManager.availableTermIcons[indexPath.row]
        cell.imageName = imageName
        if selectedIcon == imageName {
            cell.selectTerm(true)
        } else {
            cell.selectTerm(false)
        }
        cell.iconTapped = {[weak self] in
            if self?.selectedIcon != imageName {
                cell.selectTerm(true)
            } else {
                cell.selectTerm(false)
            }
            self?.handleIconTapped(indexPath: indexPath, name: imageName)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let iconCell = cell as? TermIconCell else {
            return
        }
        iconCell.selectTerm(false)
        
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let iconCell = cell as? TermIconCell, let imageName = iconCell.imageName else {
            return
        }
        
        if selectedIcon == imageName {
            iconCell.selectTerm(true)
        }
    }
}
