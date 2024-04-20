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
    
    
}
