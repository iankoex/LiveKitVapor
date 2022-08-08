//
//  File.swift
//  
//
//  Created by Ian on 08/08/2022.
//

import Foundation
import Vapor

public struct Room: Codable, Content {
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
    
    var sid: String
    var name: String
    var emptyTimeout: Int
    var maxParticipants: Int
    var creationTime: String
    var turnPassword: String
    var enabledCodecs: [Room.Codec]
    var metadata: String
    var participantsCount: Int
    var isBeingRecorded: Bool
}

extension Room {
    struct Codec: Codable {
        enum CodingKeys: String, CodingKey {
            case mime = "mime"
            case fmtpLine = "fmtp_line"
        }
        var mime: String
        var fmtpLine: String
    }
}

extension Room {
    public struct Create: Codable, Content {
        enum CodingKeys: String, CodingKey {
            case name = "name"
            case timeout = "empty_timeout"
            case maxParticipants = "max_participants"
        }
        
        /// Name of the room
        var name: String
        
        /// Number of seconds to keep the room open if no one joins
        var timeout: Int
        
        ///  Maximum number of participants that can be in the room
        var maxParticipants: Int
    }
}

extension Room {
    /// LiveKit server API returns it this way
    /// why? I dont know
    public struct Rooms: Codable, Content {
        public var rooms: [Room]
    }
}


extension Room {
    /// Used in DeleteRoom, ListParticipants, GetParticipant, RemoveParticipant, MutePublishedTrack
    /// UpdateParticipant, UpdateSubscriptions
    public struct Details: Codable, Content {
        enum CodingKeys: String, CodingKey {
            case roomName = "room"
            case participantID = "identity"
            case trackSID = "track_sid"
            case isMuted = "muted"
            case participantPermissions = "permission"
            case metadata = "metadata"
            case trackSIDs = "track_sids"
            case subscribe = "subscribe"
        }
        
        /// name of the room
        var roomName: String
        
        /// identity of the participant.
        var participantID: String?
        
        /// sid of the track to mute
        var trackSID: String?
        
        /// set to true to mute, false to unmute
        var isMuted: Bool?
        
        /// set to update the participant's permissions
        var participantPermissions: ParticipantInfo.Permission?
        
        /// used to update user's metadata in UpdateParticipant
        /// used to update Room's metadata in UpdateRoomMetadata
        var metadata: String?
        
        /// list of sids of tracks
        /// Used in UpdateSubscriptions
        var trackSIDs: [String]?
        
        /// set to true to subscribe, false to unsubscribe from tracks
        /// Used in UpdateSubscriptions
        var subscribe: Bool?
    }
}

extension Room {
    /// Used in SendData
    public struct SendData: Codable, Content {
        enum CodingKeys: String, CodingKey {
            case roomName = "room"
            case data = "data"
            case kind = "kind"
            case destinationSIDs = "destination_sids"
        }
        
        var roomName: String
        
        var data: Data
        
        /// Reliable or Lossy
        var kind: SendData.SendType
        
        /// list of participant sids to send to, sends to everyone when left blank
        var destinationSIDs: [String]
        
        enum SendType: Codable {
            case reliable
            case lossy
        }
    }
}

