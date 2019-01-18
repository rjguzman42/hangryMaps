//
//  DebugLog.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/6/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation

open class DebugLog {
    open class func DLog<T>(_ message:T, function: String = #function) {
        #if DEBUG
        if let text = message as? String {
            print("\(function): \(text)")
        }
        #endif
    }
}
