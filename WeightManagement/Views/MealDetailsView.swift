//
//  MealDetailsView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 23.04.2024.
//

import SwiftUI

struct MealDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let mealTitle: String
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Title
                HStack {
                    Text(mealTitle)
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
                    VStack {
                        HStack {
                            Text("Food 1")
                                .padding(.horizontal)
                                .padding(.top, 10)
                            Spacer()
                        }
                        HStack {
                            Text("Food 2")
                                .padding(.horizontal)
                                .padding(.top, 10)
                            Spacer()
                        }
                        //Diğer Yemekler
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
    MealDetailsView(mealTitle: "")
}
