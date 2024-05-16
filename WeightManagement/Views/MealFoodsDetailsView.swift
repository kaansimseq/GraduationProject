//
//  MealFoodsDetailsView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 3.05.2024.
//

import SwiftUI
import Charts

struct MealFoodsDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let totalNutritionalValues: (Double, Double, Double)
    let mealTitle: String
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                // Pie Chart
                Chart {
                    SectorMark(angle: .value("Carbs", totalNutritionalValues.0), innerRadius: .ratio(0.5), angularInset: 1)
                        .cornerRadius(6)
                        .foregroundStyle(.orange)
                    SectorMark(angle: .value("Protein", totalNutritionalValues.1), innerRadius: .ratio(0.5), angularInset: 1)
                        .cornerRadius(6)
                        .foregroundStyle(.red)
                    SectorMark(angle: .value("Fat", totalNutritionalValues.2), innerRadius: .ratio(0.5), angularInset: 1)
                        .cornerRadius(6)
                        .foregroundStyle(.yellow)
                }
                .frame(width: 200, height: 200)
                .padding()
                
                VStack {
                    // Title
                    Text("\(mealTitle)\nTotal Nutrition Details")
                        .font(.title3)
                        .bold()
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Divider()
                    
                    VStack {
                        // Carbs
                        HStack {
                            Image(systemName: "c.circle")
                                .foregroundColor(.orange)
                            Text("Carbs")
                            Spacer()
                            Text("\(String(format: "%.2f", totalNutritionalValues.0)) g")
                        }
                        // Protein
                        HStack {
                            Image(systemName: "p.circle")
                                .foregroundColor(.red)
                            Text("Protein")
                            Spacer()
                            Text("\(String(format: "%.2f", totalNutritionalValues.1)) g")
                        }
                        // Fat
                        HStack {
                            Image(systemName: "f.circle")
                                .foregroundColor(.yellow)
                            Text("Fat")
                            Spacer()
                            Text("\(String(format: "%.2f", totalNutritionalValues.2)) g")
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
            
            .navigationBarTitle("Details", displayMode: .inline)
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
    MealFoodsDetailsView(totalNutritionalValues: (0.0, 0.0, 0.0), mealTitle: "")
}
