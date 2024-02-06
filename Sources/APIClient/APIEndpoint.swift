import Foundation

public protocol APIEndpoint {
    // Required
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    
    // Optional conformances
    var decoder: JSONDecoder { get }
    var parameters: APIParameters { get }
    var requestBody: APIBody { get }
    var headers: APIHeaders { get }
}

// MARK: - Default Behavior
public extension APIEndpoint {
    var decoder: JSONDecoder { JSONDecoder() }
    var parameters: APIParameters { return [:] }
    var requestBody: APIBody { return [:] }
    var headers: APIHeaders { return [:] }
}
