//
//  StarsView.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/12/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class StarsView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width =  Constants.Sizes.starCell.width
        let height = Constants.Sizes.starCell.height
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), collectionViewLayout: layout)
        cv.backgroundColor = Theme.Colors.reallyWhite.color
        cv.isPagingEnabled = false
        cv.bounces = false
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    var averageReview: Double = 0.0
    var totalReviewsCount: Int = 0
    var leftover: Double = 0.0
    let utility = AppUtility.sharedInstance
    
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
        
        //collectionView
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.register(StarCell.self, forCellWithReuseIdentifier: Constants.Cells.starCellId)
    }
    
    func addPlaceInfo() {
        computeLeftover()
        collectionView.reloadData()
    }
    
    func computeLeftover() {
        let avgReview = averageReview
        leftover = utility.getDecimalFromDouble(avgReview)
    }
    
    func reset() {
        averageReview = 0.0
        totalReviewsCount = 0
        leftover = 0.0
        collectionView.reloadData()
    }
    
    
    //MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.starCellId, for: indexPath) as! StarCell
        let avgReview = averageReview
        if indexPath.row + 1 <= Int(avgReview) {
            //highlight
            cell.starImageView.image = UIImage(named: "ic_star_full")?.withRenderingMode(.alwaysTemplate)
        } else if (indexPath.row + 1) == (Int(avgReview) + 1) && leftover > 0.0 {
            //highlight half star
            cell.starImageView.image = UIImage(named: "ic_star_half")?.withRenderingMode(.alwaysTemplate)
        } else {
            //don't highlight
            cell.starImageView.image = UIImage(named: "ic_star_empty")?.withRenderingMode(.alwaysTemplate)
        }
        cell.tintColor = Theme.Colors.primaryPurple.color
        return cell
    }
}
