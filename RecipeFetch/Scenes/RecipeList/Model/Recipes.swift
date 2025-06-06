//
//  Recipes.swift
//  RecipeFetch
//
//  Created by Khushbu on 5/30/25.
//

struct RecipeList: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Identifiable, Equatable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let sourceUrl: String?
    let id: String
    let youtubeUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case name, cuisine
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case id = "uuid"
        case youtubeUrl = "youtube_url"
    }
}
