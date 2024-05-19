//
//  UserViewModel.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 8.04.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserViewModel: ObservableObject {
    
    struct Food {
        var foodID: String
        var foodName: String
        var amount: String
        var calories: String
        var carbs: String
        var protein: String
        var fat: String
        var date: Date
    }
    
    //Users
    @Published var name: String = ""
    @Published var email: String = ""
    //Properties
    @Published var age: Int = 0
    @Published var gender: String = ""
    @Published var height: Int = 0
    @Published var weight: Double = 0.0
    @Published var startWeight: Double = 0.0
    //Goals
    @Published var GLWeight: String = ""
    @Published var goalWeight: Double = 0.0
    @Published var KGWeek: Double = 0.0
    @Published var mealBased: [String] = [""]
    @Published var mealFree: String = ""
    @Published var week: Int = 0
    //Foods
    @Published var foods: [Food] = []
    @Published var mealTitle: String = ""
    //Total
    @Published var totalCalories: Double = 0.0
    @Published var totalCaloriesForMealTitles: [String: Double] = [:]
    @Published var totalCaloriesForSelectedDate: Double = 0.0
    @Published var totalCarbs: Double = 0.0
    @Published var totalProtein: Double = 0.0
    @Published var totalFat: Double = 0.0
    
    private var uid: String = ""
    
    init() {
        // Get the UID when the user logs in.
        if let currentUser = Auth.auth().currentUser {
            uid = currentUser.uid
            fetchDataFoods(forUID: uid, mealTitle: mealTitle)
            listenForDataChanges(mealTitle: mealTitle)
        }
    }
    
    private var db = Firestore.firestore()
    
    //Fetch data from Users
    func fetchDataUsers(forUID uid: String) {
        db.collection("users").whereField("UID", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            
            if let document = documents.first {
                let data = document.data()
                
                self.name = data["Name"] as? String ?? ""
                self.email = data["Email"] as? String ?? ""
            }
            
        }
    }
    
    //Fetch data from Properties
    func fetchDataProperties(forUID uid: String) {
        db.collection("properties").whereField("UID", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            
            if let document = documents.first {
                let data = document.data()
                
                self.age = data["Age"] as? Int ?? 0
                self.gender = data["Gender"] as? String ?? ""
                self.height = data["Height"] as? Int ?? 0
                self.weight = data["Weight"] as? Double ?? 0.0
                self.startWeight = data["Weight"] as? Double ?? 0.0
            }
            
        }
    }
    
    //Fetch data from Goals
    func fetchDataGoals(forUID uid: String) {
        db.collection("goals").whereField("UID", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            
            if let document = documents.first {
                let data = document.data()
                
                self.GLWeight = data["Gain/Lose Weight"] as? String ?? ""
                self.goalWeight = data["Goal Weight"] as? Double ?? 0.0
                self.KGWeek = data["KG/Week"] as? Double ?? 0.0
                self.mealBased = data["Meal-Based"] as? [String] ?? [""]
                self.mealFree = data["Meal-Free"] as? String ?? ""
                self.week = data["Week"] as? Int ?? 0
            }
            
        }
    }
    
    //Fetch data from Foods filtered by mealTitle
    func fetchDataFoods(forUID uid: String, mealTitle: String) {
        db.collection("users").document(uid).collection("foods").whereField("mealTitle", isEqualTo: mealTitle).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            var foods: [Food] = []
            
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            
            for document in documents {
                let data = document.data()
                
                let timestamp = data["date"] as? Timestamp ?? Timestamp()
                let date = timestamp.dateValue() // Convert Timestamp to Date
                
                self.mealTitle = data["mealTitle"] as? String ?? ""
                
                let food = Food(
                    foodID: document.documentID,
                    foodName: data["foodName"] as? String ?? "",
                    amount: data["amount"] as? String ?? "",
                    calories: data["calories"] as? String ?? "",
                    carbs: data["carbs"] as? String ?? "",
                    protein: data["protein"] as? String ?? "",
                    fat: data["fat"] as? String ?? "",
                    date: date
                )
                foods.append(food)
            }
            
            DispatchQueue.main.async {
                self.foods = foods
            }
        }
    }
    
    // Listen Data Changes Function
    func listenForDataChanges(mealTitle: String) {
        db.collection("users").document(uid).collection("foods").whereField("mealTitle", isEqualTo: mealTitle).addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                if diff.type == .added {
                    print("New food: \(diff.document.data())")
                    // Update the foods array when a new food is added
                    self.fetchDataFoods(forUID: self.uid, mealTitle: mealTitle)
                }
                if diff.type == .modified {
                    print("Modified food: \(diff.document.data())")
                    // Update the foods array when a food is changed
                    self.fetchDataFoods(forUID: self.uid, mealTitle: mealTitle)
                }
                if diff.type == .removed {
                    print("Removed food: \(diff.document.data())")
                    // Update the foods array when a food is deleted
                    self.fetchDataFoods(forUID: self.uid, mealTitle: mealTitle)
                }
            }
        }
    }
    
    // Calculate total calories for selected date
    func fetchTotalCaloriesForSelectedDate(selectedDate: Date) {
        
        // Define start and end dates for the selected day
        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        db.collection("users").document(uid).collection("foods")
            .whereField("date", isGreaterThanOrEqualTo: startOfDay)
            .whereField("date", isLessThan: endOfDay)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                var totalCalories = 0.0
                
                guard let documents = querySnapshot?.documents else {
                    print("No Documents")
                    return
                }
                
                for document in documents {
                    let data = document.data()
                    if let calories = Double(data["calories"] as? String ?? "0.0") {
                        totalCalories += calories
                    }
                }
                
                // Update totalCalories for the selected date
                self.totalCalories = totalCalories
                
                print("Total calories for \(selectedDate): \(totalCalories)")
            }
    }
    
    // Calculate total calories for mealTitle and selected date
    func fetchTotalCaloriesForMealTitle(mealTitle: String, selectedDate: Date) {
        
        // Define start and end dates for the selected day
        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        print("Fetching documents for mealTitle: \(mealTitle) on date: \(selectedDate)")
        print("Start of day: \(startOfDay), End of day: \(endOfDay)")
        
        db.collection("users").document(uid).collection("foods")
            .whereField("mealTitle", isEqualTo: mealTitle)
            .whereField("date", isGreaterThanOrEqualTo: startOfDay)
            .whereField("date", isLessThan: endOfDay)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                var totalCalories = 0.0
                
                guard let documents = querySnapshot?.documents else {
                    print("No Documents")
                    return
                }
                
                for document in documents {
                    let data = document.data()
                    if let calories = Double(data["calories"] as? String ?? "0.0") {
                        totalCalories += calories
                    }
                    
                }
                
                DispatchQueue.main.async {
                    self.totalCaloriesForMealTitles[mealTitle] = totalCalories
                    print("Updated total calories for \(mealTitle): \(totalCalories)")
                }
            }
    }
    
    // Calculate total nutrition values for selected date
    func fetchTotalNutrientsForSelectedDate(selectedDate: Date) {
        
        // Define start and end dates for the selected day
        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        db.collection("users").document(uid).collection("foods")
            .whereField("date", isGreaterThanOrEqualTo: startOfDay)
            .whereField("date", isLessThan: endOfDay)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                var carbsSum = 0.0
                var proteinSum = 0.0
                var fatSum = 0.0
                
                guard let documents = querySnapshot?.documents else {
                    print("No Documents")
                    return
                }
                
                for document in documents {
                    let data = document.data()
                    if let carbsString = data["carbs"] as? String,
                       let proteinString = data["protein"] as? String,
                       let fatString = data["fat"] as? String,
                       let carbs = Double(carbsString),
                       let protein = Double(proteinString),
                       let fat = Double(fatString) {
                        carbsSum += carbs
                        proteinSum += protein
                        fatSum += fat
                    }
                }
                
                // Update totalCarbs, totalProtein, and totalFat for the selected date
                DispatchQueue.main.async {
                    self.totalCarbs = carbsSum
                    self.totalProtein = proteinSum
                    self.totalFat = fatSum
                }
            }
    }
    
}
