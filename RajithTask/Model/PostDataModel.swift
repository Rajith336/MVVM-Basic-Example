
import Foundation

// MARK: - PostData
class PostData: Codable {
    var isFavourite: Bool?
    var userID, id: Int?
    var title, body: String?
    
    enum CodingKeys: String, CodingKey {
        case isFavourite
        case userID = "userId"
        case id, title, body
    }
    
    init(isFavourite: Bool?, userID: Int?, id: Int?, title: String?, body: String?) {
        self.isFavourite = isFavourite
        self.userID = userID
        self.id = id
        self.title = title
        self.body = body
    }
}

// MARK: PostData convenience initializers and mutators

extension PostData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(PostData.self, from: data)
        self.init(isFavourite: me.isFavourite, userID: me.userID, id: me.id, title: me.title, body: me.body)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        isFavourite: Bool?? = nil,
        userID: Int?? = nil,
        id: Int?? = nil,
        title: String?? = nil,
        body: String?? = nil
    ) -> PostData {
        return PostData(
            isFavourite: isFavourite ?? self.isFavourite,
            userID: userID ?? self.userID,
            id: id ?? self.id,
            title: title ?? self.title,
            body: body ?? self.body
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

typealias Post = [PostData]

extension Array where Element == Post.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Post.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
