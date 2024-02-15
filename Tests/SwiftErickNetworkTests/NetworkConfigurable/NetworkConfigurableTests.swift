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
        let expectationURL = "https://example.com/api/data"
        let expectationHTTPMethod = "GET"
        let expectationHTTPHeader = ["Test": "Test"]
        let expectationHTTPBody = DummyDTO(id: 0, title: "Test")
        let testConfig = StubEndPoint(
            httpMethod: .get,
            httpHeaderFields: expectationHTTPHeader,
            httpBody: expectationHTTPBody
        )
        
        do {
            // when
            let urlRequest = try testConfig.urlRequest()
            let httpBody = try JSONDecoder().decode(DummyDTO.self, from: urlRequest.httpBody!)
            
            // then
            XCTAssertEqual(urlRequest.url?.absoluteString, expectationURL)
            XCTAssertEqual(urlRequest.httpMethod, expectationHTTPMethod)
            XCTAssertEqual(urlRequest.allHTTPHeaderFields, expectationHTTPHeader)
            XCTAssertEqual(httpBody, expectationHTTPBody)
        } catch {
            XCTFail("Failed to create URLRequest: \(error)")
        }
    }
}
