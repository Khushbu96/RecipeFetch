//
//  RecipeDetailView.swift
//  RecipeFetch
//
//  Created by Khushbu on 6/3/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                RecipeDetailCoverView(recipe: recipe)
                QuickActionList(recipe: recipe)
            }
            .padding()
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.black)
                    }
                }
            }
        }
    }
}

struct RecipeDetailCoverView: View {
    let recipe: Recipe
    
    var body: some View {
        if let urlString = recipe.photoUrlLarge,
           let imageUrl = URL(string: urlString) {
            CachedAsyncImageView(imageURL: imageUrl, imageIdentifier: recipe.id + "_large")
                .cornerRadius(12)
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .foregroundColor(.gray.opacity(0.5))
                .cornerRadius(12)
        }
    }
}


struct QuickActionList: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: 16) {
            if let sourceUrl = URL(string: recipe.youtubeUrl ?? "") {
                Link(destination: sourceUrl) {
                    QuickActionButton(imageName: "video.fill", color: .red, text: "Video")
                }
            }
            
            if let sourceUrl = URL(string: recipe.sourceUrl ?? "") {
                Link(destination: sourceUrl) {
                    QuickActionButton(imageName: "doc.text.fill", color: .blue, text: "Recipe")
                }
            }
        }
    }
}


struct QuickActionButton: View {
    let imageName: String
    let color: Color
    let text: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: imageName)
                .font(.system(size: 22))
                .foregroundColor(color)
            Text(text)
                .font(.caption)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}
