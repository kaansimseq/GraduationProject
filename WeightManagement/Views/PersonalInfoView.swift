//
//  PersonalInfoView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 18.04.2024.
//

import SwiftUI
import FirebaseAuth

struct PersonalInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var viewModel = UserViewModel()
    
    init() {
        if let currentUser = Auth.auth().currentUser {
            let userUID = currentUser.uid
            viewModel.fetchDataProperties(forUID: userUID)
        }
    }
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                // Weight
                HStack {
                    Text("Weight")
                        .frame(width: 100, height: 50, alignment: .leading)
                        .padding(.leading)
                    Spacer()
                    Text("\(String(viewModel.weight)) kg")
                        .padding(.trailing)
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Height
                HStack {
                    Text("Height")
                        .frame(width: 100, height: 50, alignment: .leading)
                        .padding(.leading)
                    Spacer()
                    Text("\(String(viewModel.height)) cm")
                        .padding(.trailing)
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Age
                HStack {
                    Text("Age")
                        .frame(width: 100, height: 50, alignment: .leading)
                        .padding(.leading)
                    Spacer()
                    Text(String(viewModel.age))
                        .padding(.trailing)
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Gender
                HStack {
                    Text("Gender")
                        .frame(width: 100, height: 50, alignment: .leading)
                        .padding(.leading)
                    Spacer()
                    Text(viewModel.gender)
                        .padding(.trailing)
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer().frame(height: 400)
            }
            .padding(.top)
            
            .navigationBarTitle("Personal Info", displayMode: .inline)
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
    PersonalInfoView()
}
