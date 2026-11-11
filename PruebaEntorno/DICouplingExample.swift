import SwiftUI

// MARK: - Tightly Coupled Example

final class UserRepositoryConcrete {
    func fetchUsername() -> String {
        return "Alice (Concrete)"
    }
}

final class UserServiceCoupled {
    // This service creates its own repository internally,
    // so it is tightly coupled to UserRepositoryConcrete.
    private let repo = UserRepositoryConcrete()
    
    func loadUsername() -> String {
        return repo.fetchUsername()
    }
}

// MARK: - Decoupled Example Using Dependency Injection (DI)

protocol UserRepository {
    func fetchUsername() -> String
}

extension UserRepositoryConcrete: UserRepository {}

final class UserRepositoryMock: UserRepository {
    func fetchUsername() -> String {
        return "Bob (Mock)"
    }
}

final class UserServiceDI {
    private let repo: UserRepository
    
    // Dependency Injection via initializer
    init(repo: UserRepository) {
        self.repo = repo
    }
    
    func loadUsername() -> String {
        return repo.fetchUsername()
    }
}

// DI allows swapping implementations easily for testing or different environments,
// and promotes loose coupling and better testability.

// MARK: - SwiftUI Helper View Demonstrating the Difference

struct DIDemoView: View {
    @State private var coupledName = ""
    @State private var diName = ""
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Demo DI")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 8) {
                Button("Cargar (acoplado)") {
                    let service = UserServiceCoupled()
                    coupledName = service.loadUsername()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.08))
                .cornerRadius(10)
                .font(.headline)
                
                Text(coupledName.isEmpty ? "Nombre no cargado" : coupledName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 8) {
                Button("Cargar (DI con Mock)") {
                    let service = UserServiceDI(repo: UserRepositoryMock())
                    diName = service.loadUsername()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green.opacity(0.08))
                .cornerRadius(10)
                .font(.headline)
                
                Text(diName.isEmpty ? "Nombre no cargado" : diName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}

#Preview {
    DIDemoView()
}
