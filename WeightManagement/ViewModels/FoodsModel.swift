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
    //@Published var randomFood: [Recipe] = []
    
    // FoodGetResult
    struct RecipeResult: Codable {
        let recipe: Recipe
    }
    
    struct Recipe: Codable {
        let gramsPerPortion, recipeDescription, recipeName: String
        let recipeURL: String
        let servingSizes: ServingSizes
        
        enum CodingKeys: String, CodingKey {
            case gramsPerPortion = "grams_per_portion"
            case recipeDescription = "recipe_description"
            case recipeName = "recipe_name"
            case recipeURL = "recipe_url"
            case servingSizes = "serving_sizes"
        }
    }
    
    struct ServingSizes: Codable {
        let serving: Serving
    }
    
    struct Serving: Codable {
        let calories: String
        let carbohydrate: String
        let fat: String
        let protein: String
    }
    
    // FoodSearchResult
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
        
        // Computed property to parse serving size as numeric value
        var servingSizeNumeric: String? {
            let components = foodDescription.components(separatedBy: " - ")
            if let servingSizeString = components.first {
                // "Per " ve "g" kısımlarını kaldırıp, sadece sayısal değeri alıyoruz
                let numericValue = servingSizeString.replacingOccurrences(of: "Per ", with: "").replacingOccurrences(of: "g", with: "").trimmingCharacters(in: .whitespaces)
                return numericValue
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
            "Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ4NDUzNUJFOUI2REY5QzM3M0VDNUNBRTRGMEJFNUE2QTk3REQ3QkMiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJTRVUxdnB0dC1jTno3Rnl1VHd2bHBxbDkxN3cifQ.eyJuYmYiOjE3MTU4NjE3MzQsImV4cCI6MTcxNTk0ODEzNCwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJkMjhhOTgzZTMyYTQ0NWE3YTA0ZWM3MmJmZTAxN2JiNSIsInNjb3BlIjpbImJhc2ljIl19.peE4yJxJo_1-Ubeuth2ditasSmu7KXzdvx6EcLX5q1YXJBXj0Bf3XN1A3S_9PXM5_l7kz-RAeurbPAjE9D1UiVdLq5EZpOBQSsD_QvJC6sr59TvetBdtyhih2RAX9XLM2E2BHZpsALiwqQIpHrcJ8QsYDlBfNRwJYcxByls1IUY-XN2Ks0vWvQfKL4nq1dAo3zHbKjqxH-40qn9XxvcdIA362qhKGXYbBFMm58Zzqyio-T9JXpaBvoTy9J0DJtOIOGEdpzfozb1UfOGs2xPl08LxffifH0FRj1OBYQYE2oUGfdy0nPJwfLjvPqHj_mZPlA8ukzhICmeTULt6U0Zeig",
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
    
    func fetchRandomRecipe(completion: @escaping (Result<Recipe, Error>) -> Void) {
        // Başlangıçta geçerli bir recipe ID yok
        var validRecipeID: Int?
        
        // Rastgele bir recipeID oluşturma ve geçerli olana kadar dene
        while validRecipeID == nil {
            let randomRecipeID = Int.random(in: 1...1000) // Değişebilir, API'nin recipeID aralığına göre ayarlayabilirsiniz
            
            guard let url = URL(string: "https://fatsecret4.p.rapidapi.com/rest/server.api?recipe_id=\(randomRecipeID)&method=recipe.get.v2&format=json") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
            
            let headers = [
                "X-RapidAPI-Key": "e383cc1b7dmsh7e4874f7d9f9851p121bb4jsnec2469238335",
                "X-RapidAPI-Host": "fatsecret4.p.rapidapi.com",
                "Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ4NDUzNUJFOUI2REY5QzM3M0VDNUNBRTRGMEJFNUE2QTk3REQ3QkMiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJTRVUxdnB0dC1jTno3Rnl1VHd2bHBxbDkxN3cifQ.eyJuYmYiOjE3MTU4NjE3MzQsImV4cCI6MTcxNTk0ODEzNCwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJkMjhhOTgzZTMyYTQ0NWE3YTA0ZWM3MmJmZTAxN2JiNSIsInNjb3BlIjpbImJhc2ljIl19.peE4yJxJo_1-Ubeuth2ditasSmu7KXzdvx6EcLX5q1YXJBXj0Bf3XN1A3S_9PXM5_l7kz-RAeurbPAjE9D1UiVdLq5EZpOBQSsD_QvJC6sr59TvetBdtyhih2RAX9XLM2E2BHZpsALiwqQIpHrcJ8QsYDlBfNRwJYcxByls1IUY-XN2Ks0vWvQfKL4nq1dAo3zHbKjqxH-40qn9XxvcdIA362qhKGXYbBFMm58Zzqyio-T9JXpaBvoTy9J0DJtOIOGEdpzfozb1UfOGs2xPl08LxffifH0FRj1OBYQYE2oUGfdy0nPJwfLjvPqHj_mZPlA8ukzhICmeTULt6U0Zeig"
            ]
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let semaphore = DispatchSemaphore(value: 0)
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    // Veri yoksa veya bir hata varsa, geçerli bir ID bulunamadı demektir
                    semaphore.signal()
                    return
                }
                
                do {
                    // Veri varsa, JSON'u decode et ve geçerli bir ID olduğunu işaretle
                    let recipeResult = try JSONDecoder().decode(RecipeResult.self, from: data)
                    validRecipeID = randomRecipeID
                    semaphore.signal()
                } catch {
                    // Hata varsa, geçerli bir ID değil demektir, bir sonraki döngüde başka bir ID denenecek
                    semaphore.signal()
                }
            }
            
            dataTask.resume()
            
            // Veri alınıncaya kadar bekleyin
            _ = semaphore.wait(timeout: .now() + 2) // 5 saniye süre ile bekleyin (ayarlayabilirsiniz)
        }
        
        // Geçerli bir ID bulunduğunda, bu ID ile API'den veri çek
        guard let validID = validRecipeID else {
            completion(.failure(NSError(domain: "No valid ID found", code: 0, userInfo: nil)))
            return
        }
        
        let validURL = "https://fatsecret4.p.rapidapi.com/rest/server.api?recipe_id=\(validID)&method=recipe.get.v2&format=json"
        
        guard let url = URL(string: validURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let headers = [
            "X-RapidAPI-Key": "e383cc1b7dmsh7e4874f7d9f9851p121bb4jsnec2469238335",
            "X-RapidAPI-Host": "fatsecret4.p.rapidapi.com",
            "Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ4NDUzNUJFOUI2REY5QzM3M0VDNUNBRTRGMEJFNUE2QTk3REQ3QkMiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJTRVUxdnB0dC1jTno3Rnl1VHd2bHBxbDkxN3cifQ.eyJuYmYiOjE3MTU4NjE3MzQsImV4cCI6MTcxNTk0ODEzNCwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJkMjhhOTgzZTMyYTQ0NWE3YTA0ZWM3MmJmZTAxN2JiNSIsInNjb3BlIjpbImJhc2ljIl19.peE4yJxJo_1-Ubeuth2ditasSmu7KXzdvx6EcLX5q1YXJBXj0Bf3XN1A3S_9PXM5_l7kz-RAeurbPAjE9D1UiVdLq5EZpOBQSsD_QvJC6sr59TvetBdtyhih2RAX9XLM2E2BHZpsALiwqQIpHrcJ8QsYDlBfNRwJYcxByls1IUY-XN2Ks0vWvQfKL4nq1dAo3zHbKjqxH-40qn9XxvcdIA362qhKGXYbBFMm58Zzqyio-T9JXpaBvoTy9J0DJtOIOGEdpzfozb1UfOGs2xPl08LxffifH0FRj1OBYQYE2oUGfdy0nPJwfLjvPqHj_mZPlA8ukzhICmeTULt6U0Zeig"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError(domain: "Unknown error", code: 0, userInfo: nil)))
                }
                return
            }
            
            do {
                let recipeResult = try JSONDecoder().decode(RecipeResult.self, from: data)
                completion(.success(recipeResult.recipe))
            } catch {
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
    
    
}
