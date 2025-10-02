// ===============================================================
//  Archivo: ContentView.swift
//  Proyecto: CatsAdoptionUI
//  Descripción: Vista principal con el logo y la lista de gatos.
//  Nota: Este archivo está *super comentado* para uso didáctico.
//  (Puedes borrar comentarios cuando pases a producción.)
// ===============================================================

import SwiftUI

/// Vista principal: cabecera con logo y una lista de gatos.
struct ContentView: View {
    /// Obtenemos el ViewModel compartido desde el entorno (lo inyecta `CatsAdoptionUIApp`).
    @EnvironmentObject var vm: CatsViewModel
    
    var body: some View {
        // `NavigationStack` (iOS 16+) permite push/pop nativo y título grande.
        NavigationStack {
            VStack(spacing: 16) {
                
                // === LOGO ===
                // El asset se llama "AppLogo" (ver Assets.xcassets/AppLogo.imageset).
                // Si cambias el nombre del ImageSet, cambia también aquí.
                Image("AppLogo")
                    .resizable()                       // Permite redimensionar
                    .scaledToFit()                     // Mantiene proporciones
                    .frame(width: 120, height: 120)    // Tamaño visible (pt)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous)) // Bordes redondeados
                    .shadow(radius: 6)                 // Sombra suave
                
                // Título principal
                Text("Adopción de Gatos")
                    .font(.title2).bold()
                    .foregroundStyle(.primary)
                
                // Si hubo un error cargando el JSON, lo mostramos al usuario.
                if let error = vm.errorMessage {
                    Text("Error: \(error)")
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                }
                
                // Lista de gatos (cada fila es un `CatRow`).
                List(vm.cats) { cat in
                    CatRow(cat: cat)
                }
                .listStyle(.insetGrouped)
            }
            .padding()
            .navigationTitle("Inicio") // Título de la barra de navegación
        }
    }
}

/// Fila que representa un gato. Muestra nombre, raza, ciudad y un chip con el estado.
struct CatRow: View {
    let cat: Cat
    
    /// Mapeo simple de estado -> color para el chip y el avatar.
    private var statusColor: Color {
        switch cat.status {
        case .available: return .green
        case .reserved:  return .orange
        case .adopted:   return .blue
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar redondo con la inicial del nombre del gato.
            Circle()
                .fill(statusColor.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay(Text(String(cat.name.prefix(1))).bold())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(cat.name).font(.headline) // Nombre
                Text("\(cat.breed) • \(cat.shelter.city)") // Info secundaria
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                // Chip/etiqueta con el estado (Available/Reserved/Adopted)
                Text(cat.status.rawValue.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(statusColor.opacity(0.15))
                    .clipShape(Capsule())
            }
            Spacer()
        }
        .padding(.vertical, 6) // Separación vertical entre filas
    }
}

// === PREVIEW de Xcode ===
// Sirve para ver la UI sin compilar en simulador. No afecta a la app real.
#Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // Datos mock para la previsualización
        let shelter = Shelter(name: "Refugio Demo",
                              address: "C/ Demo 1",
                              city: "Madrid",
                              country: "España",
                              latitude: 40.4,
                              longitude: -3.7)
        let sample = Cat(name: "Luna",
                         breed: "European Shorthair",
                         sex: .female,
                         status: .available,
                         colorCategory: .primary,
                         birthdate: nil,
                         intakeDate: Date(),
                         weightKg: 3.5,
                         descriptionText: "Demo preview",
                         photoURLs: [],
                         tags: ["demo"],
                         shelter: shelter)
        let vm = CatsViewModel(); vm.cats = [sample]
        return ContentView().environmentObject(vm)
    }
}
