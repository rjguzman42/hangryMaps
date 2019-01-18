//
//  PlaceVC.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/11/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class PlaceVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: view.frame, style: .grouped)
        tv.backgroundColor = .white
        tv.bounces = true
        tv.separatorStyle = .none
        tv.separatorColor = .clear
        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.allowsSelection = false
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    let placeHeaderView: PlaceHeaderView = {
        let view = PlaceHeaderView(frame: CGRect(x: 0, y: 0, width: Constants.Sizes.placeHeaderView.width, height: Constants.Sizes.placeHeaderView.height))
        return view
    }()
    lazy var orderFooterView: OrderFooterView = {
        let view = OrderFooterView(frame: CGRect(x:0, y: UIScreen.main.bounds.size.height, width: Constants.Sizes.orderFooterView.width, height: Constants.Sizes.orderFooterView.height))
        return view
    }()
    lazy var favButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(handleFavButtonTapped))
        let view = UIImageView()
        button.customView = UIImageView(image: UIImage(named: "ic_heart_empty"))
        button.customView?.isUserInteractionEnabled = true
        button.tintColor = Theme.Colors.reallyWhite.color
        return button
    }()
    var place: GooglePlace!
    var searchTermName: String = ""
    var isFavorite: Bool = false
    let dataManager = DataManager.sharedInstance
    let libraryAPI = LibraryAPI.sharedInstance
    let utility = AppUtility.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if place != nil {
            getPlaceDetails()
        }
        setupSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeBarStyle(willAppear: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        changeBarStyle(willAppear: false)
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        //navigationBar
        title = ""
        navigationItem.rightBarButtonItem = favButton
        
        //orderFooterView
        view.addSubview(orderFooterView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: orderFooterView)
        view.addConstraintsWithFormat(format: "V:[v0(\(Constants.Sizes.orderFooterView.height))]|", views: orderFooterView)
        
        //tableView
        view.addSubview(tableView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "V:|[v0]-0-[v1]", views: tableView, orderFooterView)
        tableView.contentInset = UIEdgeInsets(top: -Constants.Sizes.statusBarHeight - Constants.Sizes.navigationBarHeight, left: 0, bottom: 0, right: 0)
        tableView.register(PlaceDescriptionCell.self, forCellReuseIdentifier: Constants.Cells.placeDescriptionCellId)
        tableView.register(ReviewCell.self, forCellReuseIdentifier: Constants.Cells.reviewCellId)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.estimatedRowHeight = CGFloat(400)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.scrollsToTop = true
        
        view.bringSubview(toFront: orderFooterView)
        
        addGestures()
        checkForFavorite()
        addTableHeaderView()
        setupOrderFooterView()
    }
    
    func addTableHeaderView() {
        
        //remove previous headerViews
        if(tableView.tableHeaderView != nil) {
            tableView.tableHeaderView = nil
        }
        
        //add new headerView
        if let reference = place.photos?.first?.photoReference {
            libraryAPI.setPhotoFromReference(reference: reference, maxWidth: Int(placeHeaderView.placeImageView.frame.size.width), imageView: placeHeaderView.placeImageView)
            tableView.tableHeaderView = placeHeaderView
        }
    }
    
    func setupOrderFooterView() {
        orderFooterView.addPlaceInfo(place: place)
        orderFooterView.favButtonTapped = {[weak self] in
            self?.saveAsVisitedPlace()
            self?.openDirections()
        }
    }
    
    func changeBarStyle(willAppear: Bool) {
        if willAppear {
            UIApplication.shared.statusBarStyle = .lightContent
            navigationController?.navigationBar.tintColor = Theme.Colors.reallyWhite.color
            navigationController?.hidesBarsOnSwipe = true
        } else {
            UIApplication.shared.statusBarStyle = .default
            navigationController?.navigationBar.tintColor = Theme.Colors.primaryText.color
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    
    func checkForFavorite() {
        guard place != nil, place.isFavorite != nil else {
            return
        }
        isFavorite = place!.isFavorite!
        changeFavoriteButton()
    }
    
    func changeFavoriteButton() {
        let view = self.favButton.customView as! UIImageView
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [.curveEaseIn], animations: {
            if self.isFavorite {
                view.image = UIImage(named: "ic_heart_full")
            } else {
                view.image = UIImage(named: "ic_heart_empty")
            }
        }, completion: { (true) in
        })
    }
    
    
    //MARK: Content

    func getPlaceDetails() {
        if let placeid = place.placeId {
            dataManager.getPlaceDetails(placeid: placeid, completion: {[weak self] place in
                self?.place = place
                self?.refresh()
            })
        }
    }
    
    func refresh() {
        checkForFavorite()
        addTableHeaderView()
        setupOrderFooterView()
        tableView.reloadData()
    }
    
    func updateFavorite(add: Bool) {
        if add {
            dataManager.saveFavoritePlace(place, searchTermName: searchTermName)
        } else {
            dataManager.removeFavoritePlace(place, searchTermName: searchTermName)
        }
    }
    
    func saveAsVisitedPlace() {
        guard place != nil else {
            return
        }
        dataManager.saveVisitedPlace(place)
    }
    
    
    //MARK: Actions
    
    func addGestures() {
        let favTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFavButtonTapped))
        favButton.customView?.addGestureRecognizer(favTapGesture)
    }
    
    @objc func handleFavButtonTapped() {
        isFavorite = !isFavorite
        let view = self.favButton.customView as! UIImageView
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [.curveEaseIn], animations: {
            if self.isFavorite {
                view.image = UIImage(named: "ic_heart_full")
            } else {
                view.image = UIImage(named: "ic_heart_empty")
            }
        }, completion: { (true) in
            if self.isFavorite {
                self.updateFavorite(add: true)
            } else {
                self.updateFavorite(add: false)
            }
        })
    }
    
    func showContactPrompt() {
        let alert = UIAlertController(title: place.name ?? Constants.Strings.contact, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        if place.formattedPhoneNumber != nil {
            let numberAction = UIAlertAction(title: Constants.Strings.call, style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.callPlace()
            }
            alert.addAction(numberAction)
        }
        if place.website != nil {
            let visitAction = UIAlertAction(title: Constants.Strings.visitWebsite, style: .default) {
                UIAlertAction in
                self.visitePlace()
            }
             alert.addAction(visitAction)
        }
        let cancelAction = UIAlertAction(title: Constants.Strings.cancel, style: .cancel) {
            UIAlertAction in
        }
        alert.addAction(cancelAction)
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
            presenter.sourceRect = tableView.bounds
        }
        present(alert, animated: true, completion: nil)
    }
    
    func callPlace() {
        if let formattedNumber = place.formattedPhoneNumber {
            let number = utility.removeFormatFromNumber(formattedNumber)
            utility.callNumber(number)
        }
    }
    
    func visitePlace() {
        if let website = place.website, let url = URL(string: website) {
            utility.openURL(url)
        }
    }
    
    func openDirections() {
        if let latitude = place.geometry?.location?.lat, let longitude = place.geometry?.location?.lng {
            utility.sendUserToDirections(latitude: latitude, longitude: longitude, directionsName: place.name ?? "")
        }
    }
    
    
    //MARK: TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return place.reviews?.count ?? 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            return getReviewCell(indexPath: indexPath)
        }
        return getPlaceDescriptionCell(indexPath: indexPath)
    }
    
    func getPlaceDescriptionCell(indexPath: IndexPath) -> PlaceDescriptionCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.placeDescriptionCellId) as! PlaceDescriptionCell
        switch indexPath.section {
        case 0:
            break
        case 1:
            let description = "\(Constants.Strings.site): \(place.website ?? "")\n\(Constants.Strings.call): \(place.formattedPhoneNumber ?? "")"
            cell.descriptionLabel.text = description
            cell.descriptionLabel.isUserInteractionEnabled = true
            cell.labelTapped = {[weak self] in
                self?.showContactPrompt()
            }
            break
        default:
            break
        }
        return cell
    }
    
    func getReviewCell(indexPath: IndexPath) -> ReviewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.reviewCellId) as! ReviewCell
        if let currentReview = place.reviews?[indexPath.row] {
            cell.addReviewInfo(review: currentReview)
        }
        return cell
    }
    
    
    //MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TitleHeaderView()
        switch section {
        case 0:
            headerView.titleLabel.text = place.name ?? ""
            break
        case 1:
            headerView.titleLabel.text = Constants.Strings.contact
            break
        case 2:
            headerView.titleLabel.text = Constants.Strings.reviews
        default:
            break
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
