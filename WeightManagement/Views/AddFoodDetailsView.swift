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
    
    var selectedFood: ViewModel.Food // Seçilen yiyecek
    
    var mealTitle: String
    
    init(selectedFood: ViewModel.Food, mealTitle: String) {
        self.selectedFood = selectedFood
        self.mealTitle = mealTitle
    }
    
    func saveFoodToDatabase() {
        guard let currentUser = Auth.auth().currentUser else {
            // Kullanıcı oturum açmamışsa işlemi durdur
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)
        let foodsRef = userRef.collection("foods")
        //let mealsRef = userRef.collection("meals").document(mealTitle).collection("foods") // Meal title'a göre meals altındaki collection'a erişim sağlanıyor
        
        // Seçilen yiyecek verilerini Firestore'a kaydet
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
                // Ekleme işlemi başarılı olduğunda, sayfayı kapat
                self.presentationMode.wrappedValue.dismiss()
                
                
            }
        }
    }
    
    func calculateCalories() -> String? {
        if let gramValue = Double(selectedFood.servingSizeNumeric ?? ""), let calorieValue = Double(selectedFood.caloriesInfo ?? ""), let enteredAmount = Double(amount) {
            // Seçilen yiyeceğin 1 gramında kaç kalori olduğunu hesaplayın
            let caloriePerGram = calorieValue / gramValue
            
            // Girilen miktara göre kaloriyi hesaplayın
            let totalCalories = caloriePerGram * enteredAmount
            
            // Sonucu string olarak dön
            return String(format: "%.2f", totalCalories)
        }
        return nil
    }
    
    func calculateProtein() -> String? {
        if let gramValue = Double(selectedFood.servingSizeNumeric ?? ""), let proteinValue = Double(selectedFood.proteinInfo ?? ""), let enteredAmount = Double(amount) {
            // Seçilen yiyeceğin 1 gramında kaç protein olduğunu hesaplayın
            let proteinPerGram = proteinValue / gramValue
            
            // Girilen miktara göre proteini hesaplayın
            let totalProtein = proteinPerGram * enteredAmount
            
            // Sonucu string olarak dön
            return String(format: "%.2f", totalProtein)
        }
        return nil
    }
    
    func calculateFat() -> String? {
        if let gramValue = Double(selectedFood.servingSizeNumeric ?? ""), let fatValue = Double(selectedFood.fatInfo ?? ""), let enteredAmount = Double(amount) {
            // Seçilen yiyeceğin 1 gramında kaç yağ olduğunu hesaplayın
            let fatPerGram = fatValue / gramValue
            
            // Girilen miktara göre yağı hesaplayın
            let totalFat = fatPerGram * enteredAmount
            
            // Sonucu string olarak dön
            return String(format: "%.2f", totalFat)
        }
        return nil
    }
    
    func calculateCarbs() -> String? {
        if let gramValue = Double(selectedFood.servingSizeNumeric ?? ""), let carbsValue = Double(selectedFood.carbsInfo ?? ""), let enteredAmount = Double(amount) {
            // Seçilen yiyeceğin 1 gramında kaç karbonhidrat olduğunu hesaplayın
            let carbsPerGram = carbsValue / gramValue
            
            // Girilen miktara göre karbonhidratı hesaplayın
            let totalCarbs = carbsPerGram * enteredAmount
            
            // Sonucu string olarak dön
            return String(format: "%.2f", totalCarbs)
        }
        return nil
    }
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Tittle
                HStack {
                    Text(selectedFood.foodName)
                        .font(.title)
                        .bold()
                        .padding(.leading, 30)
                    //.padding(.top, 30)
                    Spacer()
                }
                
                // Amount
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
                
                // Calorie Box
                HStack() {
                    Text("Calories :")
                        .font(.headline)
                        .padding()
                    
                    //Divider()
                    
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
                        HStack {
                            Image(systemName: "c.circle")
                            Text("Carbs")
                            Spacer()
                            Text("\(calculateCarbs() ?? "") g")
                        }
                        HStack {
                            Image(systemName: "p.circle")
                            Text("Protein")
                            Spacer()
                            Text("\(calculateProtein() ?? "") g")
                        }
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
