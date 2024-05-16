//
//  WeightManagementApp.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 19.03.2024.
//

import SwiftUI
import FirebaseCore

@main
struct WeightManagementApp: App {
    
    let userDataStore = UserDataStore()
    
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(userDataStore)
        }
    }
}
