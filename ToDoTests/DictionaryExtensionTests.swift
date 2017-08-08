//
//  DictionaryExtensionTests.swift
//  ToDo
//
//  Created by Lena on 8/8/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import XCTest
@testable import ToDo
class DictionaryExtensionTests: XCTestCase {

    
    func testExistingId(){
        let dict :[String:AnyObject] = ["id":1 as AnyObject]
        
        XCTAssertTrue(dict.getId() == 1)
    }
    
    func testNonExistingValues(){
        let dict :[String:AnyObject] = ["":"" as AnyObject]
        
        XCTAssertTrue(dict.getId() == 0)
        XCTAssertTrue(dict.getCompleted() == false)
        XCTAssertTrue(dict.getTitle() == "")
    }
    
    func testExistingCompletedTrue(){
        let dict :[String:AnyObject] = ["completed":true as AnyObject]
        
        XCTAssertTrue(dict.getCompleted())
    }
    
    func testExistingCompletedFalse(){
        let dict :[String:AnyObject] = ["completed":false as AnyObject]
        
        XCTAssertFalse(dict.getCompleted())
    }
    
    
    func testExistingTitle(){
        let dict :[String:AnyObject] = ["title":"title" as AnyObject]
        
        XCTAssertTrue(dict.getTitle() == "title")
    }
    
    
}
