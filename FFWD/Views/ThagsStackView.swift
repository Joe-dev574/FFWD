//
//  ThagsStackView.swift
//  FFWD
//
//  Created by Joseph DeWeese on 12/15/24.
//

import SwiftUI

struct ThagStackView: View {
    var thags: [Thag]
    
    var body: some View {
        HStack {
            ForEach(thags.sorted(using: KeyPathComparator(\Thag.name))) { thag in
                Text(thag.name)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 5).fill(thag.hexColor))
            }
        }
    }
}

