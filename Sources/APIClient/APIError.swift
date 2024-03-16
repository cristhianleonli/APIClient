import Foundation

public typealias APIParameters = [String: String]
public typealias APIBody = [String: AnyHashable]
public typealias APIHeaders = [String: String]

public enum APIError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(code: Int)
    case error(error: Error)
    case decodingFailed(error: Error)
}
