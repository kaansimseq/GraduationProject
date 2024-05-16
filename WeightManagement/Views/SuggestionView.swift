//
//  SuggestionView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 8.04.2024.
//

import SwiftUI
import FirebaseAuth

struct SuggestionView: View {
    
    @ObservedObject private var viewModel = UserViewModel()
    @ObservedObject var viewModell = ViewModel()
    @State private var randomRecipes: [ViewModel.Recipe] = []
    
    @State private var isLoading = false
    
    init() {
        // Get the UID when the user logs in.
        if let currentUser = Auth.auth().currentUser {
            let userUID = currentUser.uid
            viewModel.fetchDataUsers(forUID: userUID)
            viewModel.fetchDataProperties(forUID: userUID)
            viewModel.fetchDataGoals(forUID: userUID)
        }
    }
    
    // Calculate Food Total Calories
    func calculateTotalCalories() -> Double {
        var totalCalories = 0.0
        for recipe in randomRecipes {
            totalCalories += Double(recipe.servingSizes.serving.calories) ?? 0.0
        }
        return totalCalories
    }
    
    // What should I eat today Button Disabled Function
    var isButtonDisabled: Bool {
        guard let dailyMinCalorie = calculateDailyMinCalorie() else { return true }
        let totalCalories = calculateTotalCalories()
        return totalCalories >= dailyMinCalorie
    }
    
    // Number of Food Function
    func countRecipes() -> Int {
        return randomRecipes.count
    }
    
    // Calculate Dialy Min Calorie
    func calculateDailyMinCalorie() -> Double? {
        var dailyCalorie: Double?
        
        //Male
        if viewModel.gender == "Male" {
            let weightMale = viewModel.weight
            let heightMale = Double(viewModel.height)
            let ageMale = Double(viewModel.age)
            
            let maleBMR = (10 * weightMale) + (6.25 * heightMale) - (5 * ageMale) + 5
            dailyCalorie = maleBMR * 1.375
            
            let weightDifference = viewModel.goalWeight - viewModel.weight
            let totalCalorie = weightDifference * 7700
            let weeklyTotalCalorie = totalCalorie / Double(viewModel.week)
            let dailyTotalCalorie = weeklyTotalCalorie / 7
            
            dailyCalorie = (dailyCalorie ?? 0.0) + dailyTotalCalorie
            
        }
        //Female
        else {
            let weightFemale = viewModel.weight
            let heightFemale = Double(viewModel.height)
            let ageFemale = Double(viewModel.age)
            
            let femaleBMR = (10 * weightFemale) + (6.25 * heightFemale) - (5 * ageFemale) - 161
            dailyCalorie = femaleBMR * 1.375
            
            let weightDifference = viewModel.goalWeight - viewModel.weight
            let totalCalorie = weightDifference * 7700
            let weeklyTotalCalorie = totalCalorie / Double(viewModel.week)
            let dailyTotalCalorie = weeklyTotalCalorie / 7
            
            dailyCalorie = (dailyCalorie ?? 0.0) + dailyTotalCalorie
            
        }
        
        return dailyCalorie
    }
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                // Title
                Text("FOOD SUGGESTION")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 5)
                    .padding(.top, 30)
                
                Divider()
                    .padding(.horizontal)
                
                // Description
                Text("Food suggestions are based on the minimum daily calorie intake")
                    .font(.subheadline)
                    .italic()
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 5)
                
                // Daily Min Calorie Text
                Text("Daily Min Calorie: \(String(format: "%.0f", calculateDailyMinCalorie() ?? 0.0)) kcal")
                    .font(.subheadline)
                    .italic()
                
                // Total Calorie Text
                Text("Total Calorie: \(String(format: "%.0f", calculateTotalCalories())) kcal")
                    .font(.subheadline)
                    .italic()
                
                // Number of Food Text
                Text("Number of Food: \(countRecipes())")
                    .font(.subheadline)
                    .italic()
                
                Divider()
                    .padding(.horizontal)
                
                // Buttons
                HStack {
                    // What should I eat today Button
                    Button(action: {
                        
                        isLoading = true // Start loading when the button is clicked
                        viewModell.fetchRandomRecipe { result in
                            switch result {
                            case .success(let recipe):
                                randomRecipes.append(recipe)
                            case .failure(let error):
                                print("Error fetching random recipe: \(error)")
                            }
                            // End loading state after 0.5 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isLoading = false
                            }
                        }
                        
                    }) {
                        Text("What should I eat today")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isButtonDisabled ? Color.gray : Color.black)
                            .cornerRadius(10)
                            .bold()
                    }
                    .disabled(isButtonDisabled)
                    
                    // Clear Button
                    Button(action: {
                        
                        randomRecipes.removeAll()
                        
                    }) {
                        Text("Clear")
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .padding(.horizontal, 20)
                            .background(Color.black)
                            .cornerRadius(10)
                            .bold()
                    }
                }
                .padding()
                
                if isLoading {
                    // Loading Screen
                    ProgressView("Loading")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .padding()
                        .scaleEffect(1.3)
                } else {
                    ScrollView {
                        ForEach(randomRecipes, id: \.recipeName) { recipe in
                            VStack(alignment: .leading) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(recipe.recipeName)
                                            .font(.headline)
                                        
                                        HStack {
                                            Image(systemName: "fork.knife")
                                            Text("Per Portion \(recipe.gramsPerPortion) g")
                                            Image(systemName: "flame.fill")
                                            Text("\(recipe.servingSizes.serving.calories) kcal")
                                        }
                                        .font(.subheadline)
                                        .padding(.top, 5)
                                        .padding(.bottom, 5)
                                        
                                        HStack {
                                            Image(systemName: "c.circle.fill")
                                            Text("\(recipe.servingSizes.serving.carbohydrate) g")
                                            Image(systemName: "p.circle.fill")
                                            Text("\(recipe.servingSizes.serving.protein) g")
                                            Image(systemName: "f.circle.fill")
                                            Text("\(recipe.servingSizes.serving.fat) g")
                                        }
                                        .font(.subheadline)
                                        .padding(.bottom, 5)
                                        
                                        Text("Food Link")
                                            .font(.headline)
                                            .padding(.bottom, 5)
                                        
                                        Button(action: {
                                            
                                            // Open URL
                                            if let url = URL(string: recipe.recipeURL) {
                                                UIApplication.shared.open(url)
                                            }
                                            
                                        }) {
                                            Text(recipe.recipeURL)
                                                .font(.subheadline)
                                                .foregroundColor(.blue)
                                                .multilineTextAlignment(.leading)
                                        }
                                        
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
                
            }
            
        }
        
    }
}

#Preview {
    SuggestionView()
}
