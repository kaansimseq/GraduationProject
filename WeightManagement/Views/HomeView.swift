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
            .accentColor(.orange)
            .onAppear() {
                UITabBar.appearance().backgroundColor = .darkGray
                UITabBar.appearance().unselectedItemTintColor = .white
            }
            
            .navigationBarBackButtonHidden(true)
            
        }
        
    }
}

#Preview {
    HomeView()
}
