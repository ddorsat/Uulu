//
//  PhotoView.swift
//  Uulu
//
//  Created by ddorsat on 01.07.2025.
//

import SwiftUI

struct FeedPhoto: View {
    let onTapHandler: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Image("main_photo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height * 0.47)
                .clipped()
            
            Text("Новая линейка парфюмов")
                .font(.title)
                .fontWeight(.medium)
            
            Text("Парфюмерия, вдохновлённая моментами, которые запоминаются надолго")
                .font(.title3)
                .foregroundStyle(.gray.opacity(0.8))
            
            Button {
                onTapHandler()
            } label: {
                Text("Каталог")
                    .foregroundStyle(.black)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .overlay {
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(.black, lineWidth: 1)
                    }
                    .padding(.horizontal, 2)
            }
            .padding([.horizontal, .top], 15)

        }
        .padding(.vertical)
        .padding(.horizontal, 10)
    }
}

#Preview {
    FeedPhoto() {
        
    }
}
