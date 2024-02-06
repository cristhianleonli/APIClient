import Foundation
import Combine

struct APIClient {
    static func dispatch<ResultType: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<ResultType, APIError> {
        let request = Self.createURL(from: endpoint)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.invalidResponse
                }
                
                return data
            }
            .decode(type: ResultType.self, decoder: endpoint.decoder)
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return APIError.decodingFailed(decodingError)
                }
                
                return APIError.requestFailed(error)
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
        request.allHTTPHeaderFields = endpoint.headers
        
        // Add request body
        if !endpoint.requestBody.isEmpty {
            if let jsonData = try? JSONSerialization.data(withJSONObject: endpoint.requestBody) {
                request.httpBody = jsonData
            }
        }
        
        return request
    }
}
