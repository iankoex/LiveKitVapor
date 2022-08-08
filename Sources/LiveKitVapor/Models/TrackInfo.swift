//
//  File.swift
//  
//
//  Created by Ian on 08/08/2022.
//

import Foundation

struct TrackInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case sid = "sid"
        case trackType = "type"
        case name = "name"
        case isMuted = "muted"
        case width = "width"
        case height = "height"
        case isSimulcast = "simulcast"
        case isDTXDisabled = "disable_dtx"
        case source = "source"
        case layers = "layers"
        case mimeType = "mime_type"
        case mid = "mid"
        case codecs = "codecs"
    }
    
    /// Server generated identifier
    var sid: String
    
    /// audio or video
    var trackType: String   // Should Be enum
    
    /// Name given at publish time
    var name: String
    
    /// true if track has been muted by the publisher
    var isMuted: Bool
    
    /// Original width of video (unset for audio)
    var width: Int
    
    /// Original height of video (unset for audio)
    var height: Int
    
    /// true if track is simulcasted
    var isSimulcast: Bool
    
    var isDTXDisabled: Bool
    
    var source: String // ?? Enum?
    
    var layers: [Layer]
    
    var mimeType: String
    
    var mid: String
    
    var codecs: [Codec]
}

extension TrackInfo {
    struct Tracks: Codable {
        var tracks: [TrackInfo]
    }
}

extension TrackInfo {
    struct Layer: Codable {
        var quality: String // ?? Enum?
        var width: Int
        var height: Int
        var bitrate: Int
        var ssrc: Int
    }
}

extension TrackInfo {
    struct Codec: Codable {
        enum CodingKeys: String, CodingKey {
            case mimeType = "mime_type"
            case mid = "mid"
            case cid = "cid"
            case layers = "layers"
        }
        var mimeType: String
        var mid: String
        var cid: String
        var layers: [Layer]
    }
}

