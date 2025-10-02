// ===============================================================
//  Archivo: ViewModel.swift
//  Proyecto: CatsAdoptionUI
//  Descripción: Lógica de carga de datos (MVVM) y estado para la vista.
//  Nota: Este archivo está *super comentado* para uso didáctico.
//  (Puedes borrar comentarios cuando pases a producción.)
// ===============================================================

import Foundation

/// ViewModel que expone datos a la UI (patrón MVVM).
/// - Carga el JSON `cats.json` desde el bundle al inicializarse.
/// - Publica la lista de gatos y un posible mensaje de error.
final class CatsViewModel: ObservableObject {
    /// Lista de gatos para que la UI la liste.
    @Published var cats: [Cat] = []
    /// Texto de error (si ocurre algún fallo al cargar/parsear).
    @Published var errorMessage: String?
    
    /// Al crear el VM, intentamos cargar inmediatamente.
    init() { load() }
    
    /// Carga `cats.json` del bundle, lo decodea y ordena por antigüedad en refugio.
    func load() {
        do {
            // Cargar bytes del JSON del bundle (ver `DataLoader`).
            let data = try DataLoader.loadJSON(named: "cats")
            // Parsear a nuestros modelos (ver `CatCollection`).
            let collection = try CatCollection(jsonData: data)
            // UI consistente: más antiguos primero.
            self.cats = collection.sortedByIntakeDateAscending()
            // Si todo va bien, limpiamos errores previos.
            self.errorMessage = nil
        } catch {
            // Guardamos el mensaje de error para que la UI lo muestre.
            self.errorMessage = error.localizedDescription
        }
    }
}
