//
//  ProfileView.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 8.04.2024.
//

import SwiftUI
import PhotosUI
import FirebaseAuth

struct ProfileView: View {
    
    @State private var avatarImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    
    @ObservedObject private var viewModel = UserViewModel()
    @State private var progress: CGFloat = 0.0
    @State private var showingLogoutConfirmation = false
    
    init() {
        // Get the UID when the user logs in.
        if let currentUser = Auth.auth().currentUser {
            let userUID = currentUser.uid
            viewModel.fetchDataUsers(forUID: userUID)
            viewModel.fetchDataProperties(forUID: userUID)
            viewModel.fetchDataGoals(forUID: userUID)
        }
    }
    
    // Logout Function
    func logout() {
        do {
            try Auth.auth().signOut() // Logout of Firebase Authentication
            // If the exit was successful, go to the WelcomeView page
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: WelcomeView())
                window.makeKeyAndVisible()
            }
        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                // Profile Image
                HStack(spacing: 20) {
                    PhotosPicker(selection: $photosPickerItem, matching: .images) {
                        Image(uiImage: avatarImage ?? UIImage(named: "defaultAvatar")!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 110, height: 110)
                            .clipShape(.circle)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(viewModel.name)
                            .font(.largeTitle.bold())
                    }
                    
                    Spacer()
                    
                }
                
                Spacer()
                
