import Foundation

struct ChildContact: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var relationship: String
    var phone: String
    var email: String = ""
}
