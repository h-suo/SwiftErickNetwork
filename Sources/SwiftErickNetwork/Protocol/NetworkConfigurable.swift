//
//  NetworkConfigurable.swift
//  
//
//  Created by Erick on 2024/01/24.
//

import Foundation

public protocol NetworkConfigurable {
    
    associatedtype Response
    
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var queryParameters: [URLQueryItem]? { get }
}

extension NetworkConfigurable {
    
    public func urlRequest() throws -> URLRequest {
        let url = try url()
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
    
    public func url() throws -> URL {
        let fullPath = String(
            format: "%@%@",
            baseURL,
            path
        )
        
        guard var urlComponents = URLComponents(string: fullPath),
              let url = URL(string: fullPath)
        else { throw NetworkError.invalidURL }
        
        guard let queryParameters
        else { return url }
        
        urlComponents.queryItems = queryParameters
        
        guard let url = urlComponents.url
        else { throw NetworkError.invalidComponents }
        
        return url
    }
}
