import SwiftUI
import WebKit

struct SettingsView: View {
    
    @State var userCountry: String = ""
    
    @State var privacySheet = false
    @State var termsOfUseSheet = false
    @State var feedbackSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
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
                
                List {
                    Section(header: Text("APP PREFERENCES").font(.subheadline).foregroundColor(.gray)) {
                        NavigationLink(destination: CountriesListView()
                            .navigationBarBackButtonHidden()) {
                            HStack {
                                Text("Country:")
                                    .font(.custom("Inter-Regular_Medium", size: 16))
                                    .foregroundColor(.black)
                                Spacer()
                                Text("\(userCountry)")
                                    .font(.custom("Inter-Regular_Medium", size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Section(header: Text("GENERAL").font(.subheadline).foregroundColor(.gray)) {
                        Button {
                            privacySheet.toggle()
                        } label: {
                            HStack {
                                Text("Privacy Policy")
                                    .font(.custom("Inter-Regular_Medium", size: 16))
                                    .foregroundColor(.black)
                                Spacer()
                                Image("back")
                                    .resizable()
                                    .frame(width: 6, height: 10)
                                    .rotationEffect(.degrees(180))
                            }
                        }
                        
                        Button {
                            privacySheet.toggle()
                        } label: {
                            HStack {
                                Text("Terms of Use")
                                    .font(.custom("Inter-Regular_Medium", size: 16))
                                    .foregroundColor(.black)
                                Spacer()
                                Image("back")
                                    .resizable()
                                    .frame(width: 6, height: 10)
                                    .rotationEffect(.degrees(180))
                            }
                        }
                        Button {
                            privacySheet.toggle()
                        } label: {
                            HStack {
                                Text("Feedback")
                                    .font(.custom("Inter-Regular_Medium", size: 16))
                                    .foregroundColor(.black)
                                Spacer()
                                Image("back")
                                    .resizable()
                                    .frame(width: 6, height: 10)
                                    .rotationEffect(.degrees(180))
                            }
                        }
                    }
                }
                .listStyle(.grouped)
            }
            .background(
                Rectangle()
                    .fill(Color.init(red: 245/255, green: 248/255, blue: 253/255))
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
            .onAppear {
                userCountry = UserDefaults.standard.string(forKey: "user_country") ?? ""
            }
            .sheet(isPresented: $privacySheet) {
                PageViewerView(url: URL(string: "https://google.com")!)
            }
            .sheet(isPresented: $termsOfUseSheet) {
                PageViewerView(url: URL(string: "https://mail.ru")!)
            }
            .sheet(isPresented: $feedbackSheet) {
                PageViewerView(url: URL(string: "https://yandex.ru")!)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    SettingsView()
}

struct PageViewerView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
