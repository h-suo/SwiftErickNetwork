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
    var method: SwiftErickNetwork.HttpMethod
    var queryParameters: [URLQueryItem]?
    
    init(
        baseURL: String = "https://example.com",
        path: String = "/api/data",
        method: SwiftErickNetwork.HttpMethod = .get,
        queryParameters: [URLQueryItem]? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
    }
}
