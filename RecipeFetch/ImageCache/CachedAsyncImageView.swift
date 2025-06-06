//
//  CachedAsyncImageView.swift
//  RecipeFetch
//
//  Created by Khushbu on 6/2/25.
//

import SwiftUI

enum ImagePhase: Equatable {
    case loading
    case loaded(Image)
    case failed
}

struct CachedAsyncImageView: View {
    let imageURL: URL
    let imageIdentifier: String
    
    @EnvironmentObject var imageCacheManager: ImageCacheManager
    @State private var phase: ImagePhase = .loading
    
    var body: some View {
        switch self.phase {
        case .loading:
            ProgressView()
                .onAppear {
                    Task {
                        await loadImage()
                    }
                }
        case .loaded(let image):
            image
                .resizable()
                .scaledToFit()
                .cornerRadius(12)
                .shadow(radius: 2)
        case .failed:
            Image(systemName: "photo")
                .frame(width: 80, height: 80)
                .cornerRadius(12)
                .border(Color.gray, width: 1)
                .foregroundColor(.gray)
        }
    }
    
    private func loadImage() async {
        self.phase = .loading
        
        if let image = try? await self.imageCacheManager.loadImage(from: self.imageURL, identifier: self.imageIdentifier) {
            self.phase = .loaded(Image(uiImage: image))
        } else {
            self.phase = .failed
        }
    }
        
}
