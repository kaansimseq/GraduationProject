//
//  AddFoodView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 23.04.2024.
//

import SwiftUI
import CommonCrypto

struct AddFoodView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel = ViewModel()
    
    @State private var mealTitle: String
    
    init(mealTitle: String) {
        self._mealTitle = State(initialValue: mealTitle)
    }
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    // Add Food Title
                    Text("Add Food")
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    // Exit Button
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                            .padding(.trailing, 10)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 15)
                
                HStack {
                    // Textfield
                    HStack {
                        // Search Icon
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading)
                        
                        // Search Textfield
                        TextField("Search", text: $viewModel.searchText)
                            .padding(.vertical, 10)
                    }
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                    
                    // Search Button
                    Button(action: {
                        
                        viewModel.fetchSearchResults()
                        
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.blue)
                            .bold()
                            .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                ScrollView {
                    ForEach(viewModel.foodItems, id: \.self) { food in
                        VStack(alignment: .leading) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(food.foodName)
                                        .font(.headline)
                                    
                                    HStack {
                                        Image(systemName: "fork.knife")
                                        Text(food.servingDescription ?? "")
                                        Image(systemName: "flame.fill")
                                        Text("Calories: \(food.caloriesInfo ?? "")kcal")
                                        Spacer()
                                        NavigationLink(destination: AddFoodDetailsView(selectedFood: food, mealTitle: mealTitle)) {
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
                
            }
            .navigationBarBackButtonHidden(true)
        }
        
    }
}

#Preview {
    AddFoodView(mealTitle: "")
}
