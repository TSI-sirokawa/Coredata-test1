//
//  SearchView.swift
//  mReji
//
//  Created by Matsuoka Yuri on 2024/05/13.
//

import SwiftUI

struct SearchView: View {
    @Binding var keyword: String
    let onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("", text: $keyword)
            Button {
                onSearch()
            } label: {
                Image(systemName: "magnifyingglass")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 27, height: 27)
                    .foregroundColor(ColorThemeManager.Constant.textSecondary)
            }
        }
        .padding(.horizontal, 8)
        .foregroundColor(ColorThemeManager.shared.primary)
        .frame(width: 263, height: 20)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(ColorThemeManager.Constant.border, lineWidth: 1.0)
                .padding(.vertical, -8.0)
        )
    }
}
