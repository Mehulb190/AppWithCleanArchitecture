import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        List {
            Button(action: {
                authViewModel.logout()
            }) {
                Text("Logout")
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Settings")
    }
} 
