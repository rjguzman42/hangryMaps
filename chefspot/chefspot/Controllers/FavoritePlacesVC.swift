//
//  FavoritePlacesVC.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/11/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class FavoritePlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(backAction))
        return button
    }()
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: view.frame, style: .grouped)
        tv.backgroundColor = .white
        tv.bounces = false
        tv.separatorStyle = .none
        tv.separatorColor = .clear
        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.allowsSelection = false
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    let noDataView: NoDataView = {
        let view = NoDataView()
        view.mainImageView.image = UIImage(named: "ic_sheep")
        view.title.text = Constants.Strings.noFavoritePlaces
        view.isHidden = true
        return view
    }()
    let utility = AppUtility.sharedInstance
    let userManager = UserManager.sharedInstance
    let dataManager = DataManager.sharedInstance
    let libraryAPI = LibraryAPI.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        utility.hideStatusBar(false)
        title = Constants.Strings.favoritePlaces
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        title = Constants.Strings.favoritePlaces
        view.backgroundColor = Theme.Colors.reallyWhite.color
        
        //navigationBar
        navigationItem.leftBarButtonItem = backButton
        
        //tableView
        view.addSubview(tableView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
        tableView.register(PlaceTableCell.self, forCellReuseIdentifier: Constants.Cells.placeTableCellId)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.estimatedRowHeight = CGFloat(400)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.scrollsToTop = true
        
        //noDataView
        view.addSubview(noDataView)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: noDataView)
        view.addConstraintsWithFormat(format: "V:[v0]", views: noDataView)
        view.addConstraint(NSLayoutConstraint(item: noDataView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        
        checkIfDataAvailabel()
        addGestures()
    }
    
    func checkIfDataAvailabel() {
        if dataManager.favoritePlaces.count == 0 {
            noDataView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    
    //MARK: Actions
    
    func addGestures() {
        
    }
    
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func deleteFavoritePlaceForIndexPath(_ indexPath: IndexPath) {
        if dataManager.favoritePlaces.count - 1 >= indexPath.row {
            let place = dataManager.favoritePlaces[indexPath.row]
            dataManager.removeFavoritePlace(place)
            tableView.reloadData()
        }
    }
    
    func presentPlaceVC(place: GooglePlace) {
        let placeVC = PlaceVC()
        placeVC.place = place
        navigationController?.pushViewController(placeVC, animated: true)
    }
    
    //MARK: TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.favoritePlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getPlaceTableCell(indexPath)
    }
    
    func getPlaceTableCell(_ indexPath: IndexPath) -> PlaceTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.placeTableCellId) as! PlaceTableCell
        let currentPlace: GooglePlace = dataManager.favoritePlaces[indexPath.row]
        cell.addPlaceInfo(place: currentPlace)
        if let reference = currentPlace.photos?.first?.photoReference {
            libraryAPI.setPhotoFromReference(reference: reference, maxWidth: Int(Constants.Sizes.placeTableImageView.width), imageView: cell.placeImageView)
        }
        cell.cellTapped = {[weak self] in
            self?.presentPlaceVC(place: currentPlace)
        }
        return cell
    }
    
    
    //MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: Constants.Strings.delete, handler: { (action, view, handler) in
            self.deleteFavoritePlaceForIndexPath(indexPath)
        })
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
}
