import SwiftUI
import CatsCore

final class CatsViewModel: ObservableObject {
    @Published var cats: [Cat] = []
    @Published var errorMessage: String?

    init() { load() }

    func load() {
        do {
            let data = try DataLoader.loadJSON(named: "cats")
            let collection = try CatCollection(jsonData: data)
            self.cats = collection.sortedByIntakeDateAscending()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

@main
struct CatsAdoptionUIApp: App {
    @StateObject private var vm = CatsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(vm)
        }
    }
}
