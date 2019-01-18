//
//  ReviewView.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/12/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation

class ReviewView: UIView {
    
    let profileImageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.Sizes.profileImageSmall.width, height: Constants.Sizes.profileImageSmall.height))
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.Sizes.profileImageSmall.width / 2
        view.backgroundColor = Theme.Colors.backgroundBlack.color
        view.contentMode = .scaleAspectFill
        return view
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = Theme.Fonts.primaryMedium.font
        label.textColor = Theme.Colors.primaryText.color
        label.numberOfLines = 0
        return label
    }()
    let starsView: StarsView = {
        let view = StarsView(frame: CGRect(x: 0, y: 0, width: Constants.Sizes.starsView.width, height: Constants.Sizes.starsView.height))
        return view
    }()
    let taglineLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Theme.Fonts.primarySmall.font
        label.textColor = Theme.Colors.primaryText.color
        label.numberOfLines = 1
        label.contentMode = .left
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    let lineView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Constants.Sizes.lineView.width, height: Constants.Sizes.lineView.height))
        view.isHidden = true
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    var review: PlaceReview!
    let utility = AppUtility.sharedInstance
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        if review != nil {
            addReviewInfo(review: review)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        DebugLog.DLog("Setting Cell Deinited")
    }
    
    func reset() {
        descriptionLabel.text = ""
        profileImageView.image = nil
        taglineLabel.text = ""
        lineView.isHidden = true
        starsView.reset()
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        
        //lineView
        addSubview(lineView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: lineView)
        addConstraintsWithFormat(format: "V:|[v0(\(Constants.Sizes.lineView.height))]", views: lineView)
        
        //profileImageView
        addSubview(profileImageView)
        addConstraintsWithFormat(format: "H:[v0(\(Constants.Sizes.profileImageSmall.width))]-10-|", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(\(Constants.Sizes.profileImageSmall.height))]", views: profileImageView)
        
        //starsView
        addSubview(starsView)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-[v1]", views: starsView, profileImageView)
        addConstraintsWithFormat(format: "V:[v1]-10-[v0(\(Constants.Sizes.starsView.height))]", views: starsView, lineView)
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .top, relatedBy: .equal, toItem: starsView, attribute: .top, multiplier: 1, constant: 0))

        //descriptionLabel
        addSubview(descriptionLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-[v1]", views: descriptionLabel, profileImageView)
        addConstraintsWithFormat(format: "V:[v1]-10-[v0]-20-|", views: descriptionLabel, starsView)
        
    }
    
    func addReviewInfo(review: PlaceReview) {
        self.review = review
        if let reviewText = review.text {
            descriptionLabel.text = reviewText
        }
        if let profileImagePath = review.profilePhotoUrl {
            profileImageView.sd_setImage(with: URL(string: profileImagePath), placeholderImage: nil, options: [.continueInBackground])
        }
        if let rating = review.rating {
            starsView.averageReview = rating
            starsView.addPlaceInfo()
        }
    }
}
