import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var loadingViewModel: LoadingViewModel
    @EnvironmentObject var locationManager: LocationManager
    @State private var selectedTab = 0
    @StateObject var favorites: FavoritePostsViewModel = FavoritePostsViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            if selectedTab == 0 {
                HomeView()
                    .environmentObject(loadingViewModel)
                    .environmentObject(locationManager)
                    .environmentObject(favorites)
            } else if selectedTab == 1 {
                FavoritesPostsView()
                    .environmentObject(loadingViewModel)
                    .environmentObject(favorites)
            } else if selectedTab == 2 {
                NotificationsView()
            } else {
                SettingsView()
            }
            CustomTabView(selectedTab: $selectedTab)
        }
        .background(
            Rectangle()
                .fill(Color.init(red: 245/255, green: 248/255, blue: 253/255))
                .frame(minWidth: UIScreen.main.bounds.width,
                       minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
        .preferredColorScheme(.light)
        .edgesIgnoringSafeArea(.bottom)
    }
}


struct CustomTabView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            TabBarButton(icon: "house", title: "Home", index: 0, selectedTab: $selectedTab)
            TabBarButton(icon: "bookmark", title: "Saved", index: 1, selectedTab: $selectedTab)
            
            Spacer(minLength: 0)
            
            CentralTabButton()
            
            Spacer(minLength: 0)
            
            TabBarButton(icon: "bell", title: "Notifications", index: 2, selectedTab: $selectedTab)
            TabBarButton(icon: "person", title: "Settings", index: 3, selectedTab: $selectedTab)
        }
        .padding(8)
        .background(Color.red)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabBarButton: View {
    var icon: String
    var title: String
    var index: Int
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(selectedTab == index ? .white : .gray)
            Text(title)
                .font(.caption)
                .foregroundColor(selectedTab == index ? .white : .gray)
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .onTapGesture {
            selectedTab = index
        }
    }
}

struct CentralTabButton: View {
    var body: some View {
        Button(action: {
            NotificationCenter.default.post(name: Notification.Name("refresh_page"), object: nil)
        }) {
            Image(systemName: "arrow.2.circlepath")
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundColor(.red)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LoadingViewModel())
        .environmentObject(LocationManager())
}
