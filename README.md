# LiveKitVapor

A Swift helper for LiveKit Server APIs in [Vapor](https://github.com/vapor/vapor.git).

This is not a Server SDK. LiveKit has a variety of Server [SDKs](https://github.com/livekit/livekit#server-sdks).


## Installation

Add LiveKitVapor to your Vapor Package.swift. It should look like this: 

```swift
// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "my-app",
    dependencies: [
         // Other dependencies...
        .package(url: "https://github.com/iankoex/LiveKitVapor.git", from: "0.0.4")
    ],
    targets: [
        .target(name: "App", dependencies: [
            // Other dependencies...
            .product(name: "LiveKitVapor", package: "LiveKitVapor")
        ]),
        // Other targets...
    ]
)

```

## Usage
LiveKitVapor requires a working instance of [LiveKit](https://github.com/livekit/livekit.git).

Run:
```bash
liveKit-server
```
On your code:

```swift
import LiveKitVapor

# returns 'token'
let videoGrant = VideoGrant(
            roomName: "myRoom",
            canCreateRoom: true,
            canListRooms: true,
            canJoinRoom: true,
            isRoomAdmin: true
        )
let token = try LiveKit.shared.generateToken(videoGrant: videoGrant)
return token
```
```swift
// Use your own api-key and api-secret
// in your configure
public func configure(_ app: Application) throws {
    // Other Configurations
    LiveKit.shared.apiKey = "myOtherDevKey"
    LiveKit.shared.secret = "my-256-bit-secret"
}
```

LiveKit Server APIs. For more information refer to the [APIs docs]().

| LiveKit Server APIs (twirp)  | LiveKitVapor  |
| -------------                | ------------- |
| [CreateRoom](https://docs.livekit.io/guides/server-api/#createroom)                  | createRoom  |
| [ListRooms](https://docs.livekit.io/guides/server-api/#listrooms)                    | getAllRoom  |
| [DeleteRoom](https://docs.livekit.io/guides/server-api/#deleteroom)                  | deleteRoom |
| [ListParticipants](https://docs.livekit.io/guides/server-api/#listparticipants)      | getAllParticipants  |
| [GetParticipant](https://docs.livekit.io/guides/server-api/#getparticipant)          | getParticipant  |
| [RemoveParticipant](https://docs.livekit.io/guides/server-api/#removeparticipant)    | removeParticipant  |
| [MutePublishedTrack](https://docs.livekit.io/guides/server-api/#mutepublishedtrack)  | muteTrack  |
| [UpdateParticipant](https://docs.livekit.io/guides/server-api/#updateparticipant)    | updateParticipant  |
| [UpdateSubscriptions](https://docs.livekit.io/guides/server-api/#updatesubscriptions)| updateSubscriptions  |
| [UpdateRoomMetadata](https://docs.livekit.io/guides/server-api/#updateroommetadata)  | updateRoomMetadata  |
| [SendData](https://docs.livekit.io/guides/server-api/#senddata)                      | sendData  |

## Tests
Before running tests, run: 
``` bash
liveKit-server
```
and then: 
``` bash
liveKit-cli join-room \
     --room TestRoom \
     --identity CLITestUser \
     --api-key devkey \
     --api-secret secret \
     --publish-demo
```
Test not implemented: 

- [ ] sendData
- [ ] updateSubscriptions
- [ ] removeParticipant


Test with an issue:

- [ ] muteParticipant

## To Do
- [ ] Make codable structs mirror those of LiveKit swift client [sdk](https://github.com/livekit/client-sdk-swift.git).
- [ ] Enums for track type and quality.
- [ ] Test LiveKitVapor on Linux.
- [ ] Something else.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
Run wild. Do as you wish.
