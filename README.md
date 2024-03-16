# APIClient

Light-weight API rest client built using Combine

## Swift Package Manager

Add the Swift package to your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/cristhianleonli/APIClient.git", from: "1.0.0")
]
```

## Usage

```swift
func usage() {
    let getChuckNorrisJoke: AnyPublisher<Joke, APIError> = APIClient.dispatch(MockEndpoint.getRandom)

    getChuckNorrisJoke
        .sink { completion in
            print(completion)
        } receiveValue: { joke in
            print(jokes)
        }
        .store(in: &cancellables)
}

// Structure to decode response
struct Joke: Decodable {
    let id: String
    let value: String
    let iconUrl: String
}

// Endpoint to form the requests
enum MockEndpoint: APIEndpoint {
    case getRandom
    case getByCategory(String)
    
    var baseURL: URL {
        URL(string: "https://api.chucknorris.io/jokes")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .getRandom, .getByCategory:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getRandom, .getByCategory:
            return "/random"
        }
    }
    
    var parameters: APIParameters {
        switch self {
        case .getRandom:
            return [:]
        case let .getByCategory(category):
            return ["category": category]
        }
    }
    
    var decoder: JSONDecoder {
        let snakeDecoder = JSONDecoder()
        snakeDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return snakeDecoder
    }
}

```

## Contribution

All contributors are welcome.
