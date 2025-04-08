//
//  AppWithCleanArchitectureApp.swift
//  AppWithCleanArchitecture
//
//  Created by Mehul Chauhan on 11/12/24.
//

import SwiftUI

@main
struct AppWithCleanArchitectureApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthViewModel())
        }
    }
}
