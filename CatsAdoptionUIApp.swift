import SwiftUI
import Foundation

@main
struct CatsAdoptionUIApp: App {
    @StateObject private var vm = CatsViewModel()

    init() {
        #if DEBUG
        do {
            let data = try DataLoader.loadJSON(named: "cats")
            if let rawString = String(data: data, encoding: .utf8) {
                print("=== RAW cats.json ===\n\(rawString)\n=====================")
            }
            let collection = try CatCollection(jsonData: data)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
            let pretty = try encoder.encode(collection.items)
            if let prettyString = String(data: pretty, encoding: .utf8) {
                print("=== Parsed & Pretty JSON ===\n\(prettyString)\n============================")
            }
            print("📦 Total de gatos:", collection.count)
            if let firstByIntake = collection.sortedByIntakeDateAscending().first {
                print("⏱️ Más antiguo en refugio:", firstByIntake.name, "–", firstByIntake.shelter.city)
            }
        } catch {
            print("❌ Error imprimiendo JSON:", error.localizedDescription)
        }
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(vm)
        }
    }
}
