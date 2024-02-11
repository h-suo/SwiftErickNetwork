//
//  StubEndPoint.swift
//  
//
//  Created by Erick on 2024/01/24.
//

import Foundation
import SwiftErickNetwork

struct StubEndPoint: NetworkConfigurable {
    typealias Response = DummyDTO
    
    var baseURL: String
    var path: String
    var httpMethod: HttpMethod
    var queryParameters: [URLQueryItem]?
    var httpHeaderFields: [String : String]?
    var httpBody: Encodable?
    
    init(
        baseURL: String = "https://example.com",
        path: String = "/api/data",
        httpMethod: HttpMethod = .get,
        queryParameters: [URLQueryItem]? = nil,
        httpHeaderFields: [String: String]? = nil,
        httpBody: Encodable? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.httpMethod = httpMethod
        self.queryParameters = queryParameters
        self.httpHeaderFields = httpHeaderFields
        self.httpBody = httpBody
    }
}
