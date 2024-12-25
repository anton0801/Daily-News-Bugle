import SwiftUI

struct LoadedTransferer: View {
    
    @State var currentLanguage: String = ""
    @State var userCountry: String = ""
    
    @EnvironmentObject var loadingVm: LoadingViewModel
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack {
            if currentLanguage.isEmpty {
                LanguagesSelectView(currentLanguag: $currentLanguage) {
                    //currentLanguage = UserDefaults.standard.string(forKey: "current_language") ?? ""
                }
                .environmentObject(loadingVm)
            } else if userCountry.isEmpty {
                CountriesListView(fromInitial: true) {
                    userCountry = UserDefaults.standard.string(forKey: "user_country") ?? ""
                }
                .environmentObject(loadingVm)
            } else {
                ContentView()
                    .environmentObject(loadingVm)
                    .environmentObject(locationManager)
            }
        }
        .onAppear {
            currentLanguage = UserDefaults.standard.string(forKey: "current_language") ?? ""
            userCountry = UserDefaults.standard.string(forKey: "user_country") ?? ""
        }
    }
}

#Preview {
    LoadedTransferer()
        .environmentObject(LoadingViewModel())
        .environmentObject(LocationManager())
}
