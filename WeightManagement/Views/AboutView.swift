//
//  AboutView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 18.04.2024.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // About App
                Text("About App")
                    .font(.title)
                    .bold()
                
                Text("The application calculates the amount of calories the user should consume daily with the information it receives from the user. It also recommends meals according to daily calories. In this way, it helps the user to gain or lose weight.")
                    .font(.body)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                Divider()
                
                // About Me
                Text("About Me")
                    .font(.title)
                    .bold()
                
                Text("My name is Kaan Şimşek. I am a senior student at Yeditepe University. I am developing myself in the field of mobile applications. This project is my graduation project.")
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                    .font(.body)
                
                Spacer().frame(height: 280)
            }
            .padding()
            
            .navigationBarTitle("About", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                                    Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .imageScale(.large)
                    .padding(.leading, 10)
                    .padding(.trailing, 5)
            })
            
        }
        
    }
}

#Preview {
    AboutView()
}
