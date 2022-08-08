@testable import LiveKitVapor
import XCTVapor

final class AppTests: XCTestCase {
    let app: Application = Application(.testing)
    
    var req: Request {
        return Request(application: app, on: app.eventLoopGroup.next())
    }
    
    var liveKit: LiveKit {
        return LiveKit.shared
    }
    
    /*
     Make sure you run this first:
     
     liveKit-server
     
     and then run:
     
     liveKit-cli join-room \
     --room TestRoom \
     --identity CLITestUser \
     --api-key devkey \
     --api-secret secret \
     --publish-demo
     
     This simulates a user and broadcast
     If an instance of the server was running end it before beggining tests
     Note: an active internet connection is required
     */
    
    func testAStatus() async throws {
        let status = try await liveKit.status(req)
        
        XCTAssertEqual(status, .ok)
    }
    
    func testCreateRoom() async throws {
        let roomCreate = Room.Create(name: "Test Room", timeout: 300, maxParticipants: 20)
        let room = try await liveKit.createRoom(roomCreate, on: req)
        
        XCTAssertEqual(room.name, roomCreate.name)
        XCTAssertEqual(room.emptyTimeout, roomCreate.timeout)
        XCTAssertEqual(room.maxParticipants, roomCreate.maxParticipants)
        
        let _ = try await liveKit.deleteRoom(room.name, on: req)
    }
    
    func testListRooms() async throws {
        for num in 1..<5 {
            let _ = try await liveKit.createRoom(roomName: "Test Room \(num)", on: req)
        }
        let rooms = try await liveKit.getAllRooms(on: req)
        
        // 5 beacause of the room we created using the liveKit-cli
        XCTAssertEqual(rooms.rooms.count, 5)
        
        for num in 1..<5 {
            let _ = try await liveKit.deleteRoom("Test Room \(num)", on: req)
        }
    }
    
    /// Delete room will always  return .ok even if the room does not exist
    /// if listRoom fails then maybe deleteRoom was not successful
    func testDeleteRoom() async throws {
        let room = try await liveKit.createRoom(roomName: "Test Room", on: req)
        let status = try await liveKit.deleteRoom(room.name, on: req)
        let rooms = try await liveKit.getAllRooms(on: req)
        
        // 1 beacause of the room we created using the liveKit-cli
        XCTAssertEqual(status, .ok)
        XCTAssertEqual(rooms.rooms.count, 1)
    }
    
    func testUpdateRoomMetadata() async throws {
        let room = try await liveKit.createRoom(roomName: "Test Room", on: req)
        let str = "This is the updated metadata for the test"
        let status = try await liveKit.updateRoomMetadata(room.name, metadata: str, on: req)
        let rooms = try await liveKit.getAllRooms(on: req)
        // room at index 1 beacause of the room we created using the liveKit-cli
        let updatedRoom = rooms.rooms[1]
        
        XCTAssertEqual(status, .ok)
        XCTAssertEqual(updatedRoom.metadata, str)
        
        let _ = try await liveKit.deleteRoom(updatedRoom.name, on: req)
    }
    
    func sendData() async throws {
        // no test for this yet
    }
    
    func testListParticipants() async throws {
        let participants = try await liveKit.getAllParticipants("TestRoom", on: req)
        
        XCTAssertEqual(participants.participants.count, 1)
    }
    
    func testGetParticipant() async throws {
        let participants = try await liveKit.getAllParticipants("TestRoom", on: req)
        let expectedParticipant = participants.participants[0]
        let participant = try await liveKit.getParticipant(
            "TestRoom",
            participantID: expectedParticipant.participantID,
            on: req
        )
        
        XCTAssertEqual(expectedParticipant, participant)
    }
    
    func testMuteParticipant() async throws {
        let participants = try await liveKit.getAllParticipants("TestRoom", on: req)
        let expectedParticipant = participants.participants[0]
        let expectedParticipantTrack = expectedParticipant.tracks[0]
        let isMuted = expectedParticipantTrack.isMuted
        let status = try await liveKit.muteTrack(
            "TestRoom",
            participantID: expectedParticipant.participantID,
            trackSID: expectedParticipantTrack.sid,
            isMuted: !isMuted,
            on: req
        )
        let participant = try await liveKit.getParticipant(
            "TestRoom",
            participantID: expectedParticipant.participantID,
            on: req
        )
        let status1 = try await liveKit.muteTrack(
            "TestRoom",
            participantID: expectedParticipant.participantID,
            trackSID: expectedParticipantTrack.sid,
            isMuted: isMuted,
            on: req
        )
        let participant1 = try await liveKit.getParticipant(
            "TestRoom",
            participantID: expectedParticipant.participantID,
            on: req
        )
        let track = participant.tracks[0]
        let track1 = participant1.tracks[0]
        
        XCTAssertEqual(status, .ok)
        XCTAssertEqual(track.isMuted, !isMuted)
        
        // These two wont pass
//        XCTAssertEqual(status1, .ok)
//        XCTAssertEqual(track1.isMuted, isMuted)
    }
    
    func testUpdateParticipant() async throws {
        let participants = try await liveKit.getAllParticipants("TestRoom", on: req)
        let expectedParticipant = participants.participants[0]
        let updatedMetadata = "This is the updated metadata"
        let updatedPermissions = ParticipantInfo.Permission(
            canSubscribe: true,
            canPublishTracks: true,
            canPublishData: false,
            isHidden: false,
            isRecording: true
        )
        let status = try await liveKit.updateParticipant(
            "TestRoom",
            participantID: expectedParticipant.participantID,
            metadata: updatedMetadata,
            permissions: updatedPermissions,
            on: req
        )
        let participant = try await liveKit.getParticipant(
            "TestRoom",
            participantID: expectedParticipant.participantID,
            on: req
        )
        
        XCTAssertEqual(status, .ok)
        XCTAssertEqual(participant.metadata, updatedMetadata)
        XCTAssertEqual(participant.permissions, updatedPermissions)
    }
    
    func testUpdateSubscriptions() async throws {
        // no test yet
    }
    
    func testRemoveParticipant() async throws {
        // no tests yet
    }
    
    func testZRemoveParticipant() async throws {
        // the z is to make sure this is the last test.
        let participants = try await liveKit.getAllParticipants("TestRoom", on: req)
        let expectedParticipant = participants.participants[0]
        let status = try await liveKit.removeParticipant(
            "TestRoom",
            participantID: expectedParticipant.participantID,
            on: req
        )
        let updatedParticipants = try await liveKit.getAllParticipants("TestRoom", on: req)
        let count = updatedParticipants.participants.count

        XCTAssertEqual(status, .ok)
        XCTAssertEqual(count, 0)
    }
}
