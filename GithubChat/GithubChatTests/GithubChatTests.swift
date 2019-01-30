//
//  GithubChatTests.swift
//  GithubChatTests
//
//  Created by Neo on 2019/1/26.
//  Copyright © 2019 STH. All rights reserved.
//

import XCTest
@testable import GithubChat

class GithubChatTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParseUser() {
        do {
            if let jsonPath = Bundle(for: type(of: self)).path(forResource: "users", ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath))
                let users = try JSONDecoder().decode([User].self, from: data)
                XCTAssertEqual(users.count, 100)
            } else {

                XCTAssert(false, "Test file 'users.json' does not exist")
            }
        } catch let e {
            XCTAssert(false, "\(e)")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
