import Foundation

enum AdoptionStatus: String, Codable, CaseIterable { case available, reserved, adopted }
enum Sex: String, Codable, CaseIterable { case male, female, unknown }
enum ColorCategory: String, Codable, CaseIterable { case primary, secondary, success, warning, danger, info, neutral }

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

    init(id: UUID = UUID(), name: String, address: String, city: String, country: String, latitude: Double, longitude: Double, website: URL? = nil, youtube: URL? = nil, instagram: URL? = nil) {
        self.id = id; self.name = name; self.address = address; self.city = city; self.country = country
        self.latitude = latitude; self.longitude = longitude; self.website = website; self.youtube = youtube; self.instagram = instagram
    }
}

final class Cat: Codable, Identifiable {
    let id: UUID
    var name: String
    var breed: String
    var sex: Sex
    var status: AdoptionStatus
    var colorCategory: ColorCategory
    var birthdate: Date?
    var intakeDate: Date
    var weightKg: Double
    var descriptionText: String
    var photoURLs: [URL]
    var tags: [String]
    var shelter: Shelter

    init(id: UUID = UUID(), name: String, breed: String, sex: Sex, status: AdoptionStatus, colorCategory: ColorCategory, birthdate: Date?, intakeDate: Date, weightKg: Double, descriptionText: String, photoURLs: [URL], tags: [String], shelter: Shelter) {
        self.id = id; self.name = name; self.breed = breed; self.sex = sex; self.status = status; self.colorCategory = colorCategory; self.birthdate = birthdate; self.intakeDate = intakeDate; self.weightKg = weightKg; self.descriptionText = descriptionText; self.photoURLs = photoURLs; self.tags = tags; self.shelter = shelter
    }

    enum CodingKeys: String, CodingKey { case id, name, breed, sex, status, colorCategory, birthdate, intakeDate, weightKg, descriptionText, photoURLs, tags, shelter }

    convenience init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
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

        let iso = ISO8601DateFormatter()
        let birthStr = try c.decodeIfPresent(String.self, forKey: .birthdate)
        let birthdate = birthStr.flatMap { iso.date(from: $0) }
        let intakeStr = try c.decode(String.self, forKey: .intakeDate)
        guard let intakeDate = iso.date(from: intakeStr) else {
            throw DecodingError.dataCorruptedError(forKey: .intakeDate, in: c, debugDescription: "Formato intakeDate inválido")
        }
        self.init(id: id, name: name, breed: breed, sex: sex, status: status, colorCategory: colorCategory, birthdate: birthdate, intakeDate: intakeDate, weightKg: weightKg, descriptionText: descriptionText, photoURLs: photoURLs, tags: tags, shelter: shelter)
    }
}

final class CatCollection: Codable {
    private(set) var items: [Cat] = []
    init(items: [Cat] = []) { self.items = items }
    convenience init(jsonData: Data) throws { self.init(items: try JSONDecoder().decode([Cat].self, from: jsonData)) }
    var count: Int { items.count }
    func sortedByIntakeDateAscending() -> [Cat] { items.sorted { $0.intakeDate < $1.intakeDate } }
}
