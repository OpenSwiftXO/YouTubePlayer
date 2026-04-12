import Foundation

// MARK: - Player State

/// The current playback state of the YouTube player.
///
/// Maps to IFrame API player state codes:
/// https://developers.google.com/youtube/iframe_api_reference#Playback_status
public enum YouTubePlayerState: Int, Sendable {
    case unstarted = -1
    case ended = 0
    case playing = 1
    case paused = 2
    case buffering = 3
    case cued = 5
    case unknown = -99
    
    init(code: String) {
        switch code {
        case "-1": self = .unstarted
        case "0":  self = .ended
        case "1":  self = .playing
        case "2":  self = .paused
        case "3":  self = .buffering
        case "5":  self = .cued
        default:   self = .unknown
        }
    }
}

// MARK: - Playback Quality

/// The resolution of the currently loaded video.
public enum YouTubePlaybackQuality: String, Sendable {
    case small     = "small"
    case medium    = "medium"
    case large     = "large"
    case hd720     = "hd720"
    case hd1080    = "hd1080"
    case highRes   = "highres"
    case auto      = "auto"
    case `default` = "default"
    case unknown   = "unknown"
    
    init(string: String) {
        self = YouTubePlaybackQuality(rawValue: string) ?? .unknown
    }
}

// MARK: - Player Error

/// An error reported by the YouTube IFrame player.
///
/// https://developers.google.com/youtube/iframe_api_reference#Events (onError)
public enum YouTubePlayerError: Error, Sendable {
    /// The request contained an invalid parameter value (code 2).
    case invalidParam
    /// The requested content cannot be played in an HTML5 player (code 5).
    case html5Error
    /// The video requested was not found (codes 100, 105).
    case videoNotFound
    /// The owner of the video does not allow it to be played in embedded players (codes 101, 150).
    case notEmbeddable
    /// An unknown error occurred.
    case unknown
    
    init(code: String) {
        switch code {
        case "2":          self = .invalidParam
        case "5":          self = .html5Error
        case "100", "105": self = .videoNotFound
        case "101", "150": self = .notEmbeddable
        default:           self = .unknown
        }
    }
}

// MARK: - Player Variables

/// A dictionary of YouTube IFrame player parameters.
///
/// Full parameter reference: https://developers.google.com/youtube/player_parameters
public typealias YouTubePlayerVars = [String: Any]
