import SwiftUI
import SDWebImageSwiftUI
import SkeletonUI

struct HomeView: View {
    
    @EnvironmentObject var loadingViewModel: LoadingViewModel
    @EnvironmentObject var favorites: FavoritePostsViewModel
    @EnvironmentObject var locationManager: LocationManager
    
    @State var loadingImage = true
    
    @State var selectedTag: String = "For you" {
        didSet {
            loadingViewModel.sortByTag(tag: selectedTag)
        }
    }
    
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    VStack {
                        HStack {
                            Text("\(loadingViewModel.cityName)")
                                .font(.custom("Inter-Regular_Bold", size: 32))
                                .foregroundColor(Color.init(red: 240/255, green: 44/255, blue: 0))
                            Spacer()
                            
                            TextField("Type smth", text: $searchText)
                                .frame(width: 150, height: 50)
                                .font(.custom("Inter-Regular_Bold", size: 16))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color.init(red: 240/255, green: 44/255, blue: 0), lineWidth: 1)
                                )
                            
                            Button {
                                loadingViewModel.searhPosts(query: searchText)
                            } label: {
                                Image("search_icon")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                        }
                        .frame(height: 80)
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(loadingViewModel.tagedPostNames, id: \.self) { tag in
                                    Button {
                                        withAnimation(.linear) {
                                            selectedTag = tag
                                        }
                                    } label: {
                                        ZStack {
                                            if selectedTag == tag {
                                                Text(tag)
                                                    .font(.custom("Inter-Regular_Bold", size: 18))
                                                    .foregroundColor(Color.init(red: 240/255, green: 44/255, blue: 0))
                                                
                                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                    .fill(Color.init(red: 240/255, green: 44/255, blue: 0))
                                                    .frame(width: 30, height: 5)
                                                    .offset(y: -20)
                                            } else {
                                                Text(tag)
                                                    .font(.custom("Inter-Regular_Bold", size: 18))
                                                    .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
                                            }
                                        }
                                    }
                                    .padding(.trailing)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .background(
                        Rectangle()
                            .fill(.white)
                            .frame(width: UIScreen.main.bounds.width,
                                   height: 120)
                    )
                    
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(
                                    LinearGradient(colors: [
                                        Color.init(red: 191/255, green: 214/255, blue: 1),
                                        Color.init(red: 153/255, green: 185/255, blue: 241/255)
                                    ], startPoint: .top, endPoint: .bottom)
                                )
                                .frame(height: 200)
                            
                            HStack {
                                if let weatherData = loadingViewModel.weatherData {
                                    NavigationLink(destination: WeatherView()
                                        .environmentObject(locationManager)
                                        .environmentObject(loadingViewModel)
                                        .navigationBarBackButtonHidden()) {
                                            VStack(alignment: .leading, spacing: 0) {
                                                Text(currentDateFormatted())
                                                    .font(.custom("Inter-Regular_Medium", size: 12))
                                                    .foregroundColor(.white)
                                                    .padding(.top)
                                                
                                                Text("\(loadingViewModel.cityName)")
                                                    .font(.custom("Inter-Regular_Bold", size: 20))
                                                    .foregroundColor(.white)
                                                    .padding(.top)
                                                
                                                Text("\(weatherData.main.temp.formatDouble(0))°C")
                                                    .font(.custom("Inter-Regular_Bold", size: 32))
                                                    .foregroundColor(.white)
                                                    .padding(.top)
                                                
                                                Text(weatherData.weather.first?.description ?? "")
                                                    .font(.custom("Inter-Regular_Medium", size: 12))
                                                    .foregroundColor(.white)
                                                    .padding(.top)
                                            }
                                            .padding(.horizontal)
                                            Spacer()
                                            VStack {
                                                WebImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherData.weather.first?.icon ?? "")@2x.png")) { image in
                                                    image.resizable()
                                                        .frame(height: 170)
                                                        .onAppear {
                                                            loadingImage = false
                                                        }
                                                } placeholder: {
                                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                                        .fill(.gray)
                                                        .frame(height: 60)
                                                        .skeleton(with: loadingImage)
                                                }
                                            }
                                        }
                                } else {
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(currentDateFormatted())
                                            .font(.custom("Inter-Regular_Medium", size: 12))
                                            .foregroundColor(.white)
                                            .padding(.top)
                                        
                                        Text("--")
                                            .font(.custom("Inter-Regular_Bold", size: 24))
                                            .foregroundColor(.white)
                                            .padding(.top)
                                        
                                        Text("--")
                                            .font(.custom("Inter-Regular_Bold", size: 32))
                                            .foregroundColor(.white)
                                            .padding(.top)
                                        
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                        .padding(.vertical, 4)
                    }
                    .background(
                        Rectangle()
                            .fill(.white)
                            .frame(width: UIScreen.main.bounds.width,
                                   height: 220)
                    )
                    .padding(.top)
                }
                
                ForEach(loadingViewModel.postItemsMain, id: \.id) { postsBlock in
                    if postsBlock.category.postsStyle == .large {
                        LazyVStack {
                            ForEach(postsBlock.posts, id: \.title) { post in
                                NavigationLink(destination: DetailsArticleView(postItem: post)
                                    .environmentObject(loadingViewModel)
                                    .environmentObject(favorites)
                                    .navigationBarBackButtonHidden()) {
                                    BasePostItem(post: post) { post in
                                        favorites.toggleSavedPost(post: post)
                                    }
                                    .environmentObject(favorites)
                                }
                            }
                        }
                    } else if postsBlock.category.postsStyle == .hotTopic {
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
                                    ForEach(postsBlock.posts, id: \.title) { post in
                                        let sessionId = UserDefaults.standard.string(forKey: "session_id") ?? ""
                                        if post.article_link != nil && !sessionId.isEmpty {
                                            Button {
                                                let full = post.article_link!.replacingOccurrences(of: "{session_id}", with: sessionId)
                                                if let url = URL(string: full) {
                                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                }
                                            } label: {
                                                PostItemSmall(post: post)
                                            }
                                        } else {
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
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(
                            Rectangle()
                                .fill(.white)
                        )
                        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
                    } else if postsBlock.category.postsStyle == .small {
                        VStack {
                            HStack {
                                Text("Most viewed")
                                    .font(.custom("Inter-Regular_Bold", size: 24))
                                    .foregroundColor(.black)
                                    .padding(.top)
                                Spacer()
                            }
                            
                            LazyVGrid(columns: [
                                GridItem(.adaptive(minimum: 170, maximum: 250)),
                                GridItem(.adaptive(minimum: 170, maximum: 250))
                            ]) {
                                ForEach(postsBlock.posts, id: \.title) { post in
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func currentDateFormatted() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: currentDate)
    }
    
}

#Preview {
    HomeView()
        .environmentObject(LoadingViewModel())
        .environmentObject(FavoritePostsViewModel())
        .environmentObject(LocationManager())
}
