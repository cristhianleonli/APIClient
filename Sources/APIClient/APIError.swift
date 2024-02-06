import Foundation

public typealias APIParameters = [String: String]
public typealias APIBody = [String: AnyHashable]
public typealias APIHeaders = [String: String]

public enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}
