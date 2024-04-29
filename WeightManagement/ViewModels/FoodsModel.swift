//
//  FoodsModel.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 27.04.2024.
//

import Foundation

class ViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var selectedFood: Food?
    @Published var foodItems: [Food] = []
    
    struct FoodSearchResult: Codable {
        let foods: Foods
    }
    
    struct Foods: Codable {
        let food: [Food]
        let maxResults, pageNumber, totalResults: String
        
        enum CodingKeys: String, CodingKey {
            case food
            case maxResults = "max_results"
            case pageNumber = "page_number"
            case totalResults = "total_results"
        }
    }
    
    struct Food: Hashable, Codable {
        let foodDescription, foodID, foodName: String
        let foodURL: String
        let brandName: String?
        
        enum CodingKeys: String, CodingKey {
            case foodDescription = "food_description"
            case foodID = "food_id"
            case foodName = "food_name"
            case foodURL = "food_url"
            case brandName = "brand_name"
        }
        
        // Computed property to parse food description for serving description
        var servingDescription: String? {
            let components = foodDescription.components(separatedBy: " - ")
            if components.count >= 1 {
                return components[0]
            }
            return nil
        }
        
        // Computed property to parse food description for calories value
        var caloriesInfo: String? {
            let components = foodDescription.components(separatedBy: " | ")
            for component in components {
                let info = component.components(separatedBy: ": ")
                if info.count == 2 {
                    let key = info[0]
                    let value = info[1]
                    if key.lowercased().contains("calories") {
                        // Sayısal değeri almak için "kcal" kısmını kaldırarak sadece sayıları alabiliriz
                        let numericValue = value.replacingOccurrences(of: "kcal", with: "").trimmingCharacters(in: .whitespaces)
                        return numericValue
                    }
                }
            }
            return nil
        }
        
        // Computed property to parse food description for fat value
        var fatInfo: String? {
            let components = foodDescription.components(separatedBy: " | ")
            for component in components {
                let info = component.components(separatedBy: ": ")
                if info.count == 2 {
                    let key = info[0]
                    let value = info[1]
                    if key.lowercased().contains("fat") {
                        // Sayısal değeri almak için "g" kısmını kaldırarak sadece sayıları alabiliriz
                        let numericValue = value.replacingOccurrences(of: "g", with: "").trimmingCharacters(in: .whitespaces)
                        return numericValue
                    }
                }
            }
            return nil
        }
        
        // Computed property to parse food description for carbs value
        var carbsInfo: String? {
            let components = foodDescription.components(separatedBy: " | ")
            for component in components {
                let info = component.components(separatedBy: ": ")
                if info.count == 2 {
                    let key = info[0]
                    let value = info[1]
                    if key.lowercased().contains("carbs") {
                        // Sayısal değeri almak için "g" kısmını kaldırarak sadece sayıları alabiliriz
                        let numericValue = value.replacingOccurrences(of: "g", with: "").trimmingCharacters(in: .whitespaces)
                        return numericValue
                    }
                }
            }
            return nil
        }
        
        // Computed property to parse food description for protein value
        var proteinInfo: String? {
            let components = foodDescription.components(separatedBy: " | ")
            for component in components {
                let info = component.components(separatedBy: ": ")
                if info.count == 2 {
                    let key = info[0]
                    let value = info[1]
                    if key.lowercased().contains("protein") {
                        // Sayısal değeri almak için "g" kısmını kaldırarak sadece sayıları alabiliriz
                        let numericValue = value.replacingOccurrences(of: "g", with: "").trimmingCharacters(in: .whitespaces)
                        return numericValue
                    }
                }
            }
            return nil
        }
    }
    
    func fetchSearchResults() {
        guard !searchText.isEmpty else {
            print("Search text is empty")
            return
        }
        
        let formattedSearchText = searchText.replacingOccurrences(of: " ", with: "+")
        let urlString = "https://fatsecret4.p.rapidapi.com/rest/server.api?search_expression=\(formattedSearchText)&method=foods.search&page_number=0&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Error creating URL object")
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        let header = [
            "Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ4NDUzNUJFOUI2REY5QzM3M0VDNUNBRTRGMEJFNUE2QTk3REQ3QkMiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJTRVUxdnB0dC1jTno3Rnl1VHd2bHBxbDkxN3cifQ.eyJuYmYiOjE3MTQzOTE5NDIsImV4cCI6MTcxNDQ3ODM0MiwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJkMjhhOTgzZTMyYTQ0NWE3YTA0ZWM3MmJmZTAxN2JiNSIsInNjb3BlIjpbImJhc2ljIl19.WwEqSYvxeUKiHRQCmF-8nNqVWU0Fw7dznc9216A-ZfGpU6Fxqxg20ZzaDzA1dW8kjJPl9NvRXPrzyELrmyJ3OqNrcmXQHOhlJJyQFJw3hNKsCjsvU21gFbBqg4t7pDe9mTnS5tw4fYzwtbwo6JHVFHT4XTzoppm7M1jG8x37PxrnGPDNf11iNIxWpSDD6uj1iS5eMBGS9Ub73pzJz4EG5TCg14wfseE11Oo0480HJ06Hj9_dUJOEFq2iIHvAh3ZLIwKZbZ_82rH1y7D4nT1ypa8IacfpmSCMdLDFt74cLN5Wk03P2asspRRKTYhmpU6C6VrAXgFMkMG8-jaZNZAKZQ",
            "X-RapidAPI-Key": "e383cc1b7dmsh7e4874f7d9f9851p121bb4jsnec2469238335",
            "X-RapidAPI-Host": "fatsecret4.p.rapidapi.com"
        ]
        
        request.allHTTPHeaderFields = header
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let foodSearchResult = try decoder.decode(FoodSearchResult.self, from: data)
                    DispatchQueue.main.async {
                        self.foodItems = foodSearchResult.foods.food
                    }
                } catch {
                    print("Error parsing response data: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
        
        dataTask.resume()
    }
    
}
