//
//  DiaryView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 8.04.2024.
//

import SwiftUI
import FirebaseAuth

struct DiaryView: View {
    
    @ObservedObject private var viewModel = UserViewModel()
    @State private var birthdate = Date()
    
    init() {
        // Get the UID when the user logs in.
        if let currentUser = Auth.auth().currentUser {
            let userUID = currentUser.uid
            viewModel.fetchDataUsers(forUID: userUID)
            viewModel.fetchDataProperties(forUID: userUID)
            viewModel.fetchDataGoals(forUID: userUID)
        }
    }
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                DatePicker("Hi \(viewModel.name) 👋", selection: $birthdate, in: ...Date(), displayedComponents: .date)
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top, 30)
                
                //Spacer()
                
                // Circular Progress Bar
                VStack {
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                            .frame(width: 150, height: 150)
                        
                        Circle()
                            .trim(from: 0.6, to: 1.0) // Değiştirilebilir: 0.0 (sıfır) ile 1.0 (bir) arasında bir değer
                            .stroke(Color.blue, lineWidth: 10)
                            .frame(width: 150, height: 150)
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            Text("3000")
                                .font(.title)
                            Text("Calories left")
                                .foregroundColor(.gray)
                            
                            Button(action: {
                                // Detail butonuna basıldığında yapılacak işlemler
                            }) {
                                Text("Detail")
                                    .foregroundColor(.black)
                                    .bold()
                                    .italic()
                            }
                            .padding(.top, 5)
                        }
                        
                    }
                    
                    //Spacer()
                }
                .padding(.top, 40)
                .padding(.bottom, 40)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        if viewModel.mealFree != "" {
                            let selectedMeal = "Calories"
                            VStack {
                                VStack(alignment: .leading) {
                                    Text("Calories")
                                        .font(.title2)
                                        .bold()
                                        .padding(.horizontal)
                                    
                                    Divider()
                                    
                                    HStack {
                                        Text("Eaten")
                                        Spacer()
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(.blue)
                                            .bold()
                                        Spacer()
                                        Text("98 kcal")
                                        Spacer()
                                        Spacer()
                                        Spacer()
                                        
                                        NavigationLink(destination: MealDetailsView()) {
                                            Image(systemName: "arrow.right.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.blue)
                                                .bold()
                                        }
                                    }
                                    .padding(.top)
                                    .padding(.horizontal)
                                    .padding(.bottom, 2)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                                .padding()
                                .frame(width: UIScreen.main.bounds.width)
                            }
                        }
                        
                        ForEach(viewModel.mealBased, id: \.self) { meal in
                            let selectedMeal = meal
                            VStack {
                                VStack(alignment: .leading) {
                                    Text(meal)
                                        .font(.title2)
                                        .bold()
                                        .padding(.horizontal)
                                    
                                    Divider()
                                    
                                    HStack {
                                        Text("Eaten")
                                        Spacer()
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(.blue)
                                            .bold()
                                        Spacer()
                                        Text("98 kcal")
                                        Spacer()
                                        Spacer()
                                        Spacer()
                                        NavigationLink(destination: MealDetailsView()) {
                                            Image(systemName: "arrow.right.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.blue)
                                                .bold()
                                        }
                                    }
                                    .padding(.top)
                                    .padding(.horizontal)
                                    .padding(.bottom, 2)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                                .padding()
                                .frame(width: UIScreen.main.bounds.width)
                            }
                        }
                    }
                }
                
                
                
                Spacer()
            }
            
        }
        
    }
}

#Preview {
    DiaryView()
}
