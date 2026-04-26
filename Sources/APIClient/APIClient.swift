import Combine
import Foundation

public struct APIClient {
    public static func dispatch<ResultType: Decodable>(_ endpoint: APIEndpoint) async throws -> ResultType {
        let url = createURL(from: endpoint)
        let (data, response) = try await URLSession.shared.data(for: url)
        try validate(response)
        
        return try endpoint.decoder.decode(ResultType.self, from: data)
    }
    
    private static func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard 200..<300 ~= http.statusCode else {
            throw APIError.requestFailed(code: http.statusCode)
        }
    }
    
    private static func createURL(from endpoint: APIEndpoint) -> URLRequest {
        // Create full URL
        var url = endpoint
            .baseURL
            .appendingPathComponent(endpoint.path)
        
        // Add query params
        if !endpoint.parameters.isEmpty {
            url = url.appending(
                queryItems: endpoint.parameters.map { key, value in
                    URLQueryItem(name: key, value: value)
                }
            )
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Add headers
        var headers = endpoint.headers
        
        // Add request body
        if !endpoint.requestBody.isEmpty {
            if let jsonData = try? JSONSerialization.data(withJSONObject: endpoint.requestBody) {
                request.httpBody = jsonData
                headers["Content-Type"] = "application/json"
            }
        }
        
        request.allHTTPHeaderFields = headers
        return request
    }
}
