//
//  File.swift
//  
//
//  Created by Ian on 08/08/2022.
//

struct VideoGrant: Codable {
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
    
    /// Name of the room
    var roomName: String
    
    /// Permission to create rooms
    var canCreateRoom: Bool? = nil
    
    /// Permission to list available rooms
    var canListRooms: Bool? = nil
    
    /// Permission to join a room
    var canJoinRoom: Bool? = nil
    
    /// Permission to moderate a room
    var isRoomAdmin: Bool? = nil
    
    /// Permissions to use Egress service
    var canRecordRoom: Bool? = nil
    
    /// Allow participant to publish data to the room
    var canPublishData: Bool? = nil
    
    /// Allow participant to subscribe to tracks
    var canSubscribe: Bool = true
    
    /// Hide participant from others (used by recorder)
    var isParticipantHidden: Bool? = nil
    
    /// Indicates this participant is recording the room
    var isRecorder: Bool? = nil
}

