import SwiftUI

struct CountriesListView: View {
    
    @Environment(\.presentationMode) var presMode
    
    var countries = [
        "Canada", "Germany", "Mexico", "France", "Russia", "Italy"
    ]
    
    var countryCodes: [String: String] = [
        "Canada": "ca",
        "Germany": "de",
        "Mexico": "mx",
        "France": "fr",
        "Russia": "ru",
        "Italy": "it"
    ]
    
    @State var userCountry: String = ""
    var fromInitial = false
    var selectedCallback: () -> Void = { }
    
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var loadingVm: LoadingViewModel
    
    var body: some View {
        VStack {
            HStack {
                if !fromInitial {
                    Button {
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("back")
                    }
                }
                Text("Country")
                    .font(.custom("Inter-Regular_Bold", size: 26))
                    .foregroundColor(Color.init(red: 240/255, green: 44/255, blue: 0))
                    .padding(.leading, 4)
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
            
            VStack {
                ForEach(countries, id: \.self) { country in
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            userCountry = country
                        }
                    } label: {
                        ZStack {
                            if userCountry == country {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.init(red: 1, green: 49/255, blue: 49/255))
                                    .frame(height: 60)
                            } else {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.init(red: 182/255, green: 178/255, blue: 178/255))
                                    .frame(height: 60)
                            }
                            
                            HStack(spacing: 16) {
                                Image(country)
                                    .resizable()
                                    .frame(width: 32, height: 24)
                                Text(country)
                                    .font(.custom("Inter-Regular_Bold", size: 20))
                                    .foregroundColor(userCountry == country ? .white : .black)
                                    .padding(.leading, 4)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
            .background(
                Rectangle()
                    .fill(.white)
            )
            .padding(.top)
            .onChange(of: userCountry) { newValue in
                UserDefaults.standard.set(newValue, forKey: "user_country")
                if fromInitial {
                    if !userCountry.isEmpty && userCountry != UserDefaults.standard.string(forKey: "user_country") {
                        selectedCallback()
                    }
                }
                loadingVm.sortPostItemsByCountry()
            }
            
            Spacer()
        }
        .onAppear {
            if !fromInitial {
                userCountry = UserDefaults.standard.string(forKey: "user_country") ?? ""
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
}

#Preview {
    CountriesListView()
}
