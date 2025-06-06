//
//  NoInternetConnectionView.swift
//  RecipeFetch
//
//  Created by Khushbu on 6/3/25.
//

import SwiftUI

struct NoInternetConnectionView: View {
    var body: some View {
        HStack {
            Image(systemName: "network.slash")
                .frame(width: 20, height: 20)
                .padding(.leading)
            Text(LocalizedKey.errorNoInternet.localized())
                .padding(.leading, 1)
            Spacer()
                
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.1))
        .padding(.top, 1)
    }
}
