//
//  AppUtilityTests.swift
//  hangryMapsTests
//
//  Created by Roberto Guzman on 8/2/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import XCTest
@testable import Hangry_Maps

class AppUtilityTests: XCTestCase {
    let utility = AppUtility.sharedInstance
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    //MARK: System
    
    func testSetOrientation() {
        let orientationMask = UIInterfaceOrientationMask.portrait
        AppUtility.lockOrientation(orientationMask)
        XCTAssertEqual(UIDevice.current.orientation.isPortrait, true, TestConstants.Failed.setOrientation)
    }
    
    func testHideStatusBar() {
        utility.hideStatusBar(true)
        if let keyWindow = UIApplication.shared.keyWindow {
            XCTAssertEqual(keyWindow.windowLevel, UIWindowLevelStatusBar + 1, "")
        }
        
        utility.hideStatusBar(false)
        if let keyWindow = UIApplication.shared.keyWindow {
            XCTAssertEqual(keyWindow.windowLevel, UIWindowLevelStatusBar - 1, "")
        }
    }
    
    func testGetDecimalFromDouble() {
        let doubleReturned = utility.getDecimalFromDouble(12.59)
        XCTAssertEqual(doubleReturned, 0.6, "")
        
        let doubleReturnedTwo = utility.getDecimalFromDouble(12.5)
        XCTAssertEqual(doubleReturnedTwo, 0.5, "")
    }
    
}
