import Foundation

class NewsManager {
    
    func parseNews(callback: @escaping ([Post]) -> Void) {
        let urlString = "https://taxoffice.run/output_news.php"
        
        guard let url = URL(string: urlString) else {
            callback([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                callback([])
                return
            }
            
            guard let data = data else {
                callback([])
                return
            }
            
            do {
                let postsData = try JSONDecoder().decode([PostResponse].self, from: data)
                let postItems = postsData.map { $0.toPostItem() }
                callback(postItems)
            } catch {
                print("Error parse news \(error.localizedDescription)")
                callback([])
            }
        }
        task.resume()
    }
    
}
