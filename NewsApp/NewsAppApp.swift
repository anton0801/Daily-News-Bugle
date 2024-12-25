import SwiftUI

@main
struct NewsAppApp: App {
    
    @UIApplicationDelegateAdaptor(DailyNewsBugleAppDelegate.self) var dailyNewsBugleAppDelegate
    
    var body: some Scene {
        WindowGroup {
            LoadNewsView()
        }
    }
}
