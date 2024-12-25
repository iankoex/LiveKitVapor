//
//  File.swift
//  
//
//  Created by Ian on 08/08/2022.
//

import Foundation

public struct ParticipantInfo: Codable, Equatable, Sendable {
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
    
    public var sid: String
    
    public var participantID: String
    
    public var state: String
    
    public var tracks: [TrackInfo]
    
    public var metadata: String
    
    public var joinedAt: String
    
    public var participantName: String
    
    public var version: Int
    
    public var permissions: Permission
    
    public var region: String // ?? Enum?
    
    public var isPublisher: Bool
}

extension ParticipantInfo {
    public struct Permission: Codable, Equatable, Sendable {
        public init(
            canSubscribe: Bool,
            canPublishTracks: Bool,
            canPublishData: Bool,
            isHidden: Bool,
            isRecording: Bool
        ) {
            self.canSubscribe = canSubscribe
            self.canPublishTracks = canPublishTracks
            self.canPublishData = canPublishData
            self.isHidden = isHidden
            self.isRecording = isRecording
        }
        
        enum CodingKeys: String, CodingKey {
            case canSubscribe = "can_subscribe"
            case canPublishTracks = "can_publish"
            case canPublishData = "can_publish_data"
            case isHidden = "hidden"
            case isRecording = "recorder"
        }
         
        /// Allow participant to subscribe to other tracks in the room
        public var canSubscribe: Bool
        
        /// Allow participant to publish new tracks to room
        public var canPublishTracks: Bool
        
        /// Allow participant to publish data to room
        public var canPublishData: Bool
        
        public var isHidden: Bool
        
        public var isRecording: Bool
    }
}

extension ParticipantInfo {
    public struct Participants: Codable, Sendable {
        public var participants: [ParticipantInfo]
    }
}
