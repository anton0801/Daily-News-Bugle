import SwiftUI

struct NotificationsView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Notifications")
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
            
            Spacer()
            
            Text("Notifications is empty!")
                .font(.custom("Inter-Regular_Bold", size: 28))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Text("When notifications come in they will be displayed in this section!")
                .font(.custom("Inter-Regular_Medium", size: 16))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 4)
            
            Spacer()
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
    NotificationsView()
}
