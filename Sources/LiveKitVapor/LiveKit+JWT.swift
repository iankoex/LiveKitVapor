//
//  File.swift
//  
//
//  Created by Ian on 08/08/2022.
//

import Foundation
import JWT

extension LiveKit {
    public func generateToken(
        participantID: String = UUID().uuidString,
        participantName: String = "Server Helper",
        expiryDate: Date = Date(timeIntervalSinceNow: 5 * 60),
        videoGrant: VideoGrant = VideoGrant(roomName: "myRoom", canJoinRoom: true),
        metadata: String? = nil
    ) throws -> String {
        let jwtSigner: JWTSigner = .hs256(key: secret)
        let date: Date = Date()
        let notBefore = Date(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate.rounded(.up))
        let notBeforeClaim = NotBeforeClaim(value: notBefore)
        let expiry = Date(timeIntervalSinceReferenceDate: expiryDate.timeIntervalSinceReferenceDate.rounded(.up))
        let expiryClaim = ExpirationClaim(value: expiry)
        
        let payload = LKJTWPayload(
            expiration: expiryClaim,
            notBefore: notBeforeClaim,
            apiKey: apiKey,
            participantID: participantID,
            participantName: participantName,
            videoGrant: videoGrant,
            metadata: metadata
        )
        let token = try jwtSigner.sign(payload)
        return token
    }
    
    internal func generateRoomToken(_ roomName: String = "") throws -> String {
        let jwtSigner: JWTSigner = .hs256(key: secret)
        let videoGrant: VideoGrant = VideoGrant(
            roomName: roomName,
            canCreateRoom: true,
            canListRooms: true,
            isRoomAdmin: true,
            isParticipantHidden: true
        )
        let date: Date = Date()
        let notBefore = Date(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate.rounded(.up))
        let notBeforeClaim = NotBeforeClaim(value: notBefore)
        let expiryDate: Date = Date(timeIntervalSinceNow: 60)
        let expiry = Date(timeIntervalSinceReferenceDate: expiryDate.timeIntervalSinceReferenceDate.rounded(.up))
        let expiryClaim = ExpirationClaim(value: expiry)
        
        let payload = LKJTWPayload(
            expiration: expiryClaim,
            notBefore: notBeforeClaim,
            apiKey: apiKey,
            participantID: UUID().uuidString,
            participantName: "Server Helper",
            videoGrant: videoGrant,
            metadata: "I am the your helper on the server side."
        )
        let token = try jwtSigner.sign(payload)
        return token
    }
}
