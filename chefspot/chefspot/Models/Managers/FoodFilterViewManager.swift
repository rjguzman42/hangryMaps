//
//  FoodFilterViewManager.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/9/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class FoodFilterViewManager: NSObject {
    
    lazy var foodFilterView: FoodFilterView = {
        let view = FoodFilterView(frame: CGRect(x: UIScreen.main.bounds.origin.x, y: minimizeOrigin, width: Constants.Sizes.foodFilterView.width, height: Constants.Sizes.foodFilterView.height))
        return view
    }()
    let maxOrigin: CGFloat = 0
    let previewOrigin: CGFloat = UIScreen.main.bounds.size.height - Constants.Sizes.foodFilterViewPreview.height
    lazy var previewOriginExtra: CGFloat = self.previewOrigin + 100
    let minimizeOrigin: CGFloat = UIScreen.main.bounds.size.height - Constants.Sizes.foodFilterViewMinimized.height
    var vc: UIViewController!
    var attachedViews: [UIView] = []
    var subviewAdded: Bool = false
    let utility = AppUtility.sharedInstance
    var placeCellTapped: ((_ place: GooglePlace) -> Void)?
    var loadPlaceCellTapped: ((_ searchTerm: String) -> Void)?
    
    override init() {
        super.init()
        checkForSubView()
    }
    
    
    //MARK: UI
    
    func checkForSubView() {
        if !subviewAdded {
            if let controller = vc {
                controller.view.addSubview(foodFilterView)
                subviewAdded = true
                addGestures()
            }
        }
    }
    
    
    //MARK: Content
    
    func getCurrentMenuBarTitle() -> String {
        var title = ""
        for cell in foodFilterView.menuBar.collectionView.visibleCells as! [MenuCell] {
            if cell.isSelected {
                if let searchTerm = cell.title.text {
                    title = searchTerm
                    break
                }
            }
        }
        return title
    }
    
    func handleNewSearchTerm(_ term: String?) {
        foodFilterView.menuBar.handleNewSearchTerm(term)
        foodFilterView.placeScrollView.handleNewSearchTerm(term)
    }
    
    
    //MARK: Actions
    
    func addGestures() {
        
        //foodFilterView
        foodFilterView.isUserInteractionEnabled = true
        let dismissPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
        foodFilterView.addGestureRecognizer(dismissPanGesture)
        
        foodFilterView.placeCellTapped = { [weak self] place in
            if self?.placeCellTapped != nil {
                self?.placeCellTapped!(place)
            }
        }
        foodFilterView.loadPlaceCellTapped = { [weak self] searchTerm in
            if self?.loadPlaceCellTapped != nil {
                self?.loadPlaceCellTapped!(searchTerm)
            }
        }
        
    }
    
    func show(origin: CGFloat = (UIScreen.main.bounds.size.height / 2) + 100) {
        checkForSubView()
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [.curveEaseIn], animations: {
            for attachedView in self.attachedViews {
                attachedView.frame.origin.y = origin - attachedView.frame.size.height - 10
            }
            self.foodFilterView.frame.origin.y = origin
            if origin == self.maxOrigin {
                self.utility.hideStatusBar(true)
            }
        }, completion: { (true) in
            
        })
    }
    
    func minimize() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [.curveEaseIn], animations: {
            for attachedView in self.attachedViews {
                attachedView.frame.origin.y = self.minimizeOrigin - attachedView.frame.size.height - 10
            }
            self.foodFilterView.frame.origin.y = self.minimizeOrigin
        }, completion: { (true) in
            
        })
    }
    
    @objc func draggedView(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: foodFilterView)
        if sender.state == UIGestureRecognizerState.began {
            
        } else if sender.state == UIGestureRecognizerState.ended {
            if self.foodFilterView.frame.origin.y > previewOriginExtra {
                //minimize
                self.minimize()
            } else if self.foodFilterView.frame.origin.y > previewOrigin {
                //preview
                self.show(origin: self.previewOrigin)
            } else {
                let draggingDown: Bool = sender.velocity(in: foodFilterView).y > 0
                if draggingDown {
                    //preview
                    self.show(origin: self.previewOrigin)
                } else {
                    //show maxView
                    self.show(origin: self.maxOrigin)
                }
            }
            
           
            sender.setTranslation(CGPoint.zero, in: self.foodFilterView)
            return
        } else if sender.state == UIGestureRecognizerState.changed {
            let lessThanMaxX = (self.foodFilterView.frame.origin.y + translation.y) <= minimizeOrigin
            let greaterThanWindowOrigin = self.foodFilterView.frame.origin.y > UIScreen.main.bounds.origin.y
            let equalToWindowOrigin = self.foodFilterView.frame.origin.y == UIScreen.main.bounds.origin.y
            let draggingDown: Bool = translation.y > 0
            if ((lessThanMaxX && greaterThanWindowOrigin) || (equalToWindowOrigin && draggingDown)) {
                //set center of view to new dragged point
                self.foodFilterView.center = CGPoint(x: self.foodFilterView.center.x, y: self.foodFilterView.center.y + translation.y)
                for attachedView in self.attachedViews {
                    attachedView.center = CGPoint(x: attachedView.center.x, y: attachedView.center.y + translation.y)
                }
            } 
            sender.setTranslation(CGPoint.zero, in: self.foodFilterView)
        }
    }
    
}
