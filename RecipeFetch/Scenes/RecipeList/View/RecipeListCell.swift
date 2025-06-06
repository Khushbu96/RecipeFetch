//
//  RecipeListCell.swift
//  RecipeFetch
//
//  Created by Khushbu on 6/1/25.
//

import SwiftUI

struct RecipeListCell: View {
    var recipe: Recipe
    
    var body: some View {
        HStack {
            if let imageUrl = URL(string: recipe.photoUrlSmall ?? "") {
                CachedAsyncImageView(imageURL: imageUrl, imageIdentifier: recipe.id)
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
                    .clipped()
            } else {
                Image(systemName: "photo")
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
                    .border(Color.gray, width: 1)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                
                Text(recipe.cuisine)
                    .font(.subheadline)
            }
        }
        
    }
}
