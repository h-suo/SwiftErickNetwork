//
//  DummyCombineResponse.swift
//  
//
//  Created by Erick on 2024/01/25.
//

import Foundation

protocol DummyCombineResponse {
    var data: Data { get }
    var response: URLResponse { get }
}

struct SuccessCombineResponse: DummyCombineResponse {
    var data: Data = """
                     {
                        "id": 25,
                        "title": "Erick"
                     }
                     """.data(using: .utf8)!
    var response: URLResponse = HTTPURLResponse(url: URL(string: "success")!,
                                                statusCode: 200,
                                                httpVersion: "HTTP/1.1",
                                                headerFields: nil)!
}

struct InvalidCombineResponse: DummyCombineResponse {
    var data: Data = """
                     """.data(using: .utf8)!
    var response: URLResponse = URLResponse(url: URL(string: "Fail")!,
                                            mimeType: nil,
                                            expectedContentLength: 404,
                                            textEncodingName: nil)
}

struct StatusCodeOutOfRangeCombineResponse: DummyCombineResponse {
    var data: Data = """
                     """.data(using: .utf8)!
    var response: URLResponse = HTTPURLResponse(url: URL(string: "Fail")!,
                                                statusCode: 404,
                                                httpVersion: "HTTP/1.1",
                                                headerFields: nil)!
}
