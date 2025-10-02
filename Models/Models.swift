// ===============================================================
//  Archivo: Models.swift
//  Proyecto: CatsAdoptionUI
//  Descripción: Enums y clases del modelo de dominio (Cat, Shelter, CatCollection).
//  Nota: Este archivo está *super comentado* para uso didáctico.
//  (Puedes borrar comentarios cuando pases a producción.)
// ===============================================================

import Foundation

// MARK: - Enums categorizadores

/// Estado de adopción del gato.
enum AdoptionStatus: String, Codable, CaseIterable {
    case available, reserved, adopted
}

/// Sexo del gato (si no se conoce, `.unknown`).
enum Sex: String, Codable, CaseIterable {
    case male, female, unknown
}

/// Categoría de color (útil para etiquetar/temas de UI).
enum ColorCategory: String, Codable, CaseIterable {
    case primary, secondary, success, warning, danger, info, neutral
}

// MARK: - Propiedad: Refugio (Shelter)

/// Información del refugio (dirección, ciudad, geo y redes).
final class Shelter: Codable, Identifiable {
    let id: UUID
    var name: String
    var address: String
    var city: String
    var country: String
    var latitude: Double
    var longitude: Double
    var website: URL?
    var youtube: URL?
    var instagram: URL?
    
    /// Inicializador designado.
    init(id: UUID = UUID(),
         name: String,
         address: String,
         city: String,
         country: String,
         latitude: Double,
         longitude: Double,
         website: URL? = nil,
         youtube: URL? = nil,
         instagram: URL? = nil) {
        self.id = id
        self.name = name
        self.address = address
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.website = website
        self.youtube = youtube
        self.instagram = instagram
    }
}

// MARK: - Ítem: Gato (Cat)

/// Representa un gato con tipos heterogéneos (Strings, números, fechas, URLs, arrays, objeto anidado).
final class Cat: Codable, Identifiable {
    let id: UUID
    var name: String
    var breed: String
    var sex: Sex
    var status: AdoptionStatus
    var colorCategory: ColorCategory
    var birthdate: Date?        // puede ser nil si no se conoce
    var intakeDate: Date        // fecha de ingreso en refugio
    var weightKg: Double
    var descriptionText: String
    var photoURLs: [URL]
    var tags: [String]
    var shelter: Shelter        // relación 1..1 con refugio
    
    /// Inicializador designado.
    init(id: UUID = UUID(),
         name: String,
         breed: String,
         sex: Sex,
         status: AdoptionStatus,
         colorCategory: ColorCategory,
         birthdate: Date?,
         intakeDate: Date,
         weightKg: Double,
         descriptionText: String,
         photoURLs: [URL],
         tags: [String],
         shelter: Shelter) {
        self.id = id
        self.name = name
        self.breed = breed
        self.sex = sex
        self.status = status
        self.colorCategory = colorCategory
        self.birthdate = birthdate
        self.intakeDate = intakeDate
        self.weightKg = weightKg
        self.descriptionText = descriptionText
        self.photoURLs = photoURLs
        self.tags = tags
        self.shelter = shelter
    }
    
    // MARK: - Decodificación personalizada de fechas
    enum CodingKeys: String, CodingKey { case id, name, breed, sex, status, colorCategory, birthdate, intakeDate, weightKg, descriptionText, photoURLs, tags, shelter }
    
    /// Inicializador de conveniencia para controlar el parseo ISO8601 -> `Date`.
    convenience init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        
        // Campos obligatorios
        let id = try c.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        let name = try c.decode(String.self, forKey: .name)
        let breed = try c.decode(String.self, forKey: .breed)
        let sex = try c.decode(Sex.self, forKey: .sex)
        let status = try c.decode(AdoptionStatus.self, forKey: .status)
        let colorCategory = try c.decode(ColorCategory.self, forKey: .colorCategory)
        let weightKg = try c.decode(Double.self, forKey: .weightKg)
        let descriptionText = try c.decode(String.self, forKey: .descriptionText)
        let photoURLs = try c.decode([URL].self, forKey: .photoURLs)
        let tags = try c.decode([String].self, forKey: .tags)
        let shelter = try c.decode(Shelter.self, forKey: .shelter)
        
        // Fechas en ISO8601 (ej. 2025-09-01T09:30:00Z)
        let iso = ISO8601DateFormatter()
        let birthStr = try c.decodeIfPresent(String.self, forKey: .birthdate)
        let birthdate = birthStr.flatMap { iso.date(from: $0) } // opcional
        
        let intakeStr = try c.decode(String.self, forKey: .intakeDate)
        guard let intakeDate = iso.date(from: intakeStr) else {
            throw DecodingError.dataCorruptedError(forKey: .intakeDate,
                                                   in: c,
                                                   debugDescription: "Fecha inválida para intakeDate")
        }
        
        self.init(id: id,
                  name: name,
                  breed: breed,
                  sex: sex,
                  status: status,
                  colorCategory: colorCategory,
                  birthdate: birthdate,
                  intakeDate: intakeDate,
                  weightKg: weightKg,
                  descriptionText: descriptionText,
                  photoURLs: photoURLs,
                  tags: tags,
                  shelter: shelter)
    }
}

// MARK: - Colección: CatCollection

/// Estructura de colección que agrupa `Cat` y da utilidades de acceso/ordenación.
final class CatCollection: Codable {
    private(set) var items: [Cat] = []       // protegemos escritura externa
    
    /// Designado
    init(items: [Cat] = []) { self.items = items }
    
    /// Conveniencia que recibe `Data` de JSON y crea la colección.
    convenience init(jsonData: Data) throws {
        let dec = JSONDecoder()
        // `Cat` ya controla el parseo de fechas en su `init(from:)`.
        let cats = try dec.decode([Cat].self, from: jsonData)
        self.init(items: cats)
    }
    
    /// Número de elementos
    var count: Int { items.count }
    
    /// Devuelve una NUEVA lista ordenada por `intakeDate` ascendente.
    func sortedByIntakeDateAscending() -> [Cat] {
        items.sorted { $0.intakeDate < $1.intakeDate }
    }
}
