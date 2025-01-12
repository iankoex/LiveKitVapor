//
//  File.swift
//  
//
//  Created by Ian on 08/08/2022.
//

import Foundation

public struct VideoGrant: Codable, Sendable {
    public init(
        roomName: String,
        canCreateRoom: Bool? = nil,
        canListRooms: Bool? = nil,
        canJoinRoom: Bool? = nil,
        isRoomAdmin: Bool? = nil,
        canRecordRoom: Bool? = nil,
        canPublish: Bool? = nil,
        canPublishData: Bool? = nil,
        canSubscribe: Bool = true,
        isParticipantHidden: Bool? = nil,
        isRecorder: Bool? = nil
    ) {
        self.roomName = roomName
        self.canCreateRoom = canCreateRoom
        self.canListRooms = canListRooms
        self.canJoinRoom = canJoinRoom
        self.isRoomAdmin = isRoomAdmin
        self.canRecordRoom = canRecordRoom
        self.canPublishData = canPublishData
        self.canSubscribe = canSubscribe
        self.isParticipantHidden = isParticipantHidden
        self.isRecorder = isRecorder
    }
    
    /// Name of the room
    public var roomName: String
    
    /// Permission to create rooms
    public var canCreateRoom: Bool?
    
    /// Permission to list available rooms
    public var canListRooms: Bool?
    
    /// Permission to join a room
    public var canJoinRoom: Bool?
    
    /// Permission to moderate a room
    public var isRoomAdmin: Bool?
    
    /// Permissions to use Egress service
    public var canRecordRoom: Bool?
    
    /// Allow participant to publish tracks
    public var canPublish: Bool?
    
    /// Allow participant to publish data to the room
    public var canPublishData: Bool?
    
    /// Allow participant to subscribe to tracks
    public var canSubscribe: Bool
    
    /// Hide participant from others (used by recorder)
    public var isParticipantHidden: Bool?
    
    /// Indicates this participant is recording the room
    public var isRecorder: Bool?
    
    enum CodingKeys: String, CodingKey {
        case roomName = "room"
        case canCreateRoom = "roomCreate"
        case canListRooms = "roomList"
        case canJoinRoom = "roomJoin"
        case isRoomAdmin = "roomAdmin"
        case canRecordRoom = "roomRecord"
        case canPublish = "canPublish"
        case canPublishData = "canPublishData"
        case canSubscribe = "canSubscribe"
        case isParticipantHidden = "hidden"
        case isRecorder = "recorder"
    }
}

