import Foundation

final class CatsViewModel: ObservableObject {
    @Published var cats: [Cat] = []
    @Published var errorMessage: String?

    init() { load() }

    func load() {
        do {
            let data = try DataLoader.loadJSON(named: "cats")
            let collection = try CatCollection(jsonData: data)
            self.cats = collection.sortedByIntakeDateAscending()
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
