//
//  HomeView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 23.03.2024.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @State private var isPresentedWelcomeView = false
    
    var body: some View {
        
        ZStack {
            
            VStack {
                Text("You are logged in!")
                Button("Sign Out") {
                    // Firebase'den oturumu kapat
                    do {
                        try Auth.auth().signOut()
                        self.isPresentedWelcomeView = true
                    } catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError)
                        // Hata durumunda kullanıcıya bir hata mesajı gösterebilirsiniz
                    }
                }
                .fullScreenCover(isPresented: $isPresentedWelcomeView) {
                    WelcomeView()
                }
            }
            .navigationBarBackButtonHidden(true)
            
        }
        
    }
}

#Preview {
    HomeView()
}
