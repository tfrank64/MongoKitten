//
//  DatabaseTests.swift
//  MongoKitten
//
//  Created by Joannis Orlandos on 21/04/16.
//
//

import XCTest
@testable import MongoKitten

class DatabaseTests: XCTestCase {
    static var allTests: [(String, (DatabaseTests) -> () throws -> Void)] {
        return [
                   ("testUsers", testUsers),
        ]
    }
    
    override func setUp() {
        super.setUp()
        
        try! TestManager.clean()
    }
    
    override func tearDown() {
       try! TestManager.disconnect()
    }
    
    func testUsers() throws {
        let roles: Document = [["role": "dbOwner", "db": TestManager.db.name] as Document]
        
        try TestManager.db.createUser("mongokitten-unittest-testuser", password: "hunter2", roles: roles, customData: ["testdata": false])
        
        guard let userInfo = try? TestManager.server.getUserInfo(forUserNamed: "mongokitten-unittest-testuser", inDatabase: TestManager.db), let testData = userInfo[0, "customData", "testdata"] as Bool? else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(testData, false)
        
        try TestManager.db.update(user: "mongokitten-unittest-testuser", password: "hunter2", roles: roles, customData: ["testdata": true])
        
        try TestManager.db.drop(user: "mongokitten-unittest-testuser")
    }
    
    func testMakeGridFS() throws {
        let gridFS = try TestManager.db.makeGridFS()
        
        let id = try gridFS.store(data: [0x05, 0x04, 0x01, 0x02, 0x03, 0x00])
        guard let file = try gridFS.findOne(byID: id) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(try file.read(), [0x05, 0x04, 0x01, 0x02, 0x03, 0x00])
        
        XCTAssertEqual(gridFS.chunks.name, "fs.chunks")
        XCTAssertEqual(gridFS.files.name, "fs.files")
    }
}
