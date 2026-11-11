import Foundation

struct Item: Identifiable {
    let id: UUID = UUID()
    let title: String
    let description: String
}
