//
//  URLSessionDataTaskProtocol.swift
//  
//
//  Created by Erick on 2024/01/24.
//

import Foundation

public protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
