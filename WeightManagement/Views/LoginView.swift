//
//  LoginView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 19.03.2024.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State var visible = false
    @State private var isNextViewActive = false
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Spacer(minLength: 30)
                
                //Email
                HStack {
                    Image(systemName: "mail")
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                    
                    
                    Spacer()
                    
                    if(email.count != 0) {
                        Image(systemName: email.isValidEmail() ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .fontWeight(.bold)
                            .foregroundColor(email.isValidEmail() ? .green : .red)
                    }
                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .padding()
                
                //Password
                HStack {
                    Image(systemName: "lock")
                    
                    if self.visible {
                        TextField("Password", text: self.$password)
                            .autocapitalization(.none)
                    }
                    else {
                        SecureField("Password", text: $password)
                            .autocapitalization(.none)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        
                        self.visible.toggle()
                        
                    }) {
                        Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.black)
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .padding()
                
                //Forgot Password
                NavigationLink(destination: ForgotPswView()) {
                    Text("Forgot your password?")
                        .foregroundColor(.black.opacity(0.7))
                        .italic()
                }
                
                Spacer()
                    .adaptsToKeyboard()
                
                //Login button
                Button {
                    
                    //Check if the email and password fields are empty
                    if email.isEmpty {
                        showAlert(title: "Email Required!", message: "Please enter your email")
                        return
                    }
                    
                    if password.isEmpty {
                        showAlert(title: "Password Required!", message: "Please enter your password")
                        return
                    }
                    
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print(error.localizedDescription)
                            showAlert(title: "Login Error!", message: error.localizedDescription)
                            return
                        }
                        
                        isNextViewActive = true
                        
                    }
                    
                } label: {
                    Text("Login")
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
                NavigationLink(destination: HomeView(), isActive: $isNextViewActive) {
                    EmptyView()
                }
                
                Spacer(minLength: 25)
                
                //Don't have an account? Sign up Button
                NavigationLink(destination: SignupInfoView()) {
                    Text("Don't have an account? Sign up")
                        .foregroundColor(.black.opacity(0.7))
                        .italic()
                }
                
                Spacer(minLength: 20)
            }
            .navigationBarTitle("Login", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            
        }
        
        
    }
}


#Preview {
    LoginView()
}

