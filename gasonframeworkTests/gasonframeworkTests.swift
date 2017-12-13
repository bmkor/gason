//
//  gasonframeworkTests.swift
//  gasonframeworkTests
//
//  Created by Benjamin on 2/12/2017.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import XCTest
@testable import gasonframework

class gasonframeworkTests: XCTestCase {
    
    var d:[Data]?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // This may take a bit time to download.
        
        let emptyJSON = "{}"
        if let data = emptyJSON.data(using: String.Encoding.utf8){
            d = [data]
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    func testPerformanceBaseline(){
        guard let d = d else {return}
        self.measure {
            d.forEach({ (data) in
                do{
                    _ = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                }catch let e as NSError{
                    print("error: \(e.localizedDescription)")
                }
                
            })
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        guard let d = d else {return}
        
        self.measure {
            // Put the code you want to measure the time of here.
            d.forEach({ (data) in
                do{                    
                    _ = try JSON(data)
                }catch let e as NSError{
                    print("error: \(e.localizedDescription)")
                }
            })
        }
    }
    var g:[String:NSObject]?
    var crashed:[URL]?
    func testCrashed(){
        if let url = Bundle(for:type(of: self)).url(forResource: "jsonlist", withExtension: "json"), let casepaths = try? Data(contentsOf: url){
            g = try? JSONSerialization.jsonObject(with: casepaths, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:NSObject]
            if let site = g?["site"] as? String{
                crashed = (g?["crashed"] as? [String])?.map({site + $0}).flatMap({URL(string:$0)})
            }
        }
        
        var expectations:[XCTestExpectation] = []
        var dataTasks:[URLSessionDataTask] = []
        
        XCTAssertNotNil(crashed)
        crashed?.forEach({ (url) in
            let expectation = self.expectation(description: url.absoluteString)
            let dt = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, _) in
                if let data = data{
                    do {
                        
                        _ = try JSON(data)
                    }catch let e as NSError{
                        print("error: \(e.localizedDescription)")
                    }
                    expectation.fulfill()
                }
            })
            expectations.append(expectation)
            dataTasks.append(dt)
        })
        dataTasks.forEach({$0.resume()})
        self.wait(for: expectations, timeout: 1000)
    }

    
    
}
