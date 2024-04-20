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
    @State private var progress: CGFloat = 0.0 // Progress değeri (0.0 - 1.0 aralığında)
    @State private var showingLogoutConfirmation = false
    
    init() {
        //Kullanıcı oturum açtığında UID'yi al.
        if let currentUser = Auth.auth().currentUser {
            let userUID = currentUser.uid
            viewModel.fetchDataUsers(forUID: userUID)
            viewModel.fetchDataProperties(forUID: userUID)
            viewModel.fetchDataGoals(forUID: userUID)
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut() // Firebase Authentication'tan çıkış yap
            // Eğer çıkış başarılı olduysa, WelcomeView sayfasına git
            // AppDelegate üzerinden Window değişkenine erişerek sayfayı değiştirebiliriz
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: WelcomeView())
                window.makeKeyAndVisible()
            }
        } catch {
            // Hata durumunda burada işlem yapabiliriz, örneğin bir hata mesajı gösterebiliriz
            print("Logout error: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack(spacing: 20) {
                    PhotosPicker(selection: $photosPickerItem, matching: .images) {
                        Image(uiImage: avatarImage ?? UIImage(named: "defaultAvatar")!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 110, height: 110)
                            .clipShape(.circle)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("viewModel.name")
                            .font(.largeTitle.bold())
                    }
                    
                    Spacer()
                    
                }
                
                //Spacer()
                
                // Gri kutu
                VStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.gray.opacity(0.3))
                        .frame(height: 250) // Yüksekliği artırıldı
                        .overlay(
                            VStack(spacing: 20) { // Vertical Stack içindeki spacing artırıldı
                                HStack() {
                                    Spacer()
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
                                        VStack(alignment: .leading) {
                                            Text("Start")
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                            Text("\(viewModel.startWeight, specifier: "%.1f") kg")
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        VStack(alignment: .trailing) {
                                            Text("Goal")
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                            Text("\(String(viewModel.goalWeight)) kg")
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    //Bar
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(Color.blue.opacity(0.3))
                                                .frame(width: geometry.size.width, height: 20)
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.blue)
                                                .frame(width: max(min(progress * geometry.size.width, geometry.size.width), 0), height: 20)
                                                .animation(.linear(duration: 0.5)) // Animasyon eklendi
                                        }
                                    }
                                    .frame(height: 20)
                                }
                                .padding(.horizontal)
                                
                                HStack {
                                    // - Button
                                    Button(action: {
                                        if viewModel.weight > viewModel.startWeight { // Minimum ağırlık sınırlaması
                                            viewModel.weight -= 0.1
                                            if viewModel.weight <= viewModel.startWeight {
                                                // Eğer ağırlık başlangıç değerine eşit veya başlangıç değerinden düşükse, azaltmayı durdur
                                                viewModel.weight = viewModel.startWeight
                                            }
                                            let targetProgress = CGFloat(viewModel.weight / viewModel.goalWeight)
                                            withAnimation(Animation.linear(duration: 0.1)) { // 0.1 saniyede yavaş yavaş dolması için animasyon
                                                progress = min(progress - 0.01, targetProgress) // Barı hedefe doğru yavaşça azalt
                                            }
                                        }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                    }
                                    .font(.title)
                                    .foregroundColor(viewModel.weight > viewModel.startWeight ? .red : .gray)
                                    .disabled(viewModel.weight <= viewModel.startWeight) // Eğer ağırlık başlangıç değerine ulaştıysa - butonu devre dışı bırakılır
                                    
                                    // + Button
                                    Button(action: {
                                        if viewModel.weight < viewModel.goalWeight { // Maksimum ağırlık sınırlaması
                                            viewModel.weight += 0.1
                                            if viewModel.weight >= viewModel.goalWeight {
                                                // Eğer ağırlık hedefe eşit veya hedefin üzerinde ise, artışı durdur
                                                viewModel.weight = viewModel.goalWeight
                                            }
                                            let targetProgress = CGFloat(viewModel.weight / viewModel.goalWeight)
                                            withAnimation(Animation.linear(duration: 0.1)) { // 0.1 saniyede yavaş yavaş dolması için animasyon
                                                progress = min(progress + 0.01, targetProgress) // Barı hedefe doğru yavaşça artır
                                            }
                                        }
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                    }
                                    .font(.title)
                                    .foregroundColor(viewModel.weight < viewModel.goalWeight ? .green : .gray)
                                    .disabled(viewModel.weight >= viewModel.goalWeight) // Eğer ağırlık hedefe ulaştıysa + butonu devre dışı bırakılır
                                }
                            }
                                .padding(.vertical, 20) // Vertical padding eklendi
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
                    
                    // Logout onayı iste
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
                            logout() // Logout basılırsa logout işlemini gerçekleştir
                        },
                        secondaryButton: .cancel(Text("Cancel")) // Cancel basılırsa hiçbir işlem yapma
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
