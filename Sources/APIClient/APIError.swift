import Foundation

public typealias APIParameters = [String: String]
public typealias APIBody = [String: AnyHashable]
public typealias APIHeaders = [String: String]

public enum APIError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(code: Int)
    case decodingFailed(error: Error)
    case other(error: Error)
}
