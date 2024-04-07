//
//  WelcomeView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 21.03.2024.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        
        NavigationView {
            
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    //Title
                    Text("Fit and Healthy Life!")
                        .font(.largeTitle)
                        .bold()
                        .italic()
                        .padding(.bottom, 50)
                    
                    //Sign up and Start Button
                    NavigationLink(destination: SignupInfoView()) {
                        Text("Sign up and Start")
                            .foregroundColor(.white)
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black)
                            )
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 15)
                    
                    //Login Button
                    NavigationLink(destination: LoginView()) {
                        Text("Already have an account? Login")
                            .foregroundColor(.black.opacity(0.7))
                    }
                    
                    
                }
            }


        }
        
    }
}

#Preview {
    WelcomeView()
}
