import Foundation
import Vapor

final class LiveKit {
    static var shared = LiveKit()
    // Meant to be used in vapor so
//    most of the functions use live kit swift client sdk
    var apiKey: String = "devkey"
    var secret: String = "secret"
    var baseTwirpURL: URL = URL(string: "http://localhost:7880/twirp/livekit.RoomService")!
    
    
}

extension LiveKit {
    func createRoom(
        roomName: String,
        timeout: Int = 300,
        maxParticipants: Int = 10,
        on req: Request
    ) async throws -> Room {
        let roomCreate = Room.Create(name: roomName, timeout: timeout, maxParticipants: maxParticipants)
        return try await createRoom(roomCreate, on: req)
    }
    
    func createRoom(
        _ roomCreate: Room.Create,
        on req: Request
    ) async throws -> Room {
        let postURL: URL = baseTwirpURL.appendingPathComponent("CreateRoom")
        let someURI = URI(string: postURL.absoluteString)
        let token = try generateRoomToken()
        let response = try await req.client.post(someURI) { req in
            req.headers.contentType = .json
            try req.content.encode(roomCreate)
            
            let auth = BearerAuthorization(token: token)
            req.headers.bearerAuthorization = auth
        }
        guard response.status == .ok else {
            throw Abort(.custom(code: response.status.code, reasonPhrase: response.status.reasonPhrase))
        }
        let room = try response.content.decode(Room.self)
        return room
    }
    
    func getAllRooms(on req: Request) async throws -> Room.Rooms {
        let postURL: URL = baseTwirpURL.appendingPathComponent("ListRooms")
        let someURI = URI(string: postURL.absoluteString)
        let token = try generateRoomToken()
        let response = try await req.client.post(someURI) { req in
            req.headers.contentType = .json
            try req.content.encode(["":""])
            
            let auth = BearerAuthorization(token: token)
            req.headers.bearerAuthorization = auth
        }
        guard response.status == .ok else {
            throw Abort(.custom(code: response.status.code, reasonPhrase: response.status.reasonPhrase))
        }
        let rooms = try response.content.decode(Room.Rooms.self)
        return rooms
    }
    
    func deleteRoom(_ roomName: String, on req: Request) async throws -> HTTPStatus {
        let postURL: URL = baseTwirpURL.appendingPathComponent("DeleteRoom")
        let someURI = URI(string: postURL.absoluteString)
        let token = try generateRoomToken()
        let deleteRoom = Room.Details(roomName: roomName)
        let response = try await req.client.post(someURI) { req in
            req.headers.contentType = .json
            try req.content.encode(deleteRoom)
            
            let auth = BearerAuthorization(token: token)
            req.headers.bearerAuthorization = auth
        }
        return response.status
    }
    
    func updateRoomMetadata(_ roomName: String, metadata: String, on req: Request) async throws -> HTTPStatus {
        let postURL: URL = baseTwirpURL.appendingPathComponent("UpdateRoomMetadata")
        let someURI = URI(string: postURL.absoluteString)
        let token = try generateRoomToken(roomName)
        let room = Room.Details(roomName: roomName, metadata: metadata)
        let response = try await req.client.post(someURI) { req in
            req.headers.contentType = .json
            try req.content.encode(room)
            
            let auth = BearerAuthorization(token: token)
            req.headers.bearerAuthorization = auth
        }
        return response.status
    }
    
    func sendData(_ sendData: Room.SendData, on req: Request) async throws -> HTTPStatus {
        let postURL: URL = baseTwirpURL.appendingPathComponent("SendData")
        let someURI = URI(string: postURL.absoluteString)
        let token = try generateRoomToken(sendData.roomName)
        let response = try await req.client.post(someURI) { req in
            req.headers.contentType = .json
            try req.content.encode(sendData)
            
            let auth = BearerAuthorization(token: token)
            req.headers.bearerAuthorization = auth
        }
        return response.status
    }
    
