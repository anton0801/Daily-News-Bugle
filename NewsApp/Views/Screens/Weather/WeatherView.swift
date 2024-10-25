import SwiftUI
import SDWebImageSwiftUI
import WebKit

struct WeatherView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var loadingViewModel: LoadingViewModel
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    Button {
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("back")
                    }
                    Text("Weather")
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
                
                let weatherData = loadingViewModel.weatherData
                if let weatherData = weatherData {
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
                                } placeholder: {
                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                                        .fill(.gray)
                                        .frame(height: 60)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                    .padding(.vertical, 10)
                    .background(
                        Rectangle()
                            .fill(.white)
                            .frame(width: UIScreen.main.bounds.width)
                    )
                    .padding(.top)
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
                    
                    // MARK: FORECASTS
                    VStack {
                        HStack {
                            Text("Today")
                                .font(.custom("Inter-Regular_Medium", size: 15))
                                .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
                            
                            WebImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherData.weather.first?.icon ?? "")@2x.png")) { image in
                                image.resizable()
                                    .frame(width: 42, height: 42)
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.gray)
                                    .frame(width: 42, height: 42)
                            }
                            
                            Spacer()
                            
                            
                            Text("\(weatherData.main.temp_min.formatDouble(0))°C")
                                .font(.custom("Inter-Regular_Medium", size: 12))
                                .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
                            
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(
                                    LinearGradient(colors: [
                                        Color.init(red: 166/255, green: 1, blue: 0),
                                        Color.init(red: 1, green: 132/255, blue: 17/255),
                                    ], startPoint: .leading, endPoint: .trailing)
                                )
                                .frame(width: 50, height: 10)
                            
                            Text("\(weatherData.main.temp_max.formatDouble(0))°C")
                                .font(.custom("Inter-Regular_Medium", size: 12))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(
                        Rectangle()
                            .fill(.white)
                            .frame(width: UIScreen.main.bounds.width)
                    )
                    .padding(.top)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 0)
                    
                    VStack(alignment: .leading) {
                        Text("Rainfall")
                            .font(.custom("Inter-Regular_Bold", size: 18))
                            .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
                        
                        RainMapWebView(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0, zoom: 1)
                            .frame(height: 250)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(
                        Rectangle()
                            .fill(.white)
                            .frame(width: UIScreen.main.bounds.width)
                    )
                    .padding(.top)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 0)
                    
                    VStack(alignment: .leading) {
                        Text("Wind")
                            .font(.custom("Inter-Regular_Bold", size: 18))
                            .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
                            .padding(.horizontal)
                        
                        HStack {
                            VStack {
                                HStack(spacing: 16) {
                                    Text("\(weatherData.wind.speed.formatDouble(0))")
                                        .font(.custom("Inter-Regular_Bold", size: 20))
                                        .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
                                    
                                    VStack {
                                        Text("MPH")
                                            .font(.custom("Inter-Regular_Medium", size: 16))
                                            .foregroundColor(Color.init(red: 182/255, green: 178/255, blue: 178/255))
                                        Text("Speed")
                                            .font(.custom("Inter-Regular_Medium", size: 12))
                                            .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
                                    }
                                }
                                HStack(spacing: 16) {
                                    Text("\((weatherData.wind.gust ?? 0.0).formatDouble(0))")
                                        .font(.custom("Inter-Regular_Bold", size: 20))
                                        .foregroundColor(.black)
                                    
                                    VStack {
                                        Text("m/s")
                                            .font(.custom("Inter-Regular_Medium", size: 16))
                                            .foregroundColor(Color.init(red: 182/255, green: 178/255, blue: 178/255))
                                        Text("Gust")
                                            .font(.custom("Inter-Regular_Medium", size: 14))
                                            .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            WindCompassView(windDirection: Double(weatherData.wind.deg), windSpeed: weatherData.wind.speed, windGust: weatherData.wind.gust ?? 0.0)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 10)
                    .background(
                        Rectangle()
                            .fill(.white)
                            .frame(width: UIScreen.main.bounds.width)
                    )
                    .padding(.top)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 0)
                    
                    HStack(spacing: 28) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Feels like")
                                .font(.custom("Inter-Regular_Bold", size: 18))
                                .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
                                .padding(.top, 6)
                            
                            Text("\(weatherData.main.temp.formatDouble(0))°C")
                                .font(.custom("Inter-Regular_Bold", size: 20))
                                .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
                                .padding(.top, 10)
                            
                            Text("some desc")
                                .font(.custom("Inter-Regular_Medium", size: 15))
                                .padding(.top, 8)
                                .opacity(0)
                            
                            HStack {
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            Color.white
                        )
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 0)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Visibility")
                                .font(.custom("Inter-Regular_Bold", size: 18))
                                .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
                                .padding(.top, 6)
                            
                            Text("\(weatherData.visibility / 1000)km")
                                .font(.custom("Inter-Regular_Bold", size: 20))
                                .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
                                .padding(.top, 10)
                            
                            Text("some desc")
                                .font(.custom("Inter-Regular_Medium", size: 15))
                                .padding(.top, 8)
                                .opacity(0)
                            
                            HStack {
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            Color.white
                        )
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 0)
                    }
                    .padding(.top)
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

    private func currentDateFormatted() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: currentDate)
    }
    
}

#Preview {
    WeatherView()
        .environmentObject(LocationManager())
        .environmentObject(LoadingViewModel())
}

struct RainMapWebView: UIViewRepresentable {
    
    var latitude: Double
    var longitude: Double
    var zoom: Int

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = makeRainMapURL() {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = makeRainMapURL() {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    private func makeRainMapURL() -> URL? {
        let urlString = "https://www.rainviewer.com/map.html?loc=\(latitude),\(longitude),\(zoom)"
        return URL(string: urlString)
    }
    
}

struct WindCompassView: View {
    var windDirection: Double
    var windSpeed: Double
    var windGust: Double

    var directionText: String {
        switch windDirection {
        case 337.5...360, 0..<22.5:
            return "North"
        case 22.5..<67.5:
            return "North-East"
        case 67.5..<112.5:
            return "East"
        case 112.5..<157.5:
            return "South-East"
        case 157.5..<202.5:
            return "South"
        case 202.5..<247.5:
            return "South-West"
        case 247.5..<292.5:
            return "West"
        case 292.5..<337.5:
            return "North-West"
        default:
            return "Unknown"
        }
    }

    var body: some View {
        ZStack {
            Image("compas")
                .resizable()
                .frame(width: 150, height: 150)
            Image("compas_indicator")
                .resizable()
                .frame(width: 7, height: 100)
                .rotationEffect(.degrees(windDirection))
            Text("\(directionText)")
                .font(.custom("Inter-Regular_Medium", size: 18))
                .foregroundColor(Color.init(red: 83/255, green: 82/255, blue: 82/255))
        }
    }
}
