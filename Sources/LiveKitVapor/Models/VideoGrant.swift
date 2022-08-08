//
//  File.swift
//  
//
//  Created by Ian on 08/08/2022.
//

public struct VideoGrant: Codable {
    public init(
        roomName: String,
        canCreateRoom: Bool? = nil,
        canListRooms: Bool? = nil,
        canJoinRoom: Bool? = nil,
        isRoomAdmin: Bool? = nil,
        canRecordRoom: Bool? = nil,
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
    public var canCreateRoom: Bool? = nil
    
    /// Permission to list available rooms
    public var canListRooms: Bool? = nil
    
    /// Permission to join a room
    public var canJoinRoom: Bool? = nil
    
    /// Permission to moderate a room
    public var isRoomAdmin: Bool? = nil
    
    /// Permissions to use Egress service
    public var canRecordRoom: Bool? = nil
    
    /// Allow participant to publish data to the room
    public var canPublishData: Bool? = nil
    
    /// Allow participant to subscribe to tracks
    public var canSubscribe: Bool = true
    
    /// Hide participant from others (used by recorder)
    public var isParticipantHidden: Bool? = nil
    
    /// Indicates this participant is recording the room
    public var isRecorder: Bool? = nil
    
    enum CodingKeys: String, CodingKey {
        case roomName = "room"
        case canCreateRoom = "roomCreate"
        case canListRooms = "roomList"
        case canJoinRoom = "roomJoin"
        case isRoomAdmin = "roomAdmin"
        case canRecordRoom = "roomRecord"
        case canPublishData = "canPublishData"
        case canSubscribe = "canSubscribe"
        case isParticipantHidden = "hidden"
        case isRecorder = "recorder"
    }
}

