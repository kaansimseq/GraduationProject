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
    
    private var uid: String = ""
    
    init() {
        // Get the UID when the user logs in.
        if let currentUser = Auth.auth().currentUser {
            uid = currentUser.uid
            fetchDataFoods(forUID: uid)
            listenForDataChanges()
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
    
    //Fetch data from Foods
    func fetchDataFoods(forUID uid: String) {
        db.collection("users").document(uid).collection("foods").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            var foods: [Food] = [] // Yiyeceklerin listesi
            
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            
            for document in documents {
                let data = document.data()
                
                let food = Food(
                    foodID: document.documentID,
                    foodName: data["foodName"] as? String ?? "",
                    amount: data["amount"] as? String ?? "",
                    calories: data["calories"] as? String ?? "",
                    carbs: data["carbs"] as? String ?? "",
                    protein: data["protein"] as? String ?? "",
                    fat: data["fat"] as? String ?? ""
                )
                foods.append(food) // Her bir yiyeceği listeye ekle
            }
            
            DispatchQueue.main.async {
                self.foods = foods
            }
        }
    }
    
    func listenForDataChanges() {
        db.collection("users").document(uid).collection("foods").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                if diff.type == .added {
                    print("New food: \(diff.document.data())")
                    // Yeni bir yiyecek eklendiğinde, foods array'ini güncelleyin
                    self.fetchDataFoods(forUID: self.uid)
                }
                if diff.type == .modified {
                    print("Modified food: \(diff.document.data())")
                    // Bir yiyecek değiştirildiğinde, foods array'ini güncelleyin
                    self.fetchDataFoods(forUID: self.uid)
                }
                if diff.type == .removed {
                    print("Removed food: \(diff.document.data())")
                    // Bir yiyecek silindiğinde, foods array'ini güncelleyin
                    self.fetchDataFoods(forUID: self.uid)
                }
            }
        }
    }
    
    
}
