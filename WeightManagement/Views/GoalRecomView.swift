//
//  GoalRecomView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 28.03.2024.
//

import SwiftUI

struct GoalRecomView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userDataStore: UserDataStore
    @State private var goalWeight = ""
    @State private var GLWeightText = ""
    @State private var KGWeekText = ""
    @State private var weekText = ""
    
    @State private var intensityValue: Double = 0.4
    @State private var isNextViewActive = false
    
    //GoalWeight Valid Func
    private func isGoalWeightValid(_ text: String) -> Bool {
        //Standardize by converting comma to dot
        let standardizedText = text.replacingOccurrences(of: ",", with: ".")
        
        if let weight = Double(standardizedText), (41...224).contains(weight) {
            return true
        } else {
            return false
        }
    }
    
    //Gain Weight - Lose Weight Text Func
    func determineGoalText() -> String {
        guard !goalWeight.isEmpty else {
            return ""
        }

        let goalWeight = Double(goalWeight) ?? 0
        let userWeight = userDataStore.userData.weight ?? 0

        if goalWeight < userWeight {
            return "Lose Weight"
        } else {
            return "Gain Weight"
        }
    }
    
    //kg/week Text Func
    func sliderValueText(_ value: Double) -> String {
        let text = String(format: "%.1f", value)
        return text
    }
    
    //A function to be called when the slider value changes
    func sliderValueChanged(_ value: Double) {
        KGWeekText = sliderValueText(value)
    }

    //Change slider range according to goal
    func intensityRangeForGoal() -> ClosedRange<Double> {
        if goalWeight.isEmpty {
            return 0...1
        } else {
            return Double(goalWeight) ?? 0 < (userDataStore.userData.weight ?? 0) ? 0.2...1 : 0.2...0.6
        }
    }
    
    //The difference between the user's weight and the goal weight
    func calculateWeightDifference() -> Double {
        let difference = Double(userDataStore.userData.weight ?? 0) - (Double(goalWeight) ?? 0)
        return abs(difference)
    }
    
    //Week calculation
    func calculateIntensity() -> Int {
        let difference = calculateWeightDifference()
        let result = Int(Double(difference) / intensityValue)
        return result
    }

    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                //Goal Weight
                HStack {
                    Image(systemName: "person")
                    TextField("Goal Weight", text: $goalWeight)
                        .keyboardType(.decimalPad)
                        .onChange(of: goalWeight) { newValue in
                            //Set the value of the Slider to 0.4 by default every time a new value is received
                            intensityValue = 0.4
                            //Convert comma to dot
                            if newValue.contains(",") {
                                goalWeight = newValue.replacingOccurrences(of: ",", with: ".")
                            }
                        }
                    
                    Spacer()
                    
                    if !goalWeight.isEmpty {
                        if isGoalWeightValid(goalWeight) {
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
                .padding(.top, 40)
                
                VStack {
                    //Set Your Plan Intensity Title
                    VStack(alignment: .leading, spacing: 25) {
                        Text("Set Your Plan Intensity")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        //Slider
                        Slider(value: $intensityValue, in: intensityRangeForGoal(), step: 0.1)
                            .accentColor(.black)
                            .onChange(of: intensityValue) { _ in
                                KGWeekText = sliderValueText(intensityValue)
                            }
                        
                        //Text fields where values are displayed.
                        VStack(alignment: .leading ,spacing: 5) {
                            Text("\(calculateIntensity()) Week")
                            HStack {
                                Text("\(determineGoalText()):")
                                Text("\(sliderValueText(intensityValue)) kg/week")
                            }
                        }
                        
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .opacity(!goalWeight.isEmpty && Double(goalWeight) != userDataStore.userData.weight ? 1 : 0)
                    
                    Spacer()
                }
                .padding()
                
                .adaptsToKeyboard()
                
                //Next Button
                Button {
                    
                    if goalWeight.isEmpty {
                        showAlert(title: "Goal Weight Required!", message: "Please enter your goal weight")
                        return
                    }
                    
                    if !isGoalWeightValid(goalWeight) {
                        showAlert(title: "Invalid Goal Weight!", message: "Please enter a valid age between 41 and 224")
                        return
                    }
                    
                    if Double(goalWeight) == userDataStore.userData.weight {
                        showAlert(title: "Invalid Goal Weight!", message: "Your weight and goal weight cannot be the same")
                        return
                    }
                    
                    GLWeightText = determineGoalText()
                    weekText = String(calculateIntensity())
                    
                    userDataStore.userData.goalWeight = Double(goalWeight)
                    userDataStore.userData.GLWeightText = GLWeightText
                    userDataStore.userData.KGWeekText = Double(KGWeekText)
                    userDataStore.userData.weekText = Int(weekText)
                    
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
                NavigationLink(destination: CalorieTrackRoutineView(), isActive: $isNextViewActive) {
                    EmptyView()
                }
            }
            .navigationBarTitle("Goal Recommendation", displayMode: .inline)
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
    GoalRecomView()
        .environmentObject(UserDataStore())
}
