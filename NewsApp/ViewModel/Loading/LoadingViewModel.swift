import Foundation

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
    
    @Published var weatherData: WeatherResponse? = nil
    
    @Published var postItems: [Post] = []
    
    @Published var postItemsMain: [PostMain] = []
    
    let newsManager = NewsManager()
    let weatherManager = WeatherManager()
    
    init() {
        parseNews()
    }
    
    func parseNews() {
        newsManager.parseNews { postItems in
            DispatchQueue.main.async {
                self.postItems = postItems
                self.makePostsForMainScreen()
                self.loadingProgress = 100
            }
        }
    }
    
    private func makePostsForMainScreen() {
        var allPosts: [Post] = []
        allPosts.append(contentsOf: postItems)
        let mostViewed = Array(allPosts.shuffled().prefix(4))
        allPosts.removeAll { mostViewed.contains($0) }
        let hotTopic = Array(allPosts.shuffled().prefix(Int.random(in: 4...12)))
        allPosts.removeAll { hotTopic.contains($0) }
        var restPosts = allPosts
        postItemsMain.append(PostMain(posts: hotTopic, category: PostCategory(title: "Hot Topic", postsStyle: .hotTopic)))
        postItemsMain.append(PostMain(posts: [restPosts[0]], category: PostCategory(title: "", postsStyle: .large)))
        postItemsMain.append(PostMain(posts: mostViewed, category: PostCategory(title: "Most Viewed", postsStyle: .small)))
        restPosts.remove(at: 0)
        postItemsMain.append(PostMain(posts: restPosts, category: PostCategory(title: "", postsStyle: .large)))
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
    
}
