//
//  NetworkManageableTests.swift
//  
//
//  Created by Erick on 2024/01/24.
//

import XCTest
@testable import SwiftErickNetwork

class NetworkManageableTests: XCTestCase {
    
    // MARK: - SUT
    private var networkManager: NetworkManager!
    
    // MARK: - Success Cases
    func test_success_request_with_url() {
        // given
        let expectation = XCTestExpectation(description: "success request with url")
        var resultData: Data?
        
        networkManager = NetworkManager(urlSession: MockURLSession(response: SuccessResponse()))
        
        // when
        networkManager.request(with: URL(string: "success")!) { result in
            switch result {
            case .success(let data):
                resultData = data
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        // then
        wait(for: [expectation], timeout: 0.5)
        XCTAssertNotNil(resultData)
    }
    
    func test_success_request_with_EndPoint() {
        // given
        let expectation = XCTestExpectation(description: "success request with EndPoint")
        var resultData: DummyDTO?
        
        let endPoint = StubEndPoint()
        networkManager = NetworkManager(urlSession: MockURLSession(response: SuccessResponse()))
        
        // when
        networkManager.request(with: endPoint) { result in
            switch result {
            case .success(let string):
                resultData = string
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        // then
        wait(for: [expectation], timeout: 0.5)
        XCTAssertNotNil(resultData)
    }
    
    func test_success_requestPublisher_with_url() {
        // given
        let expectation = XCTestExpectation(description: "success requestPublisher with url")
        var resultData: Data?
        
        networkManager = NetworkManager(
            urlSession: MockURLSession(
                combineResponse: SuccessCombineResponse()
            )
        )
        
        // when
        let _ = networkManager.requestPublisher(with: URL(string: "success")!)
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail(error.localizedDescription)
                }
            } receiveValue: { data in
                resultData = data
                expectation.fulfill()
            }
        
        // then
        wait(for: [expectation], timeout: 0.5)
        XCTAssertNotNil(resultData)
    }
    
    func test_success_requestPublisher_with_EndPoint() {
        // given
        let expectation = XCTestExpectation(description: "success requestPublisher with EndPoint")
        var resultData: DummyDTO?
        
        let endPoint = StubEndPoint()
        networkManager = NetworkManager(
            urlSession: MockURLSession(
                combineResponse: SuccessCombineResponse()
            )
        )
        
        // when
        let _ = networkManager.requestPublisher(with: endPoint)
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail(error.localizedDescription)
                }
            } receiveValue: { dto in
                resultData = dto
                expectation.fulfill()
            }
        
        // then
        wait(for: [expectation], timeout: 0.5)
        XCTAssertNotNil(resultData)
    }
    
    func test_success_async_request_with_url() async {
        // given
        let expectation = XCTestExpectation(description: "success async request with url")

        networkManager = NetworkManager(
            urlSession: MockURLSession(
                asyncResponse: SuccessAsyncResponse()
            )
        )

        // when
        let result = await networkManager.request(with: URL(string: "success")!)
        
        switch result {
        case let .success(data):
            // then
            expectation.fulfill()
            XCTAssertNotNil(data)
        case let .failure(error):
            XCTFail(error.localizedDescription)
        }
        
        await fulfillment(of: [expectation], timeout: 0.5)
    }
    
    func test_success_async_request_with_EndPoint() async {
        // given
        let expectation = XCTestExpectation(description: "success async request with EndPoint")
        
        let endPoint = StubEndPoint()
        networkManager = NetworkManager(
            urlSession: MockURLSession(
                asyncResponse: SuccessAsyncResponse()
            )
        )
        
        // when
        let result = await networkManager.request(with: endPoint)

        switch result {
        case let .success(data):
            // then
            expectation.fulfill()
            XCTAssertNotNil(data)
        case let .failure(error):
            XCTFail(error.localizedDescription)
        }
        
        await fulfillment(of: [expectation], timeout: 0.5)
    }
    
