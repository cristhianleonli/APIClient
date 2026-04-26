# APIClient

Lightweight REST API client built using modern Swift Concurrency (async/await).

### Swift Package Manager

Add the Swift package to your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/cristhianleonli/APIClient.git", .upToNextMajor(from: "0.0.2"))
]
```

## Usage

### Basic Request

```swift
func example() async {
    do {
        let response: [Response] = try await APIClient.dispatch(Request())
        print(response)
    } catch {
        print(error)
    }
}
```

### Define an endpoint

```swift
struct Request: APIEndpoint {
    let baseURL: URL = URL(string: "https://jsonplaceholder.typicode.com")!
    let method: HTTPMethod  = .get
    let path: String = "/todos"
}
```

### Define a Response model

```swift
struct Response: Decodable {
    let id: Int
    let title: String
    let userId: Int
}
```

### Error Handling

APIClient uses Swift's native error handling via throws.

```swift
do {
    let result: [Response] = try await APIClient.dispatch(Request())
} catch {
    // Handle error appropriately
}
```

## Contribution

Contributions are welcome. Feel free to open an issue or submit a PR.
