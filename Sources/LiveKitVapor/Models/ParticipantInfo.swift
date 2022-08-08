//
//  File.swift
//  
//
//  Created by Ian on 08/08/2022.
//

import Foundation
import Vapor

struct ParticipantInfo: Codable, Content {
    enum CodingKeys: String, CodingKey {
        case sid = "sid"
        case participantID = "identity"
        case state = "state"
        case tracks = "tracks"
        case metadata = "metadata"
        case joinedAt = "joined_at"
        case participantName = "name"
        case version = "version"
        case permissions = "permission"
        case region = "region"
        case isPublisher = "is_publisher"
    }
    
    var sid: String
    
    var participantID: String
    
    var state: String
    
    var tracks: [TrackInfo]
    
    var metadata: String
    
    var joinedAt: String
    
    var participantName: String
    
    var version: Int
    
    var permissions: Permission
    
    var region: String // ?? Enum?
    
    var isPublisher: Bool
    
}

extension ParticipantInfo {
    struct Permission: Codable {
        enum CodingKeys: String, CodingKey {
            case canSubscribe = "can_subscribe"
            case canPublishTracks = "can_publish"
            case canPublishData = "can_publish_data"
            case isHidden = "hidden"
            case isRecording = "recorder"
        }
         
        /// Allow participant to subscribe to other tracks in the room
        var canSubscribe: Bool
        
        /// Allow participant to publish new tracks to room
        var canPublishTracks: Bool
        
        /// Allow participant to publish data to room
        var canPublishData: Bool
        
        var isHidden: Bool
        
        var isRecording: Bool
    }
}

extension ParticipantInfo {
    struct Participants: Codable, Content {
        var participants: [ParticipantInfo]
    }
}

