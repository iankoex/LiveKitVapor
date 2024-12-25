import Foundation
import AsyncHTTPClient
import JWTKit
import NIOHTTP1
import NIOFoundationCompat

final public class LiveKit: Sendable {
    static public var shared = LiveKit()
    
    public var apiKey: String = "devkey"
    public var secret: String = "secret"
    public var baseTwirpURL: URL = URL(string: "http://localhost:7880/twirp/livekit.RoomService")!
    let jwtKeyCollection = JWTKeyCollection()
}

extension HTTPResponseStatus: @retroactive Error {}

extension LiveKit {
    public func status(_ client: HTTPClient = .shared) async throws -> HTTPResponseStatus {
        let prePostURL: URL = baseTwirpURL.deletingLastPathComponent()
        let postURL: URL = prePostURL.appendingPathComponent("livekit")
        
        var request = HTTPClientRequest(url: postURL.absoluteString)
        request.method = .POST
        
        let response = try await client.execute(request, timeout: .seconds(30))
        return response.status
    }
    
    public func createRoom(
        roomName: String,
        timeout: Int = 300,
        maxParticipants: Int = 10,
        client: HTTPClient = .shared
    ) async throws -> Room {
        let roomCreate = Room.Create(name: roomName, timeout: timeout, maxParticipants: maxParticipants)
        return try await createRoom(roomCreate, client: client)
    }
    
    public func createRoom(
        _ roomCreate: Room.Create,
        client: HTTPClient = .shared
    ) async throws -> Room {
        let postURL: URL = baseTwirpURL.appendingPathComponent("CreateRoom")
        let token = try await generateRoomToken()
        var request = HTTPClientRequest(url: postURL.absoluteString)
        request.method = .POST
        request.headers.add(name: "content-type", value: "application/json")
        request.headers.add(name: "Authorization", value: "Bearer \(token)")
        let data = try JSONEncoder().encode(roomCreate)
        request.body = .bytes(data)
        
        let response = try await client.execute(request, timeout: .seconds(30))
        guard response.status == .ok else {
            throw response.status
        }
        let contentLength = Int(response.headers.first(name: "content-length") ?? "") ?? 1024 * 1024
        let body = try await response.body.collect(upTo: contentLength)
        let room = try JSONDecoder().decode(Room.self, from: body)
        return room
    }
    
    public func getAllRooms(client: HTTPClient = .shared) async throws -> Room.Rooms {
        let postURL: URL = baseTwirpURL.appendingPathComponent("ListRooms")
        let token = try await generateRoomToken()
        var request = HTTPClientRequest(url: postURL.absoluteString)
        request.method = .POST
        request.headers.add(name: "content-type", value: "application/json")
        request.headers.add(name: "Authorization", value: "Bearer \(token)")
        
        let response = try await client.execute(request, timeout: .seconds(30))
        guard response.status == .ok else {
            throw response.status
        }
        let contentLength = Int(response.headers.first(name: "content-length") ?? "") ?? 1024 * 1024
        let body = try await response.body.collect(upTo: contentLength)
        let rooms = try JSONDecoder().decode(Room.Rooms.self, from: body)
        return rooms
    }
    
    public func deleteRoom(_ roomName: String, client: HTTPClient = .shared) async throws -> HTTPResponseStatus {
        let postURL: URL = baseTwirpURL.appendingPathComponent("DeleteRoom")
        let token = try await generateRoomToken()
        var request = HTTPClientRequest(url: postURL.absoluteString)
        request.method = .POST
        request.headers.add(name: "content-type", value: "application/json")
        request.headers.add(name: "Authorization", value: "Bearer \(token)")
        let deleteRoom = Room.Details(roomName: roomName)
        let data = try JSONEncoder().encode(deleteRoom)
        request.body = .bytes(data)
        
        let response = try await client.execute(request, timeout: .seconds(30))
        return response.status
    }
    
    public func updateRoomMetadata(_ roomName: String, metadata: String, client: HTTPClient = .shared) async throws -> HTTPResponseStatus {
        let postURL: URL = baseTwirpURL.appendingPathComponent("UpdateRoomMetadata")
        let token = try await generateRoomToken(roomName)
        let room = Room.Details(roomName: roomName, metadata: metadata)
        var request = HTTPClientRequest(url: postURL.absoluteString)
        request.method = .POST
        request.headers.add(name: "content-type", value: "application/json")
        request.headers.add(name: "Authorization", value: "Bearer \(token)")
        let data = try JSONEncoder().encode(room)
        request.body = .bytes(data)
        
        let response = try await client.execute(request, timeout: .seconds(30))
        return response.status
    }
    
    public func sendData(_ sendData: Room.SendData, client: HTTPClient = .shared) async throws -> HTTPResponseStatus {
        let postURL: URL = baseTwirpURL.appendingPathComponent("SendData")
        let token = try await generateRoomToken(sendData.roomName)
        var request = HTTPClientRequest(url: postURL.absoluteString)
        request.method = .POST
        request.headers.add(name: "content-type", value: "application/json")
        request.headers.add(name: "Authorization", value: "Bearer \(token)")
        let data = try JSONEncoder().encode(sendData)
        request.body = .bytes(data)
        
        let response = try await client.execute(request, timeout: .seconds(30))
        return response.status
    }
    
