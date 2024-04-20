//
//  AccountInfoView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 18.04.2024.
//

import SwiftUI
import FirebaseAuth

struct AccountInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var viewModel = UserViewModel()
    
    init() {
        if let currentUser = Auth.auth().currentUser {
            let userUID = currentUser.uid
            viewModel.fetchDataUsers(forUID: userUID)
        }
    }
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                // Name
                HStack {
                    Text("Name")
                        .frame(width: 100, height: 50, alignment: .leading)
                        .padding(.leading)
                    Spacer()
                    Text(viewModel.name)
                        .padding(.trailing)
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Email
                HStack {
                    Text("Email")
                        .frame(width: 100, height: 50, alignment: .leading)
                        .padding(.leading)
                    Spacer()
                    Text(viewModel.email)
                        .padding(.trailing)
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer().frame(height: 520)
            }
            .padding(.top)
            
            .navigationBarTitle("Account Info", displayMode: .inline)
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
    AccountInfoView()
}
