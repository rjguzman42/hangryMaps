//
//  UIResponder+Extension.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/18/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        return (self.next as? UIViewController) ?? self.next?.parentViewController
    }
}
