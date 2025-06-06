//
//  RecipeListViewModel.swift
//  RecipeFetch
//
//  Created by Khushbu on 6/1/25.
//

import Foundation

enum ViewState: Equatable {
    case loading
    case loaded
    case error(String)
}

@MainActor
final class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var viewState: ViewState = .loading
    @Published var searchText: String = ""
    
    init () {
        fetchRecipes()
    }
    
    private func fetchRecipes() {
        Task {
            do {
                let recipes = try await RecipeAPI().fetchRecipeList()
                DispatchQueue.main.async {
                    self.viewState = .loaded
                    self.recipes.append(contentsOf: recipes)
                }
            } catch {
                DispatchQueue.main.async {
                    self.viewState = .error(LocalizedKey.errorGeneral.localized())
                }
            }
        }
    }
    
    func refreshList() {
        recipes.removeAll()
        fetchRecipes()
    }
    
    var filteredRecipes: [Recipe] {
        guard !searchText.isEmpty else { return recipes }
        
        return recipes.filter { recipe in
            recipe.name.localizedCaseInsensitiveContains(searchText) ||
            recipe.cuisine.localizedCaseInsensitiveContains(searchText)
        }
    }
}
