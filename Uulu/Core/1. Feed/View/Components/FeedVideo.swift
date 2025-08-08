//
//  VideoView.swift
//  Uulu
//
//  Created by ddorsat on 01.07.2025.
//

import SwiftUI
import AVKit

struct FeedVideo: View {
    let onTapHandler: () -> Void
    
    var body: some View {
        VideoViewRepresentable()
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height * 0.38)
            .overlay(alignment: .bottomLeading) {
                HStack(alignment: .center) {
                    Button {
                        onTapHandler()
                    } label: {
                        Text("Перейти")
                        
                        Rectangle()
                            .frame(width: 19, height: 2)
                    }
                }
                .fontWeight(.medium)
                .font(.title2)
                .minimumScaleFactor(0.8)
                .foregroundStyle(.black)
                .padding(.vertical, 8)
                .padding(.horizontal, 30)
                .background(.white)
                .padding()
                .opacity(0.85)
            }
    }
}

private struct VideoViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        VideoCell()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

final class VideoCell: UIView {
    private let videoView = UIView()
    private var queuePlayer: AVQueuePlayer?
    private var playerLooper: AVPlayerLooper?
    private var playerLayer: AVPlayerLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVideo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVideo() {
        guard let path = Bundle.main.path(forResource: "video", ofType: "mp4") else { return }
        let videoURL = URL(fileURLWithPath: path)
        let playerItem = AVPlayerItem(url: videoURL)
        
        queuePlayer = AVQueuePlayer()
        queuePlayer?.volume = 0
        playerLooper = AVPlayerLooper(player: queuePlayer!, templateItem: playerItem)
        
        playerLayer = AVPlayerLayer(player: queuePlayer)
        playerLayer?.videoGravity = .resizeAspectFill
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.alpha = 0.9
        addSubview(videoView)
        
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: topAnchor),
            videoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            videoView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        if let playerLayer {
            videoView.layer.addSublayer(playerLayer)
        }
        
        queuePlayer?.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = videoView.bounds
    }
}


#Preview {
    FeedVideo() {
        
    }
}
