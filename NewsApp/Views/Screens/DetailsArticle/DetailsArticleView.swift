import SwiftUI
import SDWebImageSwiftUI

struct DetailsArticleView: View {
    
    @Environment(\.presentationMode) var presMode
    var postItem: Post
    @EnvironmentObject var loadingViewModel: LoadingViewModel
    @EnvironmentObject var favorites: FavoritePostsViewModel
    
    @State var likes = 0
    @State var dislikes = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Button {
                            presMode.wrappedValue.dismiss()
                        } label: {
                            Image("back")
                        }
                        Text("Back")
                            .font(.custom("Inter-Regular_Bold", size: 24))
                            .foregroundColor(Color.init(red: 240/255, green: 44/255, blue: 0))
                            .padding(.leading, 6)
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
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 0)
                    }
                    
                    LazyVStack {
                        Text(postItem.title)
                            .font(.custom("Inter-Regular_Bold", size: 24))
                            .foregroundColor(.black)
                            .padding(.top)
                            .multilineTextAlignment(.leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(postItem.tags, id: \.self) { tag in
                                    Text(tag)
                                        .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                                        .background(
                                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                .fill(
                                                    Color.init(red: 245/255, green: 248/255, blue: 253/255)
                                                )
                                        )
                                        .padding(.trailing)
                                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 0)
                                }
                            }
                        }
                        .padding(.top, 2)
                        .padding(.leading)
                        
                        HStack {
                            Text("•")
                                .font(.custom("Inter-Regular_Medium", size: 10))
                                .foregroundColor(Color.init(red: 182/255, green: 178/255, blue: 178/255))
                            
                            Text("\(timeAgoSinceTimestamp(postItem.time))")
                                .font(.custom("Inter-Regular_Medium", size: 10))
                                .foregroundColor(.init(red: 182/255, green: 178/255, blue: 178/255))
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        
                        WebImage(url: URL(string: postItem.images[0])) { image in
                            image.resizable()
                                .frame(height: 250)
                                .cornerRadius(12)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(.gray.opacity(0.4))
                                .frame(height: 250)
                        }
                        
                        let paragraphs = splitTextIntoParagraphs(postItem.desc)
                        
                        ForEach(paragraphs.indices, id: \.self) { paragraphIndex in
                            let paragraph = paragraphs[paragraphIndex]
                            Text(paragraph)
                                .font(.custom("Inter-Regular_Medium", size: 14))
                                .foregroundColor(.black)
                                .padding(.top)
                        }
                        
                        HStack {
                            Button {
                                UserDefaults.standard.set(true, forKey: "is_post_liked_\(postItem.id)")
                                UserDefaults.standard.set(false, forKey: "is_post_disliked_\(postItem.id)")
                                withAnimation(.linear) {
                                    if dislikes > postItem.dislikes {
                                        dislikes -= 1
                                    }
                                    likes += 1
                                }
                            } label: {
                                if likes > postItem.likes || UserDefaults.standard.bool(forKey: "is_post_liked_\(postItem.id)") {
                                    Image("likes_active")
                                } else {
                                    Image("likes")
                                }
                                Text("\(likes)")
                                    .font(.custom("Inter-Regular_Bold", size: 12))
                                    .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
                            }
                            
                            Button {
                                UserDefaults.standard.set(false, forKey: "is_post_liked_\(postItem.id)")
                                UserDefaults.standard.set(true, forKey: "is_post_disliked_\(postItem.id)")
                                withAnimation(.linear) {
                                    if likes > postItem.likes {
                                        likes -= 1
                                    }
                                    dislikes += 1
                                }
                            } label: {
                                if likes > postItem.likes || UserDefaults.standard.bool(forKey: "is_post_disliked_\(postItem.id)") {
                                    Image("dislikes_active")
                                } else {
                                    Image("dislikes")
                                }
                                Text("\(postItem.dislikes)")
                                    .font(.custom("Inter-Regular_Bold", size: 12))
                                    .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
                            }
                            Spacer()
                            
                            Button {
                                favorites.toggleSavedPost(post: postItem)
                            } label: {
                                if favorites.isPostSaved(post: postItem) {
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
                        .padding(.top, 6)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .background(
                        Rectangle()
                            .fill(.white)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
                    
                    let watchNext = loadingViewModel.postItemsMain.filter { $0.category.postsStyle == .small }.first
                    if let watchNext = watchNext {
                        VStack {
                            HStack {
                                Text("Watch next")
                                    .font(.custom("Inter-Regular_Bold", size: 24))
                                    .foregroundColor(.black)
                                    .padding(.top)
                                Spacer()
                            }
                            
                            LazyVGrid(columns: [
                                GridItem(.adaptive(minimum: 170, maximum: 250)),
                                GridItem(.adaptive(minimum: 170, maximum: 250))
                            ]) {
                                ForEach(watchNext.posts, id: \.title) { post in
                                    NavigationLink(destination: DetailsArticleView(postItem: post)
                                        .environmentObject(loadingViewModel)
                                        .environmentObject(favorites)
                                        .navigationBarBackButtonHidden()) {
                                            PostItemSmall2(post: post)
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
                }
            }
            .background(
                Rectangle()
                    .fill(Color.init(red: 245/255, green: 248/255, blue: 253/255))
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
            .onAppear {
                likes = postItem.likes
                dislikes = postItem.likes
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func splitTextIntoParagraphs(_ text: String, maxParagraphLength: Int = 400) -> [String] {
        var paragraphs: [String] = []
        var currentParagraph = ""

        let sentences = text.components(separatedBy: ". ") // Разделяем текст на предложения
        
        for sentence in sentences {
            if currentParagraph.count + sentence.count <= maxParagraphLength {
                currentParagraph += (currentParagraph.isEmpty ? "" : ". ") + sentence
            } else {
                paragraphs.append(currentParagraph)
                currentParagraph = sentence
            }
        }

        if !currentParagraph.isEmpty {
            paragraphs.append(currentParagraph) // Добавляем последний абзац
        }

        return paragraphs
    }

    
}

#Preview {
    DetailsArticleView(postItem: testPosts[0])
        .environmentObject(LoadingViewModel())
        .environmentObject(FavoritePostsViewModel())
}
