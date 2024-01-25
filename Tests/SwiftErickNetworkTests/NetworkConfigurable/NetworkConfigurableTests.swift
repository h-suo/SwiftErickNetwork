//
//  NetworkConfigurableTests.swift
//  
//
//  Created by Erick on 2024/01/24.
//

import XCTest
@testable import SwiftErickNetwork

class NetworkConfigurableTests: XCTestCase {
    
    func test_url() {
        // given
        let testConfig = StubEndPoint()
        let expectationURL = "https://example.com/api/data"
        
        do {
            // when
            let url = try testConfig.url()
            
            // then
            XCTAssertEqual(url.absoluteString, expectationURL)
        } catch {
            XCTFail("Failed to create URLRequest: \(error)")
        }
    }
    
    func test_urlRequest() {
        // given
        let testConfig = StubEndPoint()
        let expectationURL = "https://example.com/api/data"
        let expectationHTTPMethod = "GET"
        
        do {
            // when
            let urlRequest = try testConfig.urlRequest()
            
            // then
            XCTAssertEqual(urlRequest.url?.absoluteString, expectationURL)
            XCTAssertEqual(urlRequest.httpMethod, expectationHTTPMethod)
        } catch {
            XCTFail("Failed to create URLRequest: \(error)")
        }
    }
}
