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
            
            /*
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
             }*/
            
            TabView {
                
                DiaryView()
                    .tabItem {
                        Image(systemName: "chart.bar.doc.horizontal")
                        Text("Diary")
                    }
                SuggestionView()
                    .tabItem {
                        Image(systemName: "fork.knife.circle")
                        Text("Suggestion")
                    }
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text("Profile")
                    }
                
            }
            .accentColor(.white)
            .onAppear() {
                UITabBar.appearance().backgroundColor = .lightGray
            }
            
            
            
            
            .navigationBarBackButtonHidden(true)
            
        }
        
        
    }
}

#Preview {
    HomeView()
}
