//
//  File.swift
//  
//
//  Created by Ian on 08/08/2022.
//

import Foundation

public struct TrackInfo: Codable, Equatable, Sendable {
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
    public var sid: String
    
    /// audio or video
    public var trackType: String   // Should Be enum
    
    /// Name given at publish time
    public var name: String
    
    /// true if track has been muted by the publisher
    public var isMuted: Bool
    
    /// Original width of video (unset for audio)
    public var width: Int
    
    /// Original height of video (unset for audio)
    public var height: Int
    
    /// true if track is simulcasted
    public  var isSimulcast: Bool
    
    public var isDTXDisabled: Bool
    
    public var source: String // ?? Enum?
    
    public var layers: [Layer]
    
    public var mimeType: String
    
    public var mid: String
    
    public var codecs: [Codec]
}

extension TrackInfo {
    public struct Tracks: Codable {
        public var tracks: [TrackInfo]
    }
}

extension TrackInfo {
    public struct Layer: Codable, Equatable, Sendable {
        public var quality: String // ?? Enum?
        public var width: Int
        public var height: Int
        public var bitrate: Int
        public var ssrc: Int
    }
}

extension TrackInfo {
    public struct Codec: Codable, Equatable, Sendable {
        enum CodingKeys: String, CodingKey {
            case mimeType = "mime_type"
            case mid = "mid"
            case cid = "cid"
            case layers = "layers"
        }
        public var mimeType: String
        public var mid: String
        public var cid: String
        public var layers: [Layer]
    }
}

