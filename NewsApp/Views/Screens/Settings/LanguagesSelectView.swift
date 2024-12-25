import SwiftUI

struct Language {
    var name: String
    var code: String
}

var languages = [
    Language(name: "English", code: "en"),
    Language(name: "Spainish", code: "es"),
    Language(name: "German", code: "de"),
    Language(name: "Italian", code: "it"),
    Language(name: "Japaneese", code: "ja"),
    Language(name: "Czech", code: "cs"),
]

struct LanguagesSelectView: View {
    
    @Environment(\.presentationMode) var presMode
    @Binding var currentLanguag: String
    var selectedLanguage: () -> Void
    
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var loadingVm: LoadingViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Language")
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
                ForEach(languages, id: \.name) { language in
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentLanguag = language.code
                            UserDefaults.standard.set(language.code, forKey: "current_language")
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.init(red: 182/255, green: 178/255, blue: 178/255))
                                .frame(height: 60)
                            
                            HStack(spacing: 16) {
                                Text(language.name)
                                    .font(.custom("Inter-Regular_Bold", size: 20))
                                    .foregroundColor(.black)
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
            
            Spacer()
        }
        .onAppear {
            currentLanguag = UserDefaults.standard.string(forKey: "current_language") ?? ""
            selectedLanguage()
            loadingVm.sortPostItemsByLanguage()
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
    LanguagesSelectView(currentLanguag: .constant("")) {
        
    }
}
