//
//  String+Extension.swift
//  RecipeFetch
//
//  Created by Khushbu on 6/3/25.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
        NSLocalizedString(self, comment: comment)
    }
}
