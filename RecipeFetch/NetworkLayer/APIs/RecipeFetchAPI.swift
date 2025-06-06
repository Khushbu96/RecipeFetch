//
//  RecipeFetchAPI.swift
//  RecipeFetch
//
//  Created by Khushbu on 5/30/25.
//

final class RecipeAPI {
    private let networkManager: NetworkManager
    private let baseURL: String

    init(networkManager: NetworkManager = .shared, baseURL: String = RecipeEndPoint.list.baseURL) {
        self.networkManager = networkManager
        self.baseURL = baseURL
    }
    
    func fetchRecipeList() async throws -> [Recipe] {        
        do {
            let recipes = try await networkManager.makeRequest(type: RecipeList.self, urlString: baseURL)
            return recipes.recipes
        } catch let error as NetworkError {
            throw error
        }
    }
}