    func getAllParticipants(_ roomName: String, on req: Request) async throws -> ParticipantInfo.Participants {
        let postURL: URL = baseTwirpURL.appendingPathComponent("ListParticipants")
        let someURI = URI(string: postURL.absoluteString)
        let token = try generateRoomToken(roomName)
        let room = Room.Details(roomName: roomName)
        let response = try await req.client.post(someURI) { req in
            req.headers.contentType = .json
            try req.content.encode(room)
            
            let auth = BearerAuthorization(token: token)
            req.headers.bearerAuthorization = auth
        }
        guard response.status == .ok else {
            throw Abort(.custom(code: response.status.code, reasonPhrase: response.status.reasonPhrase))
        }
        let participants = try response.content.decode(ParticipantInfo.Participants.self)
        return participants
    }
    
    func getParticipant(_ roomName: String, participantID: String, on req: Request) async throws -> ParticipantInfo {
        let postURL: URL = baseTwirpURL.appendingPathComponent("GetParticipant")
        let someURI = URI(string: postURL.absoluteString)
        let token = try generateRoomToken(roomName)
        let room = Room.Details(roomName: roomName, participantID: participantID)
        let response = try await req.client.post(someURI) { req in
            req.headers.contentType = .json
            try req.content.encode(room)
            
            let auth = BearerAuthorization(token: token)
            req.headers.bearerAuthorization = auth
        }
        guard response.status == .ok else {
            throw Abort(.custom(code: response.status.code, reasonPhrase: response.status.reasonPhrase))
        }
        let participant = try response.content.decode(ParticipantInfo.self)
        return participant
    }
    
    func removeParticipant(_ roomName: String, participantID: String, on req: Request) async throws -> HTTPStatus {
        let postURL: URL = baseTwirpURL.appendingPathComponent("RemoveParticipant")
        let someURI = URI(string: postURL.absoluteString)
        let token = try generateRoomToken(roomName)
        let room = Room.Details(roomName: roomName, participantID: participantID)
        let response = try await req.client.post(someURI) { req in
            req.headers.contentType = .json
            try req.content.encode(room)
            
            let auth = BearerAuthorization(token: token)
            req.headers.bearerAuthorization = auth
        }
        return response.status
    }
    
    func muteTrack(
        _ roomName: String,
        participantID: String,
        trackSID: String,
        isMuted: Bool,
        on req: Request
    ) async throws -> HTTPStatus {
        let postURL: URL = baseTwirpURL.appendingPathComponent("MutePublishedTrack")
        let someURI = URI(string: postURL.absoluteString)
        let token = try generateRoomToken(roomName)
        let room = Room.Details(
            roomName: roomName,
            participantID: participantID,
            trackSID: trackSID,
            isMuted: isMuted
        )
        let response = try await req.client.post(someURI) { req in
            req.headers.contentType = .json
            try req.content.encode(room)
            
            let auth = BearerAuthorization(token: token)
            req.headers.bearerAuthorization = auth
        }
        return response.status
    }
    
    func updateParticipant(
        _ roomName: String,
        participantID: String,
        metadata: String? = nil,
        permissions: ParticipantInfo.Permission,
        on req: Request
    ) async throws -> HTTPStatus {
        let postURL: URL = baseTwirpURL.appendingPathComponent("UpdateParticipant")
        let someURI = URI(string: postURL.absoluteString)
        let token = try generateRoomToken(roomName)
        let room = Room.Details(
            roomName: roomName,
            participantID: participantID,
            participantPermissions: permissions,
            metadata: metadata
        )
        let response = try await req.client.post(someURI) { req in
            req.headers.contentType = .json
            try req.content.encode(room)
            
            let auth = BearerAuthorization(token: token)
            req.headers.bearerAuthorization = auth
        }
        return response.status
    }
    
    func updateSubscriptions(
        _ roomName: String,
        participantID: String,
        trackSIDs: [String],
        subscribe: Bool,
        on req: Request
    ) async throws -> HTTPStatus {
        let postURL: URL = baseTwirpURL.appendingPathComponent("UpdateSubscriptions")
        let someURI = URI(string: postURL.absoluteString)
        let token = try generateRoomToken(roomName)
        let room = Room.Details(
            roomName: roomName,
            participantID: participantID,
            trackSIDs: trackSIDs,
            subscribe: subscribe
        )
        let response = try await req.client.post(someURI) { req in
            req.headers.contentType = .json
            try req.content.encode(room)
            
            let auth = BearerAuthorization(token: token)
            req.headers.bearerAuthorization = auth
        }
        return response.status
    }
}

