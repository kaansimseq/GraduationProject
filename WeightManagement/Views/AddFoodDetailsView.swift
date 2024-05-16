//
//  AddFoodDetailsView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 28.04.2024.
//

import SwiftUI
import Firebase

struct AddFoodDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModell = UserViewModel()
    @ObservedObject var viewModel = ViewModel()
    
    @State private var amount: String = ""
    
    var selectedFood: ViewModel.Food
    var mealTitle: String
    
    init(selectedFood: ViewModel.Food, mealTitle: String) {
        self.selectedFood = selectedFood
        self.mealTitle = mealTitle
    }
    
    // Save food in a database Function
    func saveFoodToDatabase() {
        guard let currentUser = Auth.auth().currentUser else {
            // Stop the process if the user is not logged in
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)
        let foodsRef = userRef.collection("foods")
        
        // Save selected food data to Firestore
        foodsRef.addDocument(data: [
            "mealTitle": mealTitle,
            "foodName": selectedFood.foodName,
            "amount": amount,
            "calories": calculateCalories() ?? "",
            "carbs": calculateCarbs() ?? "",
            "protein": calculateProtein() ?? "",
            "fat": calculateFat() ?? ""
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
                // When the insertion is successful, close the page
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    // Calculate Calories Value
    func calculateCalories() -> String? {
        if let gramValue = Double(selectedFood.servingSizeNumeric ?? ""), let calorieValue = Double(selectedFood.caloriesInfo ?? ""), let enteredAmount = Double(amount) {
            // Calculate how many calories are in 1 gram of the selected food
            let caloriePerGram = calorieValue / gramValue
            
            // Calculate calories according to the amount entered
            let totalCalories = caloriePerGram * enteredAmount
            
            // Return result as string
            return String(format: "%.2f", totalCalories)
        }
        return nil
    }
    
    // Calculate Carbs Value
    func calculateCarbs() -> String? {
        if let gramValue = Double(selectedFood.servingSizeNumeric ?? ""), let carbsValue = Double(selectedFood.carbsInfo ?? ""), let enteredAmount = Double(amount) {
            // Calculate how many carbohydrates are in 1 gram of the selected food
            let carbsPerGram = carbsValue / gramValue
            
            // Calculate the carbohydrate according to the amount entered
            let totalCarbs = carbsPerGram * enteredAmount
            
            // Return result as string
            return String(format: "%.2f", totalCarbs)
        }
        return nil
    }
    
    // Calculate Protein Value
    func calculateProtein() -> String? {
        if let gramValue = Double(selectedFood.servingSizeNumeric ?? ""), let proteinValue = Double(selectedFood.proteinInfo ?? ""), let enteredAmount = Double(amount) {
            
            let proteinPerGram = proteinValue / gramValue
            
            let totalProtein = proteinPerGram * enteredAmount
            
            return String(format: "%.2f", totalProtein)
        }
        return nil
    }
    
    // Calculate Fat Value
    func calculateFat() -> String? {
        if let gramValue = Double(selectedFood.servingSizeNumeric ?? ""), let fatValue = Double(selectedFood.fatInfo ?? ""), let enteredAmount = Double(amount) {

            let fatPerGram = fatValue / gramValue
            
            let totalFat = fatPerGram * enteredAmount
            
            return String(format: "%.2f", totalFat)
        }
        return nil
    }
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Food Name Title
                HStack {
                    Text(selectedFood.foodName)
                        .font(.title)
                        .bold()
                        .padding(.leading, 30)
                    Spacer()
                }
                
                // Amount Textfield
                HStack {
                    Image(systemName: "g.square")
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .onChange(of: amount) { newValue in
                            //Convert comma to dot.
                            if newValue.contains(",") {
                                amount = newValue.replacingOccurrences(of: ",", with: ".")
                            }
                        }
                    
                    Spacer()
                    
                    Text("GR")
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
                .padding(.bottom)
                
                // Calories Box
                HStack() {
                    Text("Calories :")
                        .font(.headline)
                        .padding()
                                        
                    Text("\(calculateCalories() ?? "") kcal")
                        .font(.subheadline)
                        .padding()
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.gray.opacity(0.2))
                )
                .padding(.horizontal)
                
                // Nutrition Details
                VStack() {
                    Text("Nutrition Details")
                        .font(.headline)
                        .padding()
                    
                    Divider()
                    
                    VStack {
                        // Carbs
                        HStack {
                            Image(systemName: "c.circle")
                            Text("Carbs")
                            Spacer()
                            Text("\(calculateCarbs() ?? "") g")
                        }
                        // Protein
                        HStack {
                            Image(systemName: "p.circle")
                            Text("Protein")
                            Spacer()
                            Text("\(calculateProtein() ?? "") g")
                        }
                        // Fat
                        HStack {
                            Image(systemName: "f.circle")
                            Text("Fat")
                            Spacer()
                            Text("\(calculateFat() ?? "") g")
                        }
                    }
                    .padding()
                    
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.gray.opacity(0.2))
                )
                .padding()
                
                .adaptsToKeyboard()
                Spacer()
                
                // Add Button
                Button(action: {
                    
                    if amount.isEmpty {
                        showAlert(title: "Amount Required!", message: "Please enter amount")
                        return
                    }
                    
                    saveFoodToDatabase()
                    
                }) {
                    Text("Add")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding()
                
            }
            .navigationBarTitle("", displayMode: .inline)
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
    AddFoodDetailsView(selectedFood: ViewModel.Food(foodDescription: "", foodID: "", foodName: "", foodURL: "", brandName: nil), mealTitle: "")
}
