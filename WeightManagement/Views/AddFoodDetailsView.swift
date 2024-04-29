//
//  AddFoodDetailsView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 28.04.2024.
//

import SwiftUI

struct AddFoodDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel = ViewModel()
    @State private var amount: String = ""
    var selectedFood: ViewModel.Food // Seçilen yiyecek
    
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
                        .keyboardType(.numberPad)
                    
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
                    
                    Text("\(selectedFood.caloriesInfo ?? "")kcal")
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
                            Text("\(selectedFood.carbsInfo ?? "") g")
                        }
                        HStack {
                            Image(systemName: "p.circle")
                            Text("Protein")
                            Spacer()
                            Text("\(selectedFood.proteinInfo ?? "") g")
                        }
                        HStack {
                            Image(systemName: "f.circle")
                            Text("Fat")
                            Spacer()
                            Text("\(selectedFood.fatInfo ?? "") g")
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
    AddFoodDetailsView(selectedFood: ViewModel.Food(foodDescription: "", foodID: "", foodName: "", foodURL: "", brandName: nil))
}
