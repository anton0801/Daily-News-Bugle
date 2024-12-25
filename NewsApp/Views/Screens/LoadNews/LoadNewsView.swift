import SwiftUI

struct LoadNewsView: View {
    
    @StateObject private var locationManager = LocationManager()
    @StateObject var loadingViewModel = LoadingViewModel()
    @State var newsLoaded = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                Image("logo_2")
                ZStack(alignment: .leading) {
                    Rectangle()
                        .stroke(.white)
                        .frame(width: 200, height: 15)
                    Rectangle()
                        .fill(.white)
                        .frame(width: 195 * CGFloat(Double(loadingViewModel.loadingProgress) / 100.0), height: 10)
                        .offset(x: 2.5)
                }
                
                if loadingViewModel.loadingProgress == 100 {
                    Text("").onAppear {
                        newsLoaded = true
                    }
                    
                }
                
                NavigationLink(destination: LoadedTransferer()
                    .environmentObject(loadingViewModel)
                    .environmentObject(locationManager)
                    .navigationBarBackButtonHidden(), isActive: $newsLoaded) {
                    
                }
                
                if let location = locationManager.location {
                   Text("")
                        .onAppear {
                            loadingViewModel.fetchCityName(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
                        }
                }
            }
            .background(
                Rectangle()
                    .fill(Color.init(red: 240/255, green: 44/255, blue: 0))
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
            .onAppear {
                locationManager.locationManager.requestWhenInUseAuthorization()
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("conversion_loaded"))) { notificationData in
                if let info = notificationData.userInfo as? [String: Any],
                   let data = info["data"] as? [AnyHashable: Any] {
                    loadingViewModel.operateDataConversion(data: data)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    LoadNewsView()
}
