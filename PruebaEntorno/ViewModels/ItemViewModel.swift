import Foundation
import Observation
import SwiftUI

@Observable
class ItemViewModel {
    var items: [Item] = []
    var isLoading: Bool = false
    
    init() {
        loadItems()
    }
    
    func loadItems() {
        isLoading = true
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.items = [
                Item(title: "Primer Item", description: "Esta es la descripción del primer item."),
                Item(title: "Segundo Item", description: "Esta es la descripción del segundo item."),
                Item(title: "Tercer Item", description: "Esta es la descripción del tercer item.")
            ]
            self.isLoading = false
        }
    }
    
    func addItem() {
        let newItem = Item(title: "Nuevo Item \(items.count + 1)", description: "Descripción autogenerada.")
        items.append(newItem)
    }
    
    func removeItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}
