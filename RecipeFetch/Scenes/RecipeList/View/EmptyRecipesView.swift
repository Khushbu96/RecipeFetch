//
//  EmptyRecipesView.swift
//  RecipeFetch
//
//  Created by Khushbu on 6/3/25.
//

import SwiftUI

struct EmptyRecipesView: View {
    var isFiltered = false
    
    var body: some View {
        VStack {
            Text(isFiltered ? LocalizedKey.recipesFilterEmptyTitle.localized() : LocalizedKey.recipesEmptyTitle.localized())
                .font(.headline)
                .multilineTextAlignment(.center)
            if !isFiltered {
                Text(LocalizedKey.recipesEmptyMessage.localized())
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(30)
    }
}
