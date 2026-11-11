import SwiftUI

struct ItemListView: View {
    @State private var viewModel = ItemViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.isLoading {
                    ProgressView("Cargando items...")
                } else {
                    ForEach(viewModel.items) { item in
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: viewModel.removeItem)
                }
            }
            .navigationTitle("Items")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: viewModel.addItem) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
        }
    }
}

#Preview {
    ItemListView()
}
