//
//  SignupInfo.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 26.03.2024.
//

import SwiftUI

struct SignupInfo: View {
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Spacer()
                
                //SignupInfo Text
                HStack {
                    Text("We need some basic info to better\n support you in achieving your goals.")
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                //Got it, start! Button
                NavigationLink(destination: SignupView()) {
                    Text("Got it, start!")
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
                
                .padding(.bottom, 25)
                
                //Already have an acoount? Login Button
                NavigationLink(destination: LoginView()) {
                    Text("Already have an acoount? Login")
                        .foregroundColor(.black.opacity(0.7))
                        .italic()
                }
                .navigationBarTitle("Sign up", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                
                Spacer()
                
            }
        }
        
        
    }
}

#Preview {
    SignupInfo()
}