    // MARK: - Failde Test Cases
    func test_failure_invalidURL() {
        testFailure(
            description: "Failed with dataTask Error",
            failResponse: DataTaskResponse(),
            networkError: NetworkError.dataTask(NetworkError.invalidURL)
        )
    }
    
    func test_failure_invalidResponse() {
        testFailure(
            description: "Failed with invalidResponse Error",
            failResponse: InvalidResponse(),
            networkError: NetworkError.invalidResponse
        )
    }
    
    func test_failure_statusCodeOutOfRange() {
        testFailure(
            description: "Failed with statusCodeOutOfRange Error",
            failResponse: StatusCodeOutOfRangeResponse(),
            networkError: NetworkError.statusCodeOutOfRange
        )
    }
    
    func test_failure_emptyData() {
        testFailure(
            description: "Failed with emptyData Error",
            failResponse: EmptyDataResponse(),
            networkError: NetworkError.emptyData
        )
    }
    
    func test_failure_invalidResponse_with_combine() {
        testFailureWithCombine(
            description: "Failed with invalidResponse Error",
            failResponse: InvalidCombineResponse(),
            networkError: NetworkError.invalidResponse
        )
    }
    
    func test_failure_statusCodeOutOfRange_with_combine() {
        testFailureWithCombine(
            description: "Failed with invalidResponse Error",
            failResponse: StatusCodeOutOfRangeCombineResponse(),
            networkError: NetworkError.statusCodeOutOfRange
        )
    }
    
    func test_failure_invalidResponse_with_concurrency() async {
        await testFailureWithConcurrency(
            description: "Failed with invalidResponse Error",
            failResponse: InvalidAsyncResponse(),
            networkError: NetworkError.invalidResponse
        )
    }
    
    func test_failure_statusCodeOutOfRange_with_concurrency() async {
        await testFailureWithConcurrency(
            description: "Failed with invalidResponse Error",
            failResponse: StatusCodeOutOfRangeAsyncResponse(),
            networkError: NetworkError.statusCodeOutOfRange
        )
    }
    
    // MARK: - Failure Testing Funtion
    private func testFailure(
        description: String,
        failResponse: DummyResponse,
        networkError: NetworkError
    ) {
        // given
        let expectation = XCTestExpectation(description: description)
        var resultError: NetworkError?
        
        let endPoint = StubEndPoint()
        networkManager = NetworkManager(urlSession: MockURLSession(response: failResponse))
        
        // when
        networkManager.request(with: endPoint) { result in
            switch result {
            case .success(_):
                XCTFail("Failed test failed.")
            case .failure(let error):
                resultError = error
                expectation.fulfill()
            }
        }
        
        // then
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(resultError, networkError)
    }
    
    private func testFailureWithCombine(
        description: String,
        failResponse: DummyCombineResponse,
        networkError: NetworkError
    ) {
        // given
        let expectation = XCTestExpectation(description: description)
        var resultError: NetworkError?
        
        let endPoint = StubEndPoint()
        networkManager = NetworkManager(urlSession: MockURLSession(combineResponse: failResponse))
        
        // when
        let _ = networkManager.requestPublisher(with: endPoint)
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("Failed test failed.")
                case .failure(let error):
                    resultError = error
                    expectation.fulfill()
                }
            } receiveValue: { _ in
                XCTFail("Failed test failed.")
            }
        
        // then
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(resultError, networkError)
    }
    
    private func testFailureWithConcurrency(
        description: String,
        failResponse: DummyAsyncResponse,
        networkError: NetworkError
    ) async {
        // given
        let expectation = XCTestExpectation(description: description)
        let endPoint = StubEndPoint()
        networkManager = NetworkManager(urlSession: MockURLSession(asyncResponse: failResponse))
        
        // when
        let result = await networkManager.request(with: endPoint)

        switch result {
        case .success(_):
            // then
            XCTFail("Failed test failed.")
        case let .failure(error):
            // then
            expectation.fulfill()
            XCTAssertEqual(error, networkError)
        }
        
        await fulfillment(of: [expectation], timeout: 0.5)
    }
}
