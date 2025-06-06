//
//  ErrorRecipesView.swift
//  RecipeFetch
//
//  Created by Khushbu on 6/3/25.
//

import SwiftUI

struct ErrorRecipesView: View {
    let error: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Text(error)
                .multilineTextAlignment(.center)
            Button(LocalizedKey.retry.localized(), action: retryAction)
                .foregroundColor(.black)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(8)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
