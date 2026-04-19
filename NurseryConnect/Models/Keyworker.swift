import Foundation
import SwiftData

@Model
final class Keyworker {
    var id: UUID
    var fullName: String
    var email: String
    var password: String
    var roomName: String

    init(id: UUID = UUID(), fullName: String, email: String, password: String, roomName: String) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.password = password
        self.roomName = roomName
    }
}
