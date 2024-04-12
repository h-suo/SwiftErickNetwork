//
//  DummyResponse.swift
//  
//
//  Created by Erick on 2024/01/24.
//

import Foundation
import SwiftErickNetwork

protocol DummyResponse {
    var data: Data? { get }
    var response: URLResponse? { get }
    var error: Error? { get }
}

struct SuccessResponse: DummyResponse {
    var data: Data? = """
                      {
                         "id": 25,
                         "title": "Erick"
                      }
                      """.data(using: .utf8)!
    var response: URLResponse? = HTTPURLResponse(url: URL(string: "success")!,
                                                 statusCode: 200,
                                                 httpVersion: nil,
                                                 headerFields: nil)
    var error: Error?
}

struct DataTaskResponse: DummyResponse {
    var data: Data?
    var response: URLResponse?
    var error: Error? = NetworkError.invalidURL
}

struct InvalidResponse: DummyResponse {
    var data: Data?
    var response: URLResponse?
    var error: Error?
}

struct StatusCodeOutOfRangeResponse: DummyResponse {
    var data: Data?
    var response: URLResponse? = HTTPURLResponse(url: URL(string: "Fail")!,
                                                 statusCode: 404,
                                                 httpVersion: nil,
                                                 headerFields: nil)
    var error: Error?
}

struct EmptyDataResponse: DummyResponse {
    var data: Data?
    var response: URLResponse? = HTTPURLResponse(url: URL(string: "Fail")!,
                                                 statusCode: 200,
                                                 httpVersion: nil,
                                                 headerFields: nil)
    var error: Error?
}
