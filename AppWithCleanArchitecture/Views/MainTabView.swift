import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Products")
            }
            .tag(0)
            
            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favorites")
            }
            .tag(1)
            
            NavigationStack {
                AddProductView()
            }
            .tabItem {
                Image(systemName: "plus.circle.fill")
                Text("Add")
            }
            .tag(2)
            
            NavigationStack {
                CartView(selectedTab: $selectedTab)
            }
            .tabItem {
                Image(systemName: "cart.fill")
                Text("Cart")
            }
            .tag(3)
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            .tag(4)
        }
    }
} 