//
//  URLSessionProtocol.swift
//  
//
//  Created by Erick on 2024/01/24.
//

import Combine
import Foundation

public protocol URLSessionProtocol {
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol
    
    typealias Response = URLSession.DataTaskPublisher.Output
    
    func responsePublisher(for request: URLRequest) -> AnyPublisher<Response, URLError>
    func responsePublisher(for url: URL) -> AnyPublisher<Response, URLError>
    
    func dataTask(with request: URLRequest) async throws -> (Data, URLResponse)
    func dataTask(with url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    
    public func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
    
    public func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
    
    public func responsePublisher(for request: URLRequest) -> AnyPublisher<Response, URLError> {
        return dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
    
    public func responsePublisher(for url: URL) -> AnyPublisher<Response, URLError> {
        return dataTaskPublisher(for: url).eraseToAnyPublisher()
    }
    
    public func dataTask(with request: URLRequest) async throws -> (Data, URLResponse) {
        return try await data(for: request)
    }
    
    public func dataTask(with url: URL) async throws -> (Data, URLResponse) {
        return try await data(from: url)
    }
}
