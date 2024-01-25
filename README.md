# SwiftErickNetwork

> You can easily network using the SwiftErickNetwork package.
> 
> `iOS 13.0+` `macOS 10.15+` 

<br>

## Overview

**SwiftErickNetwork** provides a blueprint called **NetworkConfigurable** to easily create EndPoints and offers a **NetworkManager** to facilitate networking and decoding tasks seamlessly.

### NetworkConfigurable

**NetworkConfigurable** provides a blueprint for EndPoints, assisting in the creation and management of various API EndPoints used within the app. 

Additionally, it offers support for `url()` and `urlRequest()` functions, making it convenient when simply working with URL or URLRequest instances.

```swift
public protocol NetworkConfigurable {
    
    associatedtype Response
    
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var queryParameters: [URLQueryItem]? { get }
}
```

### NetworkManager

**NetworkManager** facilitates networking and decoding effortlessly using either a URL or an EndPoint. 
When performing networking with an EndPoint, it returns decoded data using the Response type specified by the EndPoint.

Moreover, it provides the requestPublisher(with:) function, enabling asynchronous processing with Combine.

```swift
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
```
