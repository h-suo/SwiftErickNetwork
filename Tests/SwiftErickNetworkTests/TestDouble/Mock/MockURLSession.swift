//
//  MockURLSession.swift
//  
//
//  Created by Erick on 2024/01/24.
//

import Combine
import Foundation
import SwiftErickNetwork

class MockURLSession: URLSessionProtocol {
    
    var response: DummyResponse?
    var combineResponse: DummyCombineResponse?
    var asyncResponse: DummyAsyncResponse?
    
    init(
        response: DummyResponse? = nil,
        combineResponse: DummyCombineResponse? = nil,
        asyncResponse: DummyAsyncResponse? = nil
    ) {
        self.response = response
        self.combineResponse = combineResponse
        self.asyncResponse = asyncResponse
    }
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol {
        return MockURLSessionDataTask {
            let response = self.response
            completionHandler(response?.data, response?.response, response?.error)
        }
    }
    
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol {
        return MockURLSessionDataTask {
            let response = self.response
            completionHandler(response?.data, response?.response, response?.error)
        }
    }
    
    func responsePublisher(for request: URLRequest) -> AnyPublisher<Response, URLError> {
        return Just((data: combineResponse!.data, response: combineResponse!.response))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
    
    func responsePublisher(for url: URL) -> AnyPublisher<Response, URLError> {
        return Just((data: combineResponse!.data, response: combineResponse!.response))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
    
    func dataTask(with request: URLRequest) async throws -> (Data, URLResponse) {
        return (asyncResponse!.data, asyncResponse!.response)
    }
    
    func dataTask(with url: URL) async throws -> (Data, URLResponse) {
        return (asyncResponse!.data, asyncResponse!.response)
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    let resumeHandler: () -> Void
    
    init(resumeHandler: @escaping @Sendable () -> Void) {
        self.resumeHandler = resumeHandler
    }
    
    func resume() {
        resumeHandler()
    }
}
