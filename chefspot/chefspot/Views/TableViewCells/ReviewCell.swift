//
//  ReviewCell.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/12/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class ReviewCell: UITableViewCell {
    
    let reviewView: ReviewView = {
        let view = ReviewView()
        return view
    }()
    var review: PlaceReview!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    deinit {
        DebugLog.DLog("Setting Cell Deinited")
    }
    
    func reset() {
        reviewView.descriptionLabel.text = ""
        reviewView.profileImageView.image = nil
        reviewView.taglineLabel.text = ""
        reviewView.lineView.isHidden = true
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        
        //reviewView
        addSubview(reviewView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: reviewView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: reviewView)
    }
    
    func addReviewInfo(review: PlaceReview) {
        self.review = review
        reviewView.addReviewInfo(review: review)
    }
}
