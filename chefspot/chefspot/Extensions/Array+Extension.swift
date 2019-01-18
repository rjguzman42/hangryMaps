//
//  Array+Extension.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/16/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func removeObject<U: AnyObject>(_ object: U) -> Element? {
        if count > 0 {
            for index in startIndex ..< endIndex {
                if (self[index] as! U) === object { return self.remove(at: index) }
            }
        }
        return nil
    }
}

extension Array where Iterator.Element : AnyObject {
    public func containsExactObject(_ object: Array.Iterator.Element) -> Bool {
        return self.contains( where: { $0 === object } )
    }
}
