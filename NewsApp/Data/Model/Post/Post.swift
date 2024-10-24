import Foundation

func generateRandomDateInPast5Days() -> Date {
    let now = Date()
    let fiveDaysInSeconds: TimeInterval = 5 * 24 * 60 * 60
    let randomInterval = TimeInterval(arc4random_uniform(UInt32(fiveDaysInSeconds)))
    return now.addingTimeInterval(-randomInterval)
}

struct PostResponse: Codable {
    var title: String
    var images: String
    var text: String
    var category: String
    var tags: String
}

extension PostResponse {
    func toPostItem() -> Post {
        var postImages: [String] = []
        var postTags: [String] = []
        if let imagesData = images.data(using: .utf8),
           let tagsData = tags.data(using: .utf8) {
            do {
                postImages = try JSONDecoder().decode([String].self, from: imagesData)
                postTags = try JSONDecoder().decode([String].self, from: tagsData)
            } catch {
            }
        }
        return Post(images: postImages, title: title, desc: text, likes: Int.random(in: 0...150), dislikes: Int.random(in: 0...25), time: Int(generateRandomDateInPast5Days().timeIntervalSince1970), tags: postTags)
    }
}

struct Post: Equatable {
    var images: [String]
    var title: String
    var desc: String
    var likes: Int
    var dislikes: Int
    var time: Int
    var tags: [String]
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.title == rhs.title
    }
}
