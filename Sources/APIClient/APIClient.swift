import Combine
import Foundation

public struct APIClient {
    public static func dispatch<ResultType: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<ResultType, APIError> {
        let request = Self.createURL(from: endpoint)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                guard httpResponse.statusCode >= 200, httpResponse.statusCode < 300 else {
                    throw APIError.requestFailed(code: httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: ResultType.self, decoder: endpoint.decoder)
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return APIError.decodingFailed(error: decodingError)
                }
                
                return APIError.error(error: error)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
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
        request.httpMethod = "\(endpoint.method)".uppercased()
        
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