    public func getAllParticipants(_ roomName: String, client: HTTPClient = .shared) async throws -> ParticipantInfo.Participants {
        let postURL: URL = baseTwirpURL.appendingPathComponent("ListParticipants")
        let token = try await generateRoomToken(roomName)
        let room = Room.Details(roomName: roomName)
        var request = HTTPClientRequest(url: postURL.absoluteString)
        request.method = .POST
        request.headers.add(name: "content-type", value: "application/json")
        request.headers.add(name: "Authorization", value: "Bearer \(token)")
        let data = try JSONEncoder().encode(room)
        request.body = .bytes(data)
        
        let response = try await client.execute(request, timeout: .seconds(30))
        guard response.status == .ok else {
            throw response.status
        }
        let contentLength = Int(response.headers.first(name: "content-length") ?? "") ?? 1024 * 1024
        let body = try await response.body.collect(upTo: contentLength)
        let participants = try JSONDecoder().decode(ParticipantInfo.Participants.self, from: body)
        return participants
    }
    
    public func getParticipant(_ roomName: String, participantID: String, client: HTTPClient = .shared) async throws -> ParticipantInfo {
        let postURL: URL = baseTwirpURL.appendingPathComponent("GetParticipant")
        let token = try await generateRoomToken(roomName)
        let room = Room.Details(roomName: roomName, participantID: participantID)
        var request = HTTPClientRequest(url: postURL.absoluteString)
        request.method = .POST
        request.headers.add(name: "content-type", value: "application/json")
        request.headers.add(name: "Authorization", value: "Bearer \(token)")
        let data = try JSONEncoder().encode(room)
        request.body = .bytes(data)
        
        let response = try await client.execute(request, timeout: .seconds(30))
        guard response.status == .ok else {
            throw response.status
        }
        let contentLength = Int(response.headers.first(name: "content-length") ?? "") ?? 1024 * 1024
        let body = try await response.body.collect(upTo: contentLength)
        let participant = try JSONDecoder().decode(ParticipantInfo.self, from: body)
        return participant
    }
    
    public func removeParticipant(_ roomName: String, participantID: String, client: HTTPClient = .shared) async throws -> HTTPResponseStatus {
        let postURL: URL = baseTwirpURL.appendingPathComponent("RemoveParticipant")
        let token = try await generateRoomToken(roomName)
        let room = Room.Details(roomName: roomName, participantID: participantID)
        var request = HTTPClientRequest(url: postURL.absoluteString)
        request.method = .POST
        request.headers.add(name: "content-type", value: "application/json")
        request.headers.add(name: "Authorization", value: "Bearer \(token)")
        let data = try JSONEncoder().encode(room)
        request.body = .bytes(data)
        
        let response = try await client.execute(request, timeout: .seconds(30))
        return response.status
    }
    
    public func muteTrack(
        _ roomName: String,
        participantID: String,
        trackSID: String,
        isMuted: Bool,
        client: HTTPClient = .shared
    ) async throws -> HTTPResponseStatus {
        let postURL: URL = baseTwirpURL.appendingPathComponent("MutePublishedTrack")
        let token = try await generateRoomToken(roomName)
        let room = Room.Details(
            roomName: roomName,
            participantID: participantID,
            trackSID: trackSID,
            isMuted: isMuted
        )
        var request = HTTPClientRequest(url: postURL.absoluteString)
        request.method = .POST
        request.headers.add(name: "content-type", value: "application/json")
        request.headers.add(name: "Authorization", value: "Bearer \(token)")
        let data = try JSONEncoder().encode(room)
        request.body = .bytes(data)
        
        let response = try await client.execute(request, timeout: .seconds(30))
        return response.status
    }
    
    public func updateParticipant(
        _ roomName: String,
        participantID: String,
        metadata: String? = nil,
        permissions: ParticipantInfo.Permission,
        client: HTTPClient = .shared
    ) async throws -> HTTPResponseStatus {
        let postURL: URL = baseTwirpURL.appendingPathComponent("UpdateParticipant")
        let token = try await generateRoomToken(roomName)
        let room = Room.Details(
            roomName: roomName,
            participantID: participantID,
            participantPermissions: permissions,
            metadata: metadata
        )
        var request = HTTPClientRequest(url: postURL.absoluteString)
        request.method = .POST
        request.headers.add(name: "content-type", value: "application/json")
        request.headers.add(name: "Authorization", value: "Bearer \(token)")
        let data = try JSONEncoder().encode(room)
        request.body = .bytes(data)
        
        let response = try await client.execute(request, timeout: .seconds(30))
        return response.status
    }
    
    public func updateSubscriptions(
        _ roomName: String,
        participantID: String,
        trackSIDs: [String],
        subscribe: Bool,
        client: HTTPClient = .shared
    ) async throws -> HTTPResponseStatus {
        let postURL: URL = baseTwirpURL.appendingPathComponent("UpdateSubscriptions")
        let token = try await generateRoomToken(roomName)
        let room = Room.Details(
            roomName: roomName,
            participantID: participantID,
            trackSIDs: trackSIDs,
            subscribe: subscribe
        )
        var request = HTTPClientRequest(url: postURL.absoluteString)
        request.method = .POST
        request.headers.add(name: "content-type", value: "application/json")
        request.headers.add(name: "Authorization", value: "Bearer \(token)")
        let data = try JSONEncoder().encode(room)
        request.body = .bytes(data)
        
        let response = try await client.execute(request, timeout: .seconds(30))
        return response.status
    }
}
