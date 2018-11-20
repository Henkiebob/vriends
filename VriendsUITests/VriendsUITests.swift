//
//  VriendsUITests.swift
//  VriendsUITests
//
//  Created by Tjerk Dijkstra on 20/11/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import XCTest

class VriendsUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        snapshot("01LoginScreen")

        let app = XCUIApplication()
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"Bruce").element.press(forDuration: 1.0);
        
        let friendProfileNavigationBar = app.navigationBars["Friend profile"]
        friendProfileNavigationBar.buttons["Edit"].tap()
        app.navigationBars["Edit Friend"].buttons["Friend profile"].tap()
            
        snapshot("02Vriendscreen")
        friendProfileNavigationBar.buttons["back button"].tap()
        app.navigationBars["Vriends"].buttons["?"].tap()
        app.otherElements["Page1"].swipeLeft()
        
        let textView = app.otherElements["Page2"].children(matching: .textView).element
        textView.swipeLeft()
        textView.swipeLeft()
        textView.swipeLeft()
        
        snapshot("03Offline")

    }

}
