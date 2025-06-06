//
//  RecipeEndPoint.swift
//  RecipeFetch
//
//  Created by Khushbu on 5/30/25.
//

enum RecipeEndPoint {
    case list
}

extension RecipeEndPoint {
    var baseURL: String {
        switch self {
        case .list:
            return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        }
    }
}
