import SwiftUI
import SDWebImageSwiftUI
import SkeletonUI

struct BasePostItem: View {
    
    var post: Post
    @EnvironmentObject var favorites: FavoritePostsViewModel
    
    @State var loadingImage = true
    @State var loadingImage2 = true
    
    var savePost: (Post) -> Void
    
    var body: some View {
        VStack {
            WebImage(url: URL(string: post.images[0])) { image in
                image.resizable()
                    .frame(height: 250)
                    .cornerRadius(12)
                    .onAppear {
                        loadingImage2 = false
                    }
            } placeholder: {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.gray.opacity(0.4))
                    .frame(height: 250)
            }
            
            HStack {
                Text("•")
                    .font(.custom("Inter-Regular_Medium", size: 10))
                    .foregroundColor(Color.init(red: 182/255, green: 178/255, blue: 178/255))
                
                Text("\(timeAgoSinceTimestamp(post.time))")
                    .font(.custom("Inter-Regular_Medium", size: 10))
                    .foregroundColor(.init(red: 182/255, green: 178/255, blue: 178/255))
                
                Spacer()
            }
            .padding(.vertical, 6)
            
            Text(post.title)
                .multilineTextAlignment(.leading)
                .font(.custom("Inter-Regular_Bold", size: 18))
                .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
         
            HStack {
                if UserDefaults.standard.bool(forKey: "is_post_liked_\(post.id)") {
                    Image("likes_active")
                } else {
                    Image("likes")
                }
                Text("\(post.likes)")
                    .font(.custom("Inter-Regular_Bold", size: 12))
                    .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
                 
                
                if UserDefaults.standard.bool(forKey: "is_post_disliked_\(post.id)") {
                    Image("dislikes_active")
                        .padding(.leading)
                } else {
                    Image("dislikes")
                        .padding(.leading)
                }
                Text("\(post.dislikes)")
                    .font(.custom("Inter-Regular_Bold", size: 12))
                    .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
                Spacer()
                
                Button {
                    savePost(post)
                } label: {
                    if favorites.isPostSaved(post: post) {
                        Image("bookmark_active")
                    } else {
                        Image("bookmark")
                    }
                    Text("Save")
                        .font(.custom("Inter-Regular_Bold", size: 12))
                        .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
                }
            }
            .padding(.leading)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background(
            Rectangle()
                .fill(.white)
        )
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
    }
}

#Preview {
    BasePostItem(post: testPosts[0]) { post in }
    // PostItemSmall(post: testPosts[0])
}

struct PostItemSmall: View {
    var post: Post
    
    @State var loadingImage = true
    
    var body: some View {
        VStack {
            WebImage(url: URL(string: post.images[0])) { image in
                image.resizable()
                    .frame(height: 100)
                    .onAppear {
                        loadingImage = false
                    }
            } placeholder: {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.gray.opacity(0.4))
                    .frame(height: 100)
            }
            
            Text(post.title)
               .font(.custom("Inter-Regular_Bold", size: 12))
               .multilineTextAlignment(.leading)
               .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
               .padding(6)
        }
        .frame(width: 150, height: 170)
        .background(
            Rectangle()
                .fill(.white)
        )
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
    }
    
}

#Preview {
    PostItemSmall(post: testPosts[0])
}

struct PostItemSmall2: View {
    var post: Post
    
    @State var loadingImage = true
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: post.images[0])) { image in
                image.resizable()
                    .frame(width: 60, height: 60)
                    .onAppear {
                        loadingImage = false
                    }
            } placeholder: {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.gray.opacity(0.4))
                    .frame(width: 60, height: 60)
            }
            
            Text(post.title)
               .font(.custom("Inter-Regular_Bold", size: 8))
               .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
               .multilineTextAlignment(.leading)
               .padding(4)
        }
        .frame(width: 170)
        .background(
            Rectangle()
                .fill(.white)
        )
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
    }
    
}

#Preview {
    PostItemSmall2(post: testPosts[0])
}
