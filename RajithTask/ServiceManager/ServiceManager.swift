
import Foundation
import Moya

enum Service {
    case postList
}

// MARK: - TargetType Protocol Implementation
extension Service: TargetType {
    
    var baseURL: URL { return URL(string: "https://jsonplaceholder.typicode.com")! }
    var path: String {
        switch self {
        case .postList:
            return "/posts"
            
        }
    }
    var method: Moya.Method {
        switch self {
        case .postList:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .postList: // Send no parameters
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        switch self {
        case .postList:
            return "Sample".utf8Encoded
        }
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
