//
//  DiaryView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 8.04.2024.
//

import SwiftUI
import FirebaseAuth

struct DiaryView: View {
    
    @ObservedObject private var viewModel = UserViewModel()
    @State private var calendar = Date()
    
    init() {
        // Get the UID when the user logs in.
        if let currentUser = Auth.auth().currentUser {
            let userUID = currentUser.uid
            viewModel.fetchDataUsers(forUID: userUID)
            viewModel.fetchDataProperties(forUID: userUID)
            viewModel.fetchDataGoals(forUID: userUID)
        }
    }
    
    // Calculate Daily Calorie
    func calculateDailyCalorie() -> Double? {
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
            
            dailyCalorie = (dailyCalorie ?? 0.0) - viewModel.totalCalories
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
            
            dailyCalorie = (dailyCalorie ?? 0.0) - viewModel.totalCalories
        }
        
        return dailyCalorie
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
                
                // Date Picker
                DatePicker("Hi \(viewModel.name) 👋", selection: $calendar, in: ...Date(), displayedComponents: .date)
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top, 30)
                
                HStack {
                    Spacer()
                    // Daily Min Calorie Text
                    VStack {
                        Text("\(String(format: "%.0f", calculateDailyMinCalorie() ?? 0.0))")
                            .font(.headline)
                        Text("DailyMin")
                            .font(.footnote)
                            .italic()
                    }
                    Spacer()
                    VStack {
                        ZStack {
                            
                            // Circular Bar
                            Circle()
                                .stroke(calculateDailyCalorie() ?? 0.0 <= 0.0 ? Color.red : Color.green, lineWidth: 10)
                                .frame(width: 150, height: 150)
                            
                            // Daily Calorie Text
                            VStack {
                                Text(String(format: "%.0f", abs(calculateDailyCalorie() ?? 0.0)))
                                    .font(.title)
                                    .onAppear {
                                        viewModel.fetchTotalCaloriesFromFirebase()
                                    }
                                
                                // Calories over / Calories left Text
                                Text(calculateDailyCalorie() ?? 0.0 <= 0.0 ? "Calories over" : "Calories left")
                                    .foregroundColor(.gray)
                                
                                // Detail Button
                                NavigationLink(destination: DetailView()) {
                                    Text("Detail")
                                        .foregroundColor(.black)
                                        .bold()
                                        .italic()
                                }
                                .padding(.top, 5)
                            }
                            
                        }
                        
                    }
                    Spacer()
                    // Total Calorie Text
                    VStack {
                        Text("\(String(format: "%.0f", viewModel.totalCalories))")
                            .font(.headline)
                            .onAppear {
                                viewModel.fetchTotalCaloriesFromFirebase()
                            }
                        Text("Eaten")
                            .font(.footnote)
                            .italic()
                    }
                    Spacer()
                }
                .padding(.top, 40)
                .padding(.bottom, 40)
                
                ScrollView(.vertical) {
                    VStack(spacing: -20) {
                        if viewModel.mealFree != "" {
                            let selectedMeal = "Calories"
                            VStack {
                                VStack(alignment: .leading) {
                                    Text("Calories")
                                        .font(.title2)
                                        .bold()
                                        .padding(.horizontal)
                                    
                                    Divider()
                                    
                                    HStack {
                                        Text("Eaten")
                                        Spacer()
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(.blue)
                                            .bold()
                                        Spacer()
                                        Text("\(String(format: "%.0f", viewModel.totalCalories)) kcal")
                                            .onAppear {
                                                viewModel.fetchTotalCaloriesFromFirebase()
                                            }
                                        Spacer()
                                        Spacer()
                                        Spacer()
                                        NavigationLink(destination: MealDetailsView(mealTitle: selectedMeal)) {
                                            Image(systemName: "arrow.right.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.blue)
                                                .bold()
                                        }
                                    }
                                    .padding(.top)
                                    .padding(.horizontal)
                                    .padding(.bottom, 2)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                                .padding()
                                .frame(width: UIScreen.main.bounds.width)
                            }
                        }
                        
                        ForEach(viewModel.mealBased, id: \.self) { meal in
                            let totalCalories = viewModel.totalCaloriesForMealTitles[meal] ?? 0.0
                            VStack {
                                VStack(alignment: .leading) {
                                    Text(meal)
                                        .font(.title2)
                                        .bold()
                                        .padding(.horizontal)
                                    
                                    Divider()
                                    
                                    HStack {
                                        Text("Eaten")
                                        Spacer()
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(.blue)
                                            .bold()
                                        Spacer()
                                        Text("\(String(format: "%.0f", totalCalories)) kcal")
                                            .onAppear {
                                                viewModel.fetchTotalCaloriesForMealTitle(mealTitle: meal)
                                            }
                                        Spacer()
                                        Spacer()
                                        Spacer()
                                        NavigationLink(destination: MealDetailsView(mealTitle: meal)) {
                                            Image(systemName: "arrow.right.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.blue)
                                                .bold()
                                        }
                                    }
                                    .padding(.top)
                                    .padding(.horizontal)
                                    .padding(.bottom, 2)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                                .padding()
                                .frame(width: UIScreen.main.bounds.width)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            
        }
        
    }
}

#Preview {
    DiaryView()
}
