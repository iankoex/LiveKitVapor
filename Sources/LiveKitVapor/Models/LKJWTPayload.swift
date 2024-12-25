//
//  File.swift
//  
//
//  Created by Ian on 08/08/2022.
//

import Foundation
import JWTKit

struct LKJTWPayload: JWTPayload {
    enum CodingKeys: String, CodingKey {
        case expiration = "exp"
        case notBefore = "nbf"
        case participantID = "sub"
        case participantName = "name"
        case apiKey = "iss"
        case videoGrant = "video"
        case metadata = "metadata"
    }
    
    /// Expiration time of token
    var expiration: ExpirationClaim
    
    /// Start time that the token becomes valid
    var notBefore: NotBeforeClaim
    
    /// API key used to issue this token
    var apiKey: String
    
    /// Unique identity for the participant
    var participantID: String
    
    /// The name of the participant
    var participantName: String
    
    /// Video grant, including room permissions
    var videoGrant: VideoGrant
 
    /// Participant metadata
    var metadata: String? = nil
    
    func verify(using algorithm: some JWTKit.JWTAlgorithm) async throws {
        try self.expiration.verifyNotExpired()
    }
}
