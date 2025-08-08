//
//  FeedExploreMore.swift
//  Uulu
//
//  Created by ddorsat on 11.07.2025.
//

import SwiftUI

struct FeedExploreMore: View {
    let onTapHandler: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Text("Ещё")
                .font(.title)
            
            Image(systemName: "chevron.right")
                .font(.title2)
        }
        .fontWeight(.medium)
        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.35)
        .padding(.bottom, 50)
        .onTapGesture {
            onTapHandler()
        }
    }
}

#Preview {
    FeedExploreMore() {
        
    }
}
