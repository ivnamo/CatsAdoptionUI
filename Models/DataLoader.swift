// ===============================================================
//  Archivo: DataLoader.swift
//  Proyecto: CatsAdoptionUI
//  Descripción: Utilidad para cargar JSON del bundle de la app.
//  Nota: Este archivo está *super comentado* para uso didáctico.
//  (Puedes borrar comentarios cuando pases a producción.)
// ===============================================================

import Foundation

/// Utilidad para cargar un archivo JSON del bundle principal de la app iOS.
/// Asegúrate de que el JSON esté en el proyecto y marcado con **Target Membership**.
enum DataLoader {
    /// Carga `name.json` del bundle principal y devuelve sus bytes (`Data`).
    /// - Parameter name: nombre del archivo sin extensión (ej.: "cats").
    /// - Throws: error si el archivo no existe o falla la lectura.
    static func loadJSON(named name: String) throws -> Data {
        // Localiza el recurso en el bundle. Si devuelve `nil`, no está incluido en el target.
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            throw NSError(domain: "DataLoader",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "No se encontró \(name).json en el bundle (¿está añadido al target?)"]
                         )
        }
        // Lee los bytes del archivo en disco y los retorna.
        return try Data(contentsOf: url)
    }
}
