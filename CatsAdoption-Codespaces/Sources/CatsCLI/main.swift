import Foundation
import CatsCore

do {
    let data = try DataLoader.loadJSON(named: "cats")

    if let raw = String(data: data, encoding: .utf8) {
        print("=== RAW cats.json ===\n\(raw)\n=====================")
    }

    let collection = try CatCollection(jsonData: data)
    let enc = JSONEncoder()
    enc.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
    let pretty = try enc.encode(collection.items)
    if let s = String(data: pretty, encoding: .utf8) {
        print("=== Parsed & Pretty ===\n\(s)\n=======================")
    }

    print("Total de gatos:", collection.count)
    if let first = collection.sortedByIntakeDateAscending().first {
        print("Más antiguo en refugio:", first.name, "-", first.shelter.city)
    }

    print("\n🐾 Lista por antigüedad:")
    collection.sortedByIntakeDateAscending().forEach { cat in
        print(" • \(cat.name) — \(cat.breed) — \(cat.shelter.city) — \(cat.status.rawValue)")
    }

} catch {
    fputs("❌ Error: \(error.localizedDescription)\n", stderr)
    exit(1)
}
