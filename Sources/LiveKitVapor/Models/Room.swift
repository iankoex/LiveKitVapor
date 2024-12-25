//
//  File.swift
//  
//
//  Created by Ian on 08/08/2022.
//

import Foundation

public struct Room: Codable {
    enum CodingKeys: String, CodingKey {
        case sid = "sid"
        case name = "name"
        case emptyTimeout = "empty_timeout"
        case maxParticipants = "max_participants"
        case creationTime = "creation_time"
        case turnPassword = "turn_password"
        case enabledCodecs = "enabled_codecs"
        case metadata = "metadata"
        case participantsCount = "num_participants"
        case isBeingRecorded = "active_recording"
    }
    
    public var sid: String
    public var name: String
    public var emptyTimeout: Int
    public var maxParticipants: Int
    public var creationTime: String
    public var turnPassword: String
    public var enabledCodecs: [Room.Codec]
    public var metadata: String
    public var participantsCount: Int
    public var isBeingRecorded: Bool
}

extension Room {
    public struct Codec: Codable {
        enum CodingKeys: String, CodingKey {
            case mime = "mime"
            case fmtpLine = "fmtp_line"
        }
        public var mime: String
        public var fmtpLine: String
    }
}

extension Room {
    public struct Create: Codable {
        enum CodingKeys: String, CodingKey {
            case name = "name"
            case timeout = "empty_timeout"
            case maxParticipants = "max_participants"
        }
        
        public init(
            name: String,
            timeout: Int,
            maxParticipants: Int
        ) {
            self.name = name
            self.timeout = timeout
            self.maxParticipants = maxParticipants
        }
        
        /// Name of the room
        public var name: String
        
        /// Number of seconds to keep the room open if no one joins
        public var timeout: Int
        
        ///  Maximum number of participants that can be in the room
        public var maxParticipants: Int
    }
}

extension Room {
    /// LiveKit server API returns it this way
    /// why? I dont know
    public struct Rooms: Codable {
        public var rooms: [Room]
    }
}


extension Room {
    /// Used in DeleteRoom, ListParticipants, GetParticipant, RemoveParticipant, MutePublishedTrack
    /// UpdateParticipant, UpdateSubscriptions
    public struct Details: Codable {
        public enum CodingKeys: String, CodingKey {
            case roomName = "room"
            case participantID = "identity"
            case trackSID = "track_sid"
            case isMuted = "muted"
            case participantPermissions = "permission"
            case metadata = "metadata"
            case trackSIDs = "track_sids"
            case subscribe = "subscribe"
        }
        
        public init(
            roomName: String,
            participantID: String? = nil,
            trackSID: String? = nil,
            isMuted: Bool? = nil,
            participantPermissions: ParticipantInfo.Permission? = nil,
            metadata: String? = nil,
            trackSIDs: [String]? = nil,
            subscribe: Bool? = nil
        ) {
            self.roomName = roomName
            self.participantID = participantID
            self.trackSID = trackSID
            self.isMuted = isMuted
            self.participantPermissions = participantPermissions
            self.metadata = metadata
            self.trackSIDs = trackSIDs
            self.subscribe = subscribe
        }
        
        /// name of the room
        public var roomName: String
        
        /// identity of the participant.
        public var participantID: String?
        
        /// sid of the track to mute
        public var trackSID: String?
        
        /// set to true to mute, false to unmute
        public var isMuted: Bool?
        
        /// set to update the participant's permissions
        public var participantPermissions: ParticipantInfo.Permission?
        
        /// used to update user's metadata in UpdateParticipant
        /// used to update Room's metadata in UpdateRoomMetadata
        public var metadata: String?
        
        /// list of sids of tracks
        /// Used in UpdateSubscriptions
        public var trackSIDs: [String]?
        
        /// set to true to subscribe, false to unsubscribe from tracks
        /// Used in UpdateSubscriptions
        public var subscribe: Bool?
    }
}

extension Room {
    /// Used in SendData
    public struct SendData: Codable {
        enum CodingKeys: String, CodingKey {
            case roomName = "room"
            case data = "data"
            case kind = "kind"
            case destinationSIDs = "destination_sids"
        }
        
        public init(
            roomName: String,
            data: Data,
            kind: SendData.SendType,
            destinationSIDs: [String]
        ) {
            self.roomName = roomName
            self.data = data
            self.kind = kind
            self.destinationSIDs = destinationSIDs
        }
        
        public var roomName: String
        
        public var data: Data
        
        /// Reliable or Lossy
        public var kind: SendData.SendType
        
        /// list of participant sids to send to, sends to everyone when left blank
        public var destinationSIDs: [String]
        
        public enum SendType: Codable {
            case reliable
            case lossy
        }
    }
}

