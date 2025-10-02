import Foundation

enum DataLoader {
    static func loadJSON(named name: String) throws -> Data {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            throw NSError(domain: "DataLoader", code: 1, userInfo: [NSLocalizedDescriptionKey: "No se encontró \(name).json en el bundle"])
        }
        return try Data(contentsOf: url)
    }
}
