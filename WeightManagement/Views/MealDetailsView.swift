//
//  MealDetailsView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 23.04.2024.
//

import SwiftUI
import FirebaseAuth

struct MealDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var viewModel = UserViewModel()
    
    //let mealTitle: String
    
    init() {
        // Get the UID when the user logs in.
        if let currentUser = Auth.auth().currentUser {
            let userUID = currentUser.uid
            viewModel.fetchDataFoods(forUID: userUID)
            viewModel.listenForDataChanges()
        }
    }
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Title
                HStack {
                    Text("mealTitle")
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Information
                HStack {
                    Text("Eaten")
                    Spacer()
                    Image(systemName: "arrow.right")
                        .foregroundColor(.blue)
                        .bold()
                    Spacer()
                    Text("98kcal")
                    Spacer()
                    Spacer()
                    Spacer()
                    NavigationLink(destination: WelcomeView()) {
                        Text("Details")
                            .foregroundColor(.blue)
                            .bold()
                            .italic()
                    }
                }
                .padding()
                
                Divider()
                
                Spacer()
                
                ScrollView {
                    ForEach(viewModel.foods, id: \.foodName) { food in
                        VStack(alignment: .leading) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(food.foodName)
                                        .font(.headline)
                                    
                                    HStack {
                                        Image(systemName: "fork.knife")
                                        Text("\(food.amount) gr")
                                        Image(systemName: "flame.fill")
                                        Text("\(food.calories) kcal")
                                        Spacer()
                                        NavigationLink(destination: FoodDetailsView(detailsFood: food)) {
                                            Image(systemName: "arrow.right.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.blue)
                                                .bold()
                                        }
                                    }
                                    .font(.subheadline)
                                    
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
                
                NavigationLink(destination: AddFoodView()) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                    Text("Add Food")
                        .foregroundColor(.blue)
                        .bold()
                }
                
                
            }
            .padding()
            
            .navigationBarBackButtonHidden(true)
        }
        
    }
}

#Preview {
    MealDetailsView()
}
