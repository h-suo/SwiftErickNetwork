//
//  NetworkError.swift
//  
//
//  Created by Erick on 2024/01/24.
//

import Foundation

public enum NetworkError: LocalizedError {
    case invalidURL
    case invalidComponents
    case invalidResponse
    case statusCodeOutOfRange
    case emptyData
    case dataTask(Error)
    case urlRequest(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL is invalid."
        case .invalidComponents:
            return "URL component is invalid."
        case .invalidResponse:
            return "Response is Invalid."
        case .statusCodeOutOfRange:
            return "The state code is not in success range."
        case .emptyData:
            return "Data is empty."
        case .dataTask(let error):
            return "The following error occurred in dataTask.: \(error.localizedDescription) "
        case .urlRequest(let error):
            return "The following error occurred during the urlRequest return process.: \(error.localizedDescription)"
        }
    }
}

extension NetworkError: Equatable {
    
    public static func == (
        lhs: NetworkError,
        rhs: NetworkError
    ) -> Bool {
        
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
            (.invalidComponents, .invalidComponents),
            (.invalidResponse, .invalidResponse),
            (.statusCodeOutOfRange, .statusCodeOutOfRange),
            (.emptyData, .emptyData):
            return true
        case let (.dataTask(error1), .dataTask(error2)),
            let (.urlRequest(error1), .urlRequest(error2)):
            return error1.localizedDescription == error2.localizedDescription
        default:
            return false
        }
    }
}
