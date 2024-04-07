//
//  ForgotPswView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 23.03.2024.
//

import SwiftUI
import FirebaseAuth

struct ForgotPswView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email: String = ""
    
    
    var body: some View {
        
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                //Info Text
                HStack {
                    Text("Enter the email linked to your account, and\n we will send you a link to reset\n your password.")
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                //Email
                HStack {
                    Image(systemName: "mail")
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .padding()
                .padding(.top, -20)
                
                    .adaptsToKeyboard()
                
                //Request the Link Button
                Button {
                    
                    //Show warning if email field is empty
                    if email.isEmpty {
                        showAlert(title: "Email Required!", message: "Please enter your email")
                        return
                    }
                    
                    //Send password reset connection request via FirebaseAuth
                    Auth.auth().sendPasswordReset(withEmail: email) { error in
                        if let error = error {
                            print(error.localizedDescription)
                            showAlert(title: "Password Reset Error!", message: error.localizedDescription)
                            return
                        }
                        
                        //Password reset link sent successfully
                        showAlert(title: "Password Reset", message: "Password reset email has been sent to your email address")
                    }
                    
                } label: {
                    Text("Request the Link")
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
                
                .padding(.bottom, 30)
                
            }
            .navigationBarTitle("Forgot Password", displayMode: .inline)
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
    ForgotPswView()
}
