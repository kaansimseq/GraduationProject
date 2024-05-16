//
//  DetailView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 12.05.2024.
//

import SwiftUI
import Charts
import FirebaseAuth

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var viewModel = UserViewModel()
    
    init() {
        // Get the UID when the user logs in.
        if let currentUser = Auth.auth().currentUser {
            let userUID = currentUser.uid
            viewModel.fetchDataUsers(forUID: userUID)
            viewModel.fetchTotalNutrientsFromFirebase()
        }
    }
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                // Pie Chart
                Chart {
                    SectorMark(angle: .value("Carbs", viewModel.totalCarbs), innerRadius: .ratio(0.5), angularInset: 1)
                        .cornerRadius(6)
                        .foregroundStyle(.orange)
                    SectorMark(angle: .value("Protein", viewModel.totalProtein), innerRadius: .ratio(0.5), angularInset: 1)
                        .cornerRadius(6)
                        .foregroundStyle(.red)
                    SectorMark(angle: .value("Fat", viewModel.totalFat), innerRadius: .ratio(0.5), angularInset: 1)
                        .cornerRadius(6)
                        .foregroundStyle(.yellow)
                }
                .frame(width: 200, height: 200)
                .padding()
                
                // Title
                VStack {
                    Text("Daily Total Nutrition Details")
                        .font(.title3)
                        .bold()
                        .padding()
                    
                    Divider()
                    
                    VStack {
                        // Carbs
                        HStack {
                            Image(systemName: "c.circle")
                                .foregroundColor(.orange)
                            Text("Carbs")
                            Spacer()
                            Text("\(String(format: "%.2f", viewModel.totalCarbs)) g")
                        }
                        // Protein
                        HStack {
                            Image(systemName: "p.circle")
                                .foregroundColor(.red)
                            Text("Protein")
                            Spacer()
                            Text("\(String(format: "%.2f", viewModel.totalProtein)) g")
                        }
                        // Fat
                        HStack {
                            Image(systemName: "f.circle")
                                .foregroundColor(.yellow)
                            Text("Fat")
                            Spacer()
                            Text("\(String(format: "%.2f", viewModel.totalFat)) g")
                        }
                    }
                    .padding()
                    
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.gray.opacity(0.2))
                )
                .padding()
                
                Spacer()
            }
            
            .navigationBarTitle("Detail", displayMode: .inline)
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
    DetailView()
}
