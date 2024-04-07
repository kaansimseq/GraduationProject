//
//  CalorieTrackRoutineView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 29.03.2024.
//

import SwiftUI

struct CalorieTrackRoutineView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userDataStore: UserDataStore
    @State private var mealFreeTitle = "Meal-Free"
    @State private var selectedMealOptions: [String] = []
    
    @State private var isSelectedMealFree = false
    @State private var isSelectedMealBased = false
    @State private var isNextViewActive = false
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Meal-Free Box
                VStack(alignment: .leading) {
                    HStack {
                        Text(mealFreeTitle)
                            .foregroundColor(isSelectedMealFree ? .gray : .black)
                            .font(.headline)
                            .padding(.top, 10)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    Spacer()
                    Text("Ideal if you don't have a regular daily meal routine or want to log your calorie intake all at once")
                        .foregroundColor(.black)
                        .font(.footnote)
                        .italic()
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .frame(height: 90)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelectedMealFree ? Color.gray : Color.black, lineWidth: 2)
                )
                .onTapGesture {
                    isSelectedMealFree.toggle()
                    
                    if isSelectedMealFree {
                        isSelectedMealBased = false
                        selectedMealOptions.removeAll()
                    }
                }
                .padding()
                .padding(.top, 20)
                
                //OR
                HStack {
                    Rectangle()
                        .frame(width: 150, height: 2)
                        .foregroundColor(.black)
                    Text("or")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding(.vertical, 10)
                    Rectangle()
                        .frame(width: 150, height: 2)
                        .foregroundColor(.black)
                }
                
                // Meal-Based Box
                VStack(alignment: .leading) {
                    Text("Meal-Based")
                        .foregroundColor(isSelectedMealBased ? .gray : .black)
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding(.top, 10)
                        .padding(.leading, 10)
                    Text("Ideal if you want to track calories based on recommendations per meal")
                        .foregroundColor(.black)
                        .font(.footnote)
                        .italic()
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                    
                    ForEach(["Breakfast", "Morning Snack", "Lunch", "Afternoon Snack", "Dinner", "Evening Snack"], id: \.self) { mealOption in
                        Button(action: {
                            if selectedMealOptions.contains(mealOption) {
                                selectedMealOptions.removeAll(where: { $0 == mealOption })
                            } else {
                                selectedMealOptions.append(mealOption)
                            }
                            
                            isSelectedMealBased = !selectedMealOptions.isEmpty
                        }) {
                            HStack {
                                Text(mealOption)
                                Spacer()
                                if selectedMealOptions.contains(mealOption) {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 10)
                            .foregroundColor(.black)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .padding(.horizontal, 10)
                            .padding(.bottom, 10)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelectedMealBased ? Color.gray : Color.black, lineWidth: 2)
                )
                .onTapGesture {
                    isSelectedMealBased.toggle()
                    
                    if isSelectedMealBased {
                        isSelectedMealFree = false
                        selectedMealOptions = ["Breakfast", "Lunch", "Dinner"]
                    } else {
                        selectedMealOptions.removeAll()
                    }
                }
                .padding()
                
                Spacer()
                
                //Next Button
                Button {
                    
                    if !isSelectedMealFree && !isSelectedMealBased {
                        showAlert(title: "Choose Routine!", message: "Please choose your calorie tracking routine")
                        return
                    } else if isSelectedMealBased && selectedMealOptions.filter({ $0 == "Breakfast" || $0 == "Lunch" || $0 == "Dinner" }).count < 2 {
                        showAlert(title: "Choose Main Meals!", message: "Please choose at least 2 main meals")
                        return
                    } else {
                        
                        if isSelectedMealFree {
                            userDataStore.userData.mealFreeTitle = mealFreeTitle
                            userDataStore.userData.selectedMealOptions = []
                        } else if isSelectedMealBased {
                            userDataStore.userData.mealFreeTitle = ""
                            userDataStore.userData.selectedMealOptions = selectedMealOptions
                        }
                        
                        isNextViewActive = true
                    }
                    
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
                .padding(.bottom, 20)
                NavigationLink(destination: SignupView(), isActive: $isNextViewActive) {
                    EmptyView()
                }
                
                .navigationBarTitle("Calorie Tracking Routine", displayMode: .inline)
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
}

#Preview {
    CalorieTrackRoutineView()
        .environmentObject(UserDataStore())
}
