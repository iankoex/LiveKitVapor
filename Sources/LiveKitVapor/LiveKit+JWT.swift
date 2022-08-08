//
//  File.swift
//  
//
//  Created by Ian on 08/08/2022.
//

import Foundation
import JWT

extension LiveKit {
    func generateToken(
        participantID: String = "Server Helper",
        expiryDate: Date = Date(timeIntervalSinceNow: 5 * 60),
        videoGrant: VideoGrant = VideoGrant(roomName: "myRoom", canJoinRoom: true),
        metadata: String? = nil
    ) throws -> String {
        let jwtSigner: JWTSigner = .hs256(key: secret)
        let date: Date = .now
        let notBefore = Date(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate.rounded(.up))
        let notBeforeClaim = NotBeforeClaim(value: notBefore)
        let expiry = Date(timeIntervalSinceReferenceDate: expiryDate.timeIntervalSinceReferenceDate.rounded(.up))
        let expiryClaim = ExpirationClaim(value: expiry)
        
        let payload = LKJTWPayload(
            expiration: expiryClaim,
            notBefore: notBeforeClaim,
            apiKey: apiKey,
            participantID: participantID,
            videoGrant: videoGrant,
            metadata: metadata
        )
        let token = try jwtSigner.sign(payload)
        return token
    }
    
    func generateRoomToken(_ roomName: String = "") throws -> String {
        let jwtSigner: JWTSigner = .hs256(key: secret)
        let videoGrant: VideoGrant = VideoGrant(
            roomName: roomName,
            canCreateRoom: true,
            canListRooms: true,
            isRoomAdmin: true,
            isParticipantHidden: false // set to true in production
        )
        let date: Date = .now
        let notBefore = Date(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate.rounded(.up))
        let notBeforeClaim = NotBeforeClaim(value: notBefore)
        let expiryDate: Date = Date(timeIntervalSinceNow: 60)
        let expiry = Date(timeIntervalSinceReferenceDate: expiryDate.timeIntervalSinceReferenceDate.rounded(.up))
        let expiryClaim = ExpirationClaim(value: expiry)
        
        let payload = LKJTWPayload(
            expiration: expiryClaim,
            notBefore: notBeforeClaim,
            apiKey: apiKey,
            participantID: "Server Helper",
            videoGrant: videoGrant,
            metadata: "I am the your helper on the server side."
        )
        let token = try jwtSigner.sign(payload)
        return token
    }
}
