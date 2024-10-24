import SwiftUI

struct FavoritesPostsView: View {
    
    @EnvironmentObject var loadingViewModel: LoadingViewModel
    @EnvironmentObject var favorites: FavoritePostsViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Text("Saved")
                            .font(.custom("Inter-Regular_Bold", size: 32))
                            .foregroundColor(Color.init(red: 240/255, green: 44/255, blue: 0))
                        Spacer()
                    }
                    .frame(height: 80)
                    .padding(.horizontal)
                    .background(
                        Rectangle()
                            .fill(.white)
                            .frame(width: UIScreen.main.bounds.width,
                                   height: 80)
                    )
                    
                    let hotTopicsNews = loadingViewModel.postItemsMain.filter { $0.category.postsStyle == .hotTopic }.first
                    if let hotTopicsNews = hotTopicsNews {
                        LazyVStack {
                            HStack {
                                Text("Hot Topic")
                                    .font(.custom("Inter-Regular_Bold", size: 24))
                                    .foregroundColor(.black)
                                    .padding(.top)
                                Spacer()
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 24) {
                                    ForEach(hotTopicsNews.posts, id: \.title) { post in
                                        NavigationLink(destination: DetailsArticleView(postItem: post)
                                            .environmentObject(loadingViewModel)
                                            .environmentObject(favorites)
                                            .navigationBarBackButtonHidden()) {
                                            PostItemSmall(post: post)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(
                            Rectangle()
                                .fill(.white)
                        )
                        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
                    }
                    
                    let favoritesPosts = loadingViewModel.postItems.filter { favorites.savedPosts.contains($0.title) }
                    
                    if favoritesPosts.isEmpty {
                        Text("Favorites is empty!")
                            .font(.custom("Inter-Regular_Bold", size: 24))
                            .foregroundColor(.black)
                    } else {
                        LazyVStack {
                            ForEach(favoritesPosts, id: \.title) { postItem in
                                NavigationLink(destination: DetailsArticleView(postItem: postItem)
                                    .environmentObject(loadingViewModel)
                                    .environmentObject(favorites)
                                    .navigationBarBackButtonHidden()) {
                                    BasePostItem(post: postItem) { post in
                                        favorites.toggleSavedPost(post: post)
                                    }
                                    .environmentObject(favorites)
                                }
                            }
                        }
                    }
                    
                }
            }
            .background(
                Rectangle()
                    .fill(Color.init(red: 245/255, green: 248/255, blue: 253/255))
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    FavoritesPostsView()
}
