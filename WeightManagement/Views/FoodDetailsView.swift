//
//  FoodDetailsView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 30.04.2024.
//

import SwiftUI
import Firebase

struct FoodDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var detailsFood: UserViewModel.Food
    
    // Delete Food Function
    func deleteFoodFromDatabase() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currentUser.uid).collection("foods").document(detailsFood.foodID)
        
        docRef.delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack() {
                
                VStack {
                    // Food Name
                    Text(detailsFood.foodName)
                        .font(.title3)
                        .bold()
                        .padding()
                    
                    Divider()
                    
                    VStack {
                        // Carbs
                        HStack {
                            Image(systemName: "c.circle")
                            Text("Carbs")
                            Spacer()
                            Text("\(detailsFood.carbs) g")
                        }
                        // Protein
                        HStack {
                            Image(systemName: "p.circle")
                            Text("Protein")
                            Spacer()
                            Text("\(detailsFood.protein) g")
                        }
                        // Fat
                        HStack {
                            Image(systemName: "f.circle")
                            Text("Fat")
                            Spacer()
                            Text("\(detailsFood.fat) g")
                        }
                    }
                    .padding()
                    
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.gray.opacity(0.2))
                )
                .padding()
                
                // Delete Button
                Button(action: {
                    
                    deleteFoodFromDatabase()
                    
                }) {
                    Text("Delete")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
                
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
    FoodDetailsView(detailsFood: UserViewModel.Food(foodID: "", foodName: "", amount: "", calories: "", carbs: "", protein: "", fat: "", date: Date()))
}
