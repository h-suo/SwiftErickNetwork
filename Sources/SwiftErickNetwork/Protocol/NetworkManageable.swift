//
//  NetworkManageable.swift
//  
//
//  Created by Erick on 2024/01/24.
//

import Combine
import Foundation

public protocol NetworkManageable {
    
    var urlSession: URLSessionProtocol { get }
    
    func request<DTO: Decodable, EndPoint: NetworkConfigurable>(
        with endpoint: EndPoint,
        completion: @escaping (Result<DTO, NetworkError>) -> Void
    ) where EndPoint.Response == DTO
    
    func request(
        with url: URL,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    )
    
    func requestPublisher<DTO: Decodable, EndPoint: NetworkConfigurable>(
        with endpoint: EndPoint
    ) -> AnyPublisher<DTO, NetworkError> where EndPoint.Response == DTO
    
    func requestPublisher(with url: URL) -> AnyPublisher<Data, NetworkError>
}
