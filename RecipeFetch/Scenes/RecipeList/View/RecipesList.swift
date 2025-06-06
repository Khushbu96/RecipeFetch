//
//  RecipeList.swift
//  RecipeFetch
//
//  Created by Khushbu on 6/1/25.
//

import SwiftUI


struct RecipesList: View {
    @StateObject private var viewModel = RecipeListViewModel()
    @StateObject var networkMonitor = NetworkMonitor()
    
    var body: some View {
        NavigationStack {
            mainContent
                .navigationTitle(LocalizedKey.recipesTitle.localized())
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
                .controlSize(.large)
                .progressViewStyle(.circular)
        case .loaded:
            if viewModel.recipes.isEmpty {
                EmptyRecipesView()
            } else {
                loadedListContent
                    .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: LocalizedKey.recipesSearch.localized())
            }
        case .error(let error):
            let errorStr = networkMonitor.isConnected ? error : LocalizedKey.errorNoInternet.localized()
            ErrorRecipesView(error: errorStr) {
                viewModel.refreshList()
            }
        }
    }
    
    @ViewBuilder
    private var loadedListContent: some View {
        if viewModel.filteredRecipes.isEmpty {
            EmptyRecipesView(isFiltered: true)
        } else {
            VStack {
                if !networkMonitor.isConnected {
                    NoInternetConnectionView()
                }
                List(viewModel.filteredRecipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        RecipeListCell(recipe: recipe)
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    viewModel.refreshList()
                }
            }
        }
    }
}


