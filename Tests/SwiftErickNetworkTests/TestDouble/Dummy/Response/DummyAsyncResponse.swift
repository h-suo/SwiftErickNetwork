//
//  DummyAsyncResponse.swift
//
//
//  Created by Erick on 4/12/24.
//

import Foundation

protocol DummyAsyncResponse {
    var data: Data { get }
    var response: URLResponse { get }
}

struct SuccessAsyncResponse: DummyAsyncResponse {
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

struct InvalidAsyncResponse: DummyAsyncResponse {
    var data: Data = """
                     """.data(using: .utf8)!
    var response: URLResponse = URLResponse(url: URL(string: "Fail")!,
                                            mimeType: nil,
                                            expectedContentLength: 404,
                                            textEncodingName: nil)
}

struct StatusCodeOutOfRangeAsyncResponse: DummyAsyncResponse {
    var data: Data = """
                     """.data(using: .utf8)!
    var response: URLResponse = HTTPURLResponse(url: URL(string: "Fail")!,
                                                statusCode: 404,
                                                httpVersion: "HTTP/1.1",
                                                headerFields: nil)!
}
