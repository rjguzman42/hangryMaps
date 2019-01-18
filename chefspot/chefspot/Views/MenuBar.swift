//
//  MenuBar.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/9/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Theme.Colors.navBar.color
        cv.isScrollEnabled = true
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    let darkView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    let dataManager = DataManager.sharedInstance
    let utility = AppUtility.sharedInstance
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
    
   //MARK: UI
    
    func setupSubViews() {
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: Constants.Cells.menuCellId)
        
        addSubview(darkView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: darkView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: darkView)
        
        //initial menuBar Item selected at launch
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
        
        //remove scrollbar
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func scrollToMenuIndex(menuIndex: Int, animated: Bool) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }
    
    
    //MARK: Content
    
    func handleNewSearchTerm(_ term: String?) {
        collectionView.reloadData()
        scrollToMenuIndex(menuIndex: 0, animated: false)
    }
    
    //MARK: CollectionView Delegate-Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.savedSearchTerms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.menuCellId, for: indexPath) as! MenuCell
        cell.title.text = dataManager.savedSearchTerms[indexPath.item].name ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionWord = dataManager.savedSearchTerms[indexPath.row].name ?? ""
        return utility.getSizeToFitString(text: sectionWord, font: Theme.Fonts.menuBarTitle.font)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let foodFilterView = superview as? FoodFilterView {
            foodFilterView.placeScrollView.autoScrollEnabled = false
            foodFilterView.placeScrollView.scrollToSection(section: indexPath.item, animated: true)
            scrollToMenuIndex(menuIndex: indexPath.item, animated: true)
        }
    }
    
}

//MARK: MenuCell

class MenuCell: UICollectionViewCell {
    
    let title: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = Theme.Colors.hintGray.color
        label.font = Theme.Fonts.menuBarTitle.font
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            title.textColor = isHighlighted ? Theme.Colors.primaryText.color : Theme.Colors.hintGray.color
            title.font = isHighlighted ? Theme.Fonts.menuBarTitle.font : Theme.Fonts.menuBarTitle.font
        }
    }
    
    override var isSelected: Bool {
        didSet {
            title.textColor = isSelected ? Theme.Colors.primaryText.color : Theme.Colors.hintGray.color
            title.font = isSelected ? Theme.Fonts.menuBarTitle.font : Theme.Fonts.menuBarTitle.font
        }
    }
    
    override func prepareForReuse() {
        title.textColor = isHighlighted ? Theme.Colors.primaryText.color : Theme.Colors.hintGray.color
        title.font = isHighlighted ? Theme.Fonts.menuBarTitle.font : Theme.Fonts.menuBarTitle.font
    }
    
    
    //MARK: UI
    
    func setupViews() {
        addSubview(title)
        addConstraintsWithFormat(format: "H:|[v0]|", views: title)
        addConstraintsWithFormat(format: "V:|[v0]|", views: title)
        addConstraint(NSLayoutConstraint(item: title, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: title, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
}
