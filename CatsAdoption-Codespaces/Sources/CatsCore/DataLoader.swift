import Foundation

public enum DataLoader {
    public static func loadJSON(named name: String) throws -> Data {
        #if SWIFT_PACKAGE
        if let url = Bundle.module.url(forResource: name, withExtension: "json") {
            return try Data(contentsOf: url)
        }
        #endif
        let candidates = ["./Resources/\(name).json", "Resources/\(name).json", "./\(name).json"]
        for p in candidates where FileManager.default.fileExists(atPath: p) {
            return try Data(contentsOf: URL(fileURLWithPath: p))
        }
        if let url = Bundle.main.url(forResource: name, withExtension: "json") {
            return try Data(contentsOf: url)
        }
        throw NSError(domain: "DataLoader", code: 404, userInfo: [NSLocalizedDescriptionKey: "No se encontró \(name).json"])
    }
}
