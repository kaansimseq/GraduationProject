//
//  YourBasicsView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 26.03.2024.
//

import SwiftUI

struct YourBasicsView: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var userDataStore: UserDataStore
    @State private var selectedGender: Gender?
    @State private var age = ""
    @State private var weight = ""
    @State private var height = ""
    
    @State private var isNextViewActive = false
    
    //Age Valid Func
    private func isAgeValid(_ text: String) -> Bool {
        if let age = Int(text), (13...99).contains(age) {
            return true
        } else {
            return false
        }
    }
    
    //Weight Valid Func
    private func isWeightValid(_ text: String) -> Bool {
        // Virgülü noktaya dönüştürerek standardize et
        let standardizedText = text.replacingOccurrences(of: ",", with: ".")
        
        if let weight = Double(standardizedText), (41...224).contains(weight) {
            return true
        } else {
            return false
        }
    }
    
    //Height Valid Func
    private func isHeightValid(_ text: String) -> Bool {
        if let height = Int(text), (52...299).contains(height) {
            return true
        } else {
            return false
        }
    }
    
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                //Male - Female Button
                HStack {
                    Button(action: {
                        selectedGender = .male
                    }) {
                        Text("Male")
                            .foregroundColor(selectedGender == .male ? .white : .black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedGender == .male ? Color.black : Color.gray)
                            .cornerRadius(8)
                    }
                    .padding(.leading, 40)
                    
                    Button(action: {
                        selectedGender = .female
                    }) {
                        Text("Female")
                            .foregroundColor(selectedGender == .female ? .white : .black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedGender == .female ? Color.black : Color.gray)
                            .cornerRadius(8)
                    }
                    .padding(.trailing, 40)
                }
                .padding(.top, 20)
                
                //Age
                HStack {
                    Image(systemName: "person")
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                    
                    Spacer()
                    
                    if !age.isEmpty {
                        if isAgeValid(age) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .padding(.horizontal)
                .padding(.top)
                
                //Weight
                HStack {
                    Image(systemName: "person")
                    TextField("Weight", text: $weight)
                        .keyboardType(.decimalPad)
                        .onChange(of: weight) { newValue in
                            //Convert comma to dot.
                            if newValue.contains(",") {
                                weight = newValue.replacingOccurrences(of: ",", with: ".")
                            }
                        }
                    
                    Spacer()
                    
                    if !weight.isEmpty {
                        if isWeightValid(weight) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Text("KG")
                        .bold()
                        .italic()
                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .padding(.horizontal)
                .padding(.top)
                
                //Height
                HStack {
                    Image(systemName: "person")
                    TextField("Height", text: $height)
                        .keyboardType(.numberPad)
                    
                    Spacer()
                   
                    if !height.isEmpty {
                        if isHeightValid(height) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Text("CM")
                        .bold()
                        .italic()
                    
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
                
                //Next Button
                Button {
                    
                    guard let selectedGender = selectedGender else {
                        showAlert(title: "Gender Not Selected!", message: "Please select your gender")
                        return
                    }
                    if age.isEmpty {
                        showAlert(title: "Age Required!", message: "Please enter your age")
                        return
                    }
                    if weight.isEmpty {
                        showAlert(title: "Weight Required!", message: "Please enter your weight")
                        return
                    }
                    if height.isEmpty {
                        showAlert(title: "Height Required!", message: "Please enter your height")
                        return
                    }
                    
                    if !isAgeValid(age) {
                        showAlert(title: "Invalid Age!", message: "Please enter a valid age between 13 and 99")
                        return
                    }
                    if !isWeightValid(weight) {
                        showAlert(title: "Invalid Weight!", message: "Please enter a valid weight between 41 and 224")
                        return
                    }
                    if !isHeightValid(height) {
                        showAlert(title: "Invalid Height!", message: "Please enter a valid height between 52 and 299")
                        return
                    }
                    
                    
                    //Assign data to the model object
                    userDataStore.userData.gender = selectedGender
                    userDataStore.userData.age = Int(age)
                    userDataStore.userData.weight = Double(weight)
                    userDataStore.userData.height = Int(height)
                    
                    //Transition to GoalRecomView
                    isNextViewActive = true
                    
                } label: {
                    Text("Next")
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
                .padding(.bottom)
                NavigationLink(destination: GoalRecomView(), isActive: $isNextViewActive) {
                    EmptyView()
                }
            }
            .navigationBarTitle("Your Basics", displayMode: .inline)
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

enum Gender: String {
    case male = "Male"
    case female = "Female"
}

#Preview {
    YourBasicsView()
        .environmentObject(UserDataStore())
}
