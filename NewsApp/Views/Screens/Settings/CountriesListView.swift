import SwiftUI

struct CountriesListView: View {
    
    @Environment(\.presentationMode) var presMode
    
    var countries = [
        "Canada", "Germany", "Mexico", "France", "Russia", "Italy"
    ]
    
    @State var userCountry: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("back")
                }
                Text("Settings")
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
            
            Spacer()
        }
        .onAppear {
            userCountry = UserDefaults.standard.string(forKey: "user_country") ?? ""
        }
        .onChange(of: userCountry) { newValue in
            UserDefaults.standard.set(userCountry, forKey: "user_country")
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
