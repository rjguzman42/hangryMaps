//
//  PlaceScrollView.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/10/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class PlaceScrollView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width =  Constants.Sizes.placeCell.width
        let height =  Constants.Sizes.placeCell.height
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Theme.Colors.reallyWhite.color
        cv.isPagingEnabled = false
        cv.bounces = false
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    let utility = AppUtility.sharedInstance
    let dataManager = DataManager.sharedInstance
    let libraryAPI = LibraryAPI.sharedInstance
    var currentMenuBarIndex: Int = 0
    var autoScrollEnabled: Bool = true
    var placeCellTapped: ((_ place: GooglePlace) -> Void)?
    var loadPlaceCellTapped: ((_ searchTerm: String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        scrollToSection(section: 0, animated: false)
        scrollMenuBar(index: 0)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        
        //collectionView
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.register(PlaceCell.self, forCellWithReuseIdentifier: Constants.Cells.placeCellId)
        collectionView.register(LoadingCollectionCell.self, forCellWithReuseIdentifier: Constants.Cells.loadingCollectionCellId)
    }
    
    func scrollToSection(section: Int, animated: Bool) {
        let indexPath = IndexPath(item: 0, section: section)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: animated)
    }
    
    func scrollMenuBar(index: Int) {
        if let foodFilterView = superview as? FoodFilterView {
            foodFilterView.menuBar.scrollToMenuIndex(menuIndex: index, animated: true)
        }
    }
    
    func scrollToVisibleSection(animated: Bool) {
        if let visibleSection = collectionView.indexPathsForVisibleItems.first?.section  {
            scrollToSection(section: visibleSection, animated: animated)
        }
    }
    
    
    //MARK: Content
    
    func handleNewSearchTerm(_ term: String?) {
        collectionView.reloadData()
        scrollToSection(section: 0, animated: false)
    }
    
    
    //MARK: Actions
    
    func presentPlaceVC(place: GooglePlace) {
        if placeCellTapped != nil {
            placeCellTapped!(place)
        }
    }
    
    
    //MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataManager.savedSearchTerms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionName = dataManager.savedSearchTerms[section].name ?? ""
        let itemCount = dataManager.localPlaces[sectionName]?.count ?? 1
        
        //loaded, but there are no places nearby
        if itemCount == 0 {
            return 1
        }
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionName = dataManager.savedSearchTerms[indexPath.section].name ?? ""
        let itemCount = dataManager.localPlaces[sectionName]?.count ?? -1
        if itemCount == -1 {
            //not yet loaded for term
            return getLoadingCollectionCell(indexPath, noData: false)
        } else if itemCount == 0 {
             //loaded, but there are no places nearby
            return getLoadingCollectionCell(indexPath, noData: true)
        }
        return getPlaceCell(indexPath)
    }
    
    func getLoadingCollectionCell(_ indexPath: IndexPath, noData: Bool) -> LoadingCollectionCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.loadingCollectionCellId, for: indexPath) as! LoadingCollectionCell
        
        let sectionName = dataManager.savedSearchTerms[indexPath.section].name ?? ""
        cell.title.text = sectionName
        if noData {
            cell.title.text = "\(Constants.Strings.noDataForPlace) \(sectionName)"
        }
        if let imageName = dataManager.savedSearchTerms[indexPath.section].imageName {
            let size = Constants.Strings.foodItemSizeLarge
            let sizedName = size + imageName
            cell.loadImageView.image = UIImage(named: sizedName)
        } else {
            //set default image
            cell.loadImageView.image = UIImage(named: "small_ic_utensil")
        }
        cell.cellTapped = {[weak self] in
            if self?.loadPlaceCellTapped != nil {
                self?.loadPlaceCellTapped!(sectionName)
            }
        }
        return cell
    }
    
    func getPlaceCell(_ indexPath: IndexPath) -> PlaceCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.placeCellId, for: indexPath) as! PlaceCell
        let sectionName = dataManager.savedSearchTerms[indexPath.section].name ?? ""
        let currentPlace: GooglePlace = dataManager.localPlaces[sectionName]?[indexPath.row] ?? GooglePlace()
        cell.addPlaceInfo(place: currentPlace)
        if let reference = currentPlace.photos?.first?.photoReference {
            libraryAPI.setPhotoFromReference(reference: reference, maxWidth: Int(Constants.Sizes.placeCell.width + 100), imageView: cell.placeImageView)
        }
        cell.cellTapped = { [weak self] in
            self?.presentPlaceVC(place: currentPlace)
        }
        return cell
    }
    
    
    //MARK: ScrollView
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //detect when next section enters halfway point of collectionView. If so, we change menuBar item
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint)
        if visibleIndexPath != nil && visibleIndexPath?.section != currentMenuBarIndex && autoScrollEnabled {
            currentMenuBarIndex = visibleIndexPath!.section
            scrollMenuBar(index: visibleIndexPath!.section)
        }
        switch scrollView.panGestureRecognizer.state {
        case .began:
            // User began dragging
            autoScrollEnabled = true
            break
        case .changed:
            // User is currently dragging the scroll view
            break
        case .possible:
            // The scroll view scrolling but the user is no longer touching the scrollview (table is decelerating)
            break
        case .ended:
            break
        default:
            break
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        autoScrollEnabled = false
    }
}
