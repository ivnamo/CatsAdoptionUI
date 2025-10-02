// ===============================================================
//  Archivo: CatsAdoptionUIApp.swift
//  Proyecto: CatsAdoptionUI
//  Descripción: Punto de entrada de la app. Imprime JSON en consola y lanza la UI.
//  Nota: Este archivo está *super comentado* para uso didáctico.
//  (Puedes borrar comentarios cuando pases a producción.)
// ===============================================================

import SwiftUI
import Foundation

/// `@main` marca el punto de entrada de una app SwiftUI.
/// Aquí también imprimimos el JSON por consola en modo DEBUG.
@main
struct CatsAdoptionUIApp: App {
    // `@StateObject` crea una instancia única del ViewModel que vive mientras viva la escena.
    @StateObject private var vm = CatsViewModel()
    
    /// `init()` del `App` se ejecuta una sola vez al arrancar.
    /// Usamos `#if DEBUG` para que los `print` no salgan en compilaciones Release.
    init() {
        #if DEBUG
        do {
            // 1) Cargar bytes de cats.json desde el bundle principal.
            let data = try DataLoader.loadJSON(named: "cats")
            
            // 1.a) Mostrar TEXTO crudo del JSON tal cual viene en el archivo.
            if let raw = String(data: data, encoding: .utf8) {
                print("""
                ========== RAW cats.json ==========
                \(raw)
                ===================================
                """)
            }
            
            // 2) Decodificar -> re-serializar con formato legible (prettyPrinted)
            let collection = try CatCollection(jsonData: data)
            let enc = JSONEncoder()
            enc.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
            let pretty = try enc.encode(collection.items)
            if let s = String(data: pretty, encoding: .utf8) {
                print("""
                ===== Parsed & Pretty (sorted keys) =====
                \(s)
                =========================================
                """)
            }
            
            // 3) Resumen útil
            print("📦 Total de gatos:", collection.count)
            if let first = collection.sortedByIntakeDateAscending().first {
                print("⏱️ Más antiguo en refugio:", first.name, "–", first.shelter.city)
            }
        } catch {
            // Si algo falla (p. ej., falta el archivo en el target), lo vemos aquí.
            print("❌ Error cargando/imprimiendo JSON:", error.localizedDescription)
        }
        #endif
    }
    
    /// Define las ventanas (escenas) de la app.
    var body: some Scene {
        WindowGroup {
            // Inyectamos el VM en el árbol de vistas para que hijas lo lean con `@EnvironmentObject`.
            ContentView()
                .environmentObject(vm)
        }
    }
}
