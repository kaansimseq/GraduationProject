//
//  SignupView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 19.03.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignupView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userDataStore: UserDataStore
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State var visible = false
    @State private var isNextViewActive = false
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                //Name
                HStack {
                    Image(systemName: "person")
                    TextField("Name", text: $name)
                    
                    Spacer()
                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                
                .padding()
                
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
                
                .adaptsToKeyboard()
                Spacer()
                
                //Signup Button
                Button {
                    
                    //Check if the name, email and password fields are empty
                    if name.isEmpty {
                        showAlert(title: "Name Required!", message: "Please enter your name")
                        return
                    }
                    if email.isEmpty {
                        showAlert(title: "Email Required!", message: "Please enter your email")
                        return
                    }
                    
                    if password.isEmpty {
                        showAlert(title: "Password Required!", message: "Please enter your password")
                        return
                    }
                    
                    
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print(error.localizedDescription)
                            showAlert(title: "Sign up Error!", message: error.localizedDescription)
                            return
                        }
                        
                        guard let authResult = authResult else { return }
                        
                        // Save user data in separate collections
                        
                        let db = Firestore.firestore()
                        let usersCollection = db.collection("users")
                        let goalsCollection = db.collection("goals")
                        let propertiesCollection = db.collection("properties")
                        
                        // User data
                        let userData = [
                            "UID": authResult.user.uid,
                            "Name": name,
                            "Email": email,
                            "Password": password
                        ]
                        
                        // Save user data
                        usersCollection.document(authResult.user.uid).setData(userData) { error in
                            if let error = error {
                                print("Error adding user document: \(error)")
                            } else {
                                // Switch to HomeView screen
                                isNextViewActive = true
                            }
                        }
                        
                        // User properties data
                        let userProperties = [
                            "UID": authResult.user.uid,
                            "Name": name,
                            "Gender": userDataStore.userData.gender?.rawValue ?? "",
                            "Age": userDataStore.userData.age!,
                            "Weight": userDataStore.userData.weight!,
                            "Height": userDataStore.userData.height!
                        ]
                        
                        // Save user properties data
                        propertiesCollection.document(authResult.user.uid).setData(userProperties) { error in
                            if let error = error {
                                print("Error adding user properties document: \(error)")
                            }
                        }
                        
                        // User goals data
                        let userGoals = [
                            "UID": authResult.user.uid,
                            "Name": name,
                            "Goal Weight": userDataStore.userData.goalWeight!,
                            "Gain/Lose Weight": userDataStore.userData.GLWeightText!,
                            "KG/Week": userDataStore.userData.KGWeekText ?? "",
                            "Week": userDataStore.userData.weekText!,
                            "Meal-Free": userDataStore.userData.mealFreeTitle!,
                            "Meal-Based": userDataStore.userData.selectedMealOptions!
                        ]
                        
                        // Save user goals data
                        goalsCollection.document(authResult.user.uid).setData(userGoals) { error in
                            if let error = error {
                                print("Error adding user goals document: \(error)")
                            }
                        }
                    }
                    
                } label: {
                    Text("Sign up")
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
                
                Spacer(minLength: 20)
                
            }
            .navigationBarTitle("Sign up", displayMode: .inline)
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
    SignupView()
        .environmentObject(UserDataStore())
}
