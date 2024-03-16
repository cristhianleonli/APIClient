# APIClient

Light-weight API rest client built using Combine

## Swift Package Manager

Add the Swift package to your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/cristhianleonli/APIClient.git", .upToNextMajor(from: "0.0.1"))
]
```

## Usage

```swift
func usage() {
    let publisher: AnyPublisher<[Response], APIError> = APIClient.dispatch(Request())
    
    publisher
        .sink { completion in
        print(completion)
    } receiveValue: { value in
        print(value)
    }
    .store(in: &cancellables)
}

struct Request: APIEndpoint {
    let baseURL: URL = URL(string: "https://jsonplaceholder.typicode.com")!
    let method: HTTPMethod  = .get
    let path: String = "/todos"
}

struct Response: Decodable {
    let id: Int
    let title: String
    let userId: Int
}
```

In case you want to use JSON raw data as response, you can use [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

```swift
let publisher: AnyPublisher<JSON, APIError> = APIClient.dispatch(Request())
```

## Contribution

All contributors are welcome.
