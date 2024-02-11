//
//  NetworkManager.swift
//  
//
//  Created by Erick on 2024/01/24.
//

import Combine
import Foundation

open class NetworkManager: NetworkManageable {
    
    public var urlSession: URLSessionProtocol
    
    public init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    public func request<DTO: Decodable, EndPoint: NetworkConfigurable>(
        with endpoint: EndPoint,
        completion: @escaping (Result<DTO, NetworkError>) -> Void
    ) where EndPoint.Response == DTO {
        
        do {
            let request = try endpoint.urlRequest()
            
            urlSession.dataTask(with: request) { [weak self] data, response, error in
                self?.checkError(with: data, response, error) { result in
                    guard let self = self else {
                        return
                    }
                    
                    switch result {
                    case .success(let data):
                        completion(self.decode(data: data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }.resume()
        } catch {
            completion(.failure(NetworkError.urlRequest(error)))
        }
    }
    
    public func request(
        with url: URL,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        
        urlSession.dataTask(with: url) { [weak self] data, response, error in
            self?.checkError(with: data, response, error) { result in
                completion(result)
            }
        }.resume()
    }
    
    public func requestPublisher<DTO: Decodable, EndPoint: NetworkConfigurable>(
        with endpoint: EndPoint
    ) -> AnyPublisher<DTO, NetworkError> where EndPoint.Response == DTO {
        
        do {
            let request = try endpoint.urlRequest()
            
            return urlSession.responsePublisher(for: request)
                .tryMap { data, response in
                    try self.processDataTask(with: data, response)
                }
                .decode(type: DTO.self, decoder: JSONDecoder())
                .mapError { error in
                    self.processError(with: error)
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.urlRequest(error))
                .eraseToAnyPublisher()
        }
    }
    
    public func requestPublisher(with url: URL) -> AnyPublisher<Data, NetworkError> {
        return urlSession.responsePublisher(for: url)
            .tryMap { data, response in
                try self.processDataTask(with: data, response)
            }
            .mapError { error in
                self.processError(with: error)
            }
            .eraseToAnyPublisher()
    }
    
    private func checkError(
        with data: Data?,
        _ response: URLResponse?,
        _ error: Error?,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        
        if let error = error {
            completion(.failure(NetworkError.dataTask(error)))
            return
        }
        
        guard let response = response as? HTTPURLResponse else {
            completion(.failure(NetworkError.invalidResponse))
            return
        }
        
        guard (200...299).contains(response.statusCode) else {
            completion(.failure(NetworkError.statusCodeOutOfRange))
            return
        }
        
        guard let data = data else {
            completion(.failure(NetworkError.emptyData))
            return
        }
        
        completion(.success((data)))
    }
    
    private func decode<DTO: Decodable>(data: Data) -> Result<DTO, NetworkError> {
        
        do {
            let decoded = try JSONDecoder().decode(DTO.self, from: data)
            
            return .success(decoded)
        } catch {
            return .failure(NetworkError.dataConversionFailed)
        }
    }
    
    private func processDataTask(
        with data: Data,
        _ response: URLResponse
    ) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse
        else { throw NetworkError.invalidResponse }
        
        guard (200...299).contains(httpResponse.statusCode)
        else { throw NetworkError.statusCodeOutOfRange }
        
        return data
    }
    
    private func processError(with error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        } else {
            return NetworkError.dataTask(error)
        }
    }
}