                // Inside the Box
                VStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.gray.opacity(0.3))
                        .frame(height: 250) // Box height
                        .overlay(
                            VStack(spacing: 20) {
                                // Your Goal - Weight
                                HStack() {
                                    Spacer()
                                    // Your Goal
                                    VStack(alignment: .center, spacing: 8) {
                                        Text("Your Goal")
                                            .font(.title3)
                                            .bold()
                                        Text(viewModel.GLWeight)
                                            .font(.subheadline)
                                    }
                                    //.padding(.leading)
                                    Spacer()
                                    Divider()
                                    Spacer()
                                    // Weight
                                    VStack(alignment: .center, spacing: 8) {
                                        Text("Weight")
                                            .font(.title3)
                                            .bold()
                                        Text("\(viewModel.weight, specifier: "%.1f") kg")
                                            .font(.subheadline)
                                    }
                                    //.padding(.trailing)
                                    Spacer()
                                }
                                Divider()
                                //Start - Goal
                                VStack {
                                    HStack {
                                        // Start
                                        VStack(alignment: .leading) {
                                            Text("Start")
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                            Text("\(viewModel.startWeight, specifier: "%.1f") kg")
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        // Goal
                                        VStack(alignment: .trailing) {
                                            Text("Goal")
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                            Text("\(String(viewModel.goalWeight)) kg")
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    // Progress Bar
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(Color.blue.opacity(0.3))
                                                .frame(width: geometry.size.width, height: 20)
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.blue)
                                                .frame(width: max(min(progress * geometry.size.width, geometry.size.width), 0), height: 20)
                                                .animation(.linear(duration: 0.5))
                                        }
                                    }
                                    .frame(height: 20)
                                }
                                .padding(.horizontal)
                                
                                // Progress bar working status
                                if viewModel.GLWeight == "Gain Weight" {
                                    HStack {
                                        // - Button
                                        Button(action: {
                                            if viewModel.weight > viewModel.startWeight { // Minimum weight limitation
                                                viewModel.weight -= 0.1
                                                if viewModel.weight <= viewModel.startWeight {
                                                    // Stop reduction if weight is less than or equal to the initial value
                                                    viewModel.weight = viewModel.startWeight
                                                }
                                                let targetProgress = CGFloat(viewModel.weight / viewModel.goalWeight)
                                                withAnimation(Animation.linear(duration: 0.1)) { // 0.1 second animation to fill slowly
                                                    progress = min(progress - 0.01, targetProgress) // Slowly lower the bar towards the target
                                                }
                                            }
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                        }
                                        .font(.title)
                                        .foregroundColor(viewModel.weight > viewModel.startWeight ? .red : .gray)
                                        .disabled(viewModel.weight <= viewModel.startWeight) // If the weight has reached the initial value, the - button is deactivated
                                        
                                        // + Button
                                        Button(action: {
                                            if viewModel.weight < viewModel.goalWeight { // Maximum weight limitation
                                                viewModel.weight += 0.1
                                                if viewModel.weight >= viewModel.goalWeight {
                                                    // If the weight is equal to or above the target, stop the increment
                                                    viewModel.weight = viewModel.goalWeight
                                                }
                                                let targetProgress = CGFloat(viewModel.weight / viewModel.goalWeight)
                                                withAnimation(Animation.linear(duration: 0.1)) {
                                                    progress = min(progress + 0.01, targetProgress)
                                                }
                                            }
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                        }
                                        .font(.title)
                                        .foregroundColor(viewModel.weight < viewModel.goalWeight ? .green : .gray)
                                        .disabled(viewModel.weight >= viewModel.goalWeight) // If the weight has reached the target, the + button is deactivated
                                    }
                                }
                                else if viewModel.GLWeight == "Lose Weight" {
                                    HStack {
                                        // + Button
                                        Button(action: {
                                            if viewModel.weight < viewModel.startWeight {
                                                viewModel.weight += 0.1
                                                if viewModel.weight >= viewModel.startWeight {
                                                    viewModel.weight = viewModel.startWeight
                                                }
                                                let targetProgress = CGFloat(viewModel.weight / viewModel.goalWeight)
                                                withAnimation(Animation.linear(duration: 0.1)) {
                                                    progress = min(progress - 0.01, targetProgress)
                                                }
                                            }
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                        }
                                        .font(.title)
                                        .foregroundColor(viewModel.weight < viewModel.startWeight ? .red : .gray)
                                        .disabled(viewModel.weight >= viewModel.startWeight)
                                        
                                        // - Button
                                        Button(action: {
                                            if viewModel.weight > viewModel.goalWeight {
                                                viewModel.weight -= 0.1
                                                if viewModel.weight <= viewModel.goalWeight {
                                                    viewModel.weight = viewModel.goalWeight
                                                }
                                                let targetProgress = CGFloat(viewModel.weight / viewModel.goalWeight)
                                                withAnimation(Animation.linear(duration: 0.1)) {
                                                    progress = min(progress + 0.01, targetProgress)
                                                }
                                            }
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                        }
                                        .font(.title)
                                        .foregroundColor(viewModel.weight > viewModel.goalWeight ? .green : .gray)
                                        .disabled(viewModel.weight <= viewModel.goalWeight)
                                    }
                                }
                                
                            }
                                .padding(.vertical, 20)
                        )
                }
                .padding()
                
                Spacer()
                
                // Personal Info View
                NavigationLink(destination: PersonalInfoView()) {
                    HStack {
                        Text("Profile Info")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(10)
                    .italic()
                    .bold()
                }
                
                // Account Info View
                NavigationLink(destination: AccountInfoView()) {
                    HStack {
                        Text("Account Info")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(10)
                    .italic()
                    .bold()
                }
                
                // About View
                NavigationLink(destination: AboutView()) {
                    HStack {
                        Text("About")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(10)
                    .italic()
                    .bold()
                }
                
                // Logout Button
                Button(action: {
                    
                    showingLogoutConfirmation = true
                    
                }) {
                    Text("Logout")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showingLogoutConfirmation) {
                    Alert(
                        title: Text("Logout?"),
                        message: Text("Are you sure you want to logout your account?"),
                        primaryButton: .default(Text("Logout")) {
                            logout() // Perform the logout process
                        },
                        secondaryButton: .cancel(Text("Cancel")) // No action if Cancel is pressed
                    )
                }
                
                Spacer()
                
            }
            .padding()
            .onChange(of: photosPickerItem) { _, _ in
                Task {
                    if let photosPickerItem,
                       let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            avatarImage = image
                        }
                    }
                    photosPickerItem = nil
                }
            }
            
            
        }
        
    }
}

#Preview {
    ProfileView()
}
