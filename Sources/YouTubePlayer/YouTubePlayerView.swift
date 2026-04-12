import SwiftUI
import WebKit

// MARK: - YouTubePlayerView

/// A SwiftUI view that displays a YouTube IFrame player managed by a `YouTubePlayer` controller.
///
/// Basic usage:
/// ```swift
/// @State private var player = YouTubePlayer()
///
/// var body: some View {
///     YouTubePlayerView(player: player)
///         .onAppear { player.load(videoId: "dQw4w9WgXcQ") }
/// }
/// ```
///
/// Use the fluent modifier API to observe player events:
/// ```swift
/// YouTubePlayerView(player: player)
///     .onReady { print("Player ready") }
///     .onStateChange { state in print("State: \(state)") }
///     .onError { error in print("Error: \(error)") }
/// ```
public struct YouTubePlayerView: View {
    
    /// The player controller managing this view.
    var player: YouTubePlayer
    
    public init(player: YouTubePlayer) {
        self.player = player
    }
    
    public var body: some View {
        // Accessing player.webView here means SwiftUI will re-render
        // this view whenever the webView property changes (@Observable tracking).
        _YouTubeWebViewContainer(webView: player.webView)
            .background(Color.black)
    }
}

// MARK: - Internal UIViewRepresentable

/// Hosts the `WKWebView` provided by the `YouTubePlayer` inside a plain `UIView` container.
///
/// Using a container `UIView` (rather than returning the `WKWebView` directly) lets
/// `updateUIView` safely swap the inner WKWebView if the player reloads with a new video.
private struct _YouTubeWebViewContainer: UIViewRepresentable {
    
    let webView: WKWebView?
    
    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.backgroundColor = .black
        return container
    }
    
    func updateUIView(_ container: UIView, context: Context) {
        guard let webView else {
            container.subviews.forEach { $0.removeFromSuperview() }
            return
        }
        // Only re-add when the WKWebView instance has changed
        if container.subviews.first !== webView {
            container.subviews.forEach { $0.removeFromSuperview() }
            webView.frame = container.bounds
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            container.addSubview(webView)
        }
    }
}

// MARK: - Convenience Modifiers

extension YouTubePlayerView {
    
    /// Called when the player becomes ready to accept API calls.
    public func onReady(_ action: @escaping () -> Void) -> Self {
        player.onReady = action
        return self
    }
    
    /// Called whenever the player state changes.
    public func onStateChange(_ action: @escaping (YouTubePlayerState) -> Void) -> Self {
        player.onStateChange = action
        return self
    }
    
    /// Called whenever the playback quality changes.
    public func onQualityChange(_ action: @escaping (YouTubePlaybackQuality) -> Void) -> Self {
        player.onQualityChange = action
        return self
    }
    
    /// Called when the player reports an error.
    public func onError(_ action: @escaping (YouTubePlayerError) -> Void) -> Self {
        player.onError = action
        return self
    }
    
    /// Called approximately twice per second with the current playback time in seconds.
    public func onPlayTime(_ action: @escaping (Float) -> Void) -> Self {
        player.onPlayTime = action
        return self
    }
    
    /// Called when the YouTube IFrame API script fails to load (e.g. no internet).
    public func onAPIFailedToLoad(_ action: @escaping () -> Void) -> Self {
        player.onAPIFailedToLoad = action
        return self
    }
}
