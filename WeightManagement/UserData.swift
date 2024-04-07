//
//  UserData.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 26.03.2024.
//

import Foundation


struct UserData {
    //SignupView
    var name: String?
    var email: String?
    var password: String?
    //YourBasicsView
    var gender: Gender?
    var age: Int?
    var weight: Double?
    var height: Int?
    //GoalRecomView
    var goalWeight: Double?
    var GLWeightText: String?
    var KGWeekText: Double?
    var weekText: Int?
    //CalorieTrackRoutineView
    var mealFreeTitle: String?
    var selectedMealOptions: [String]?
}

class UserDataStore: ObservableObject {
    @Published var userData = UserData()
}
