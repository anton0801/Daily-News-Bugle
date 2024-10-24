import Foundation
import Combine

class FavoritePostsViewModel: ObservableObject {
    
    @Published var savedPosts: [String] = [] {
        didSet {
            savePostsToUserDefaults()
        }
    }
        
    init() {
        loadPostsFromUserDefaults()
    }
    
    func addPostToFavorites(post: Post) {
        if !savedPosts.contains(post.title) {
            savedPosts.append(post.title)
        }
    }
    
    func removePostFromFavorites(post: Post) {
        savedPosts.removeAll { $0 == post.title }
    }
    
    func toggleSavedPost(post: Post) {
        if isPostSaved(post: post) {
            removePostFromFavorites(post: post)
        } else {
            addPostToFavorites(post: post)
        }
    }
    
    func isPostSaved(post: Post) -> Bool {
        return savedPosts.contains(post.title)
    }
    
    private func savePostsToUserDefaults() {
        UserDefaults.standard.set(savedPosts, forKey: "savedPosts")
    }
    
    private func loadPostsFromUserDefaults() {
        if let saved = UserDefaults.standard.array(forKey: "savedPosts") as? [String] {
            savedPosts = saved
        }
    }
    
}
