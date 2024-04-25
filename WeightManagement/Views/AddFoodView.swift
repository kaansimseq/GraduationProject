//
//  AddFoodView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 23.04.2024.
//

import SwiftUI

struct AddFoodView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var searchText: String = ""
    
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
                    // Search Icon
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading)
                    
                    // Search Textfield
                    TextField("Search", text: $searchText)
                        .padding(.vertical, 10)
                }
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
                
            }
            
            .navigationBarBackButtonHidden(true)
        }
        
    }
}

#Preview {
    AddFoodView()
}
