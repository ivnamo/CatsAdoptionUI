import Foundation

public enum AdoptionStatus: String, Codable, CaseIterable { case available, reserved, adopted }
public enum Sex: String, Codable, CaseIterable { case male, female, unknown }
public enum ColorCategory: String, Codable, CaseIterable { case primary, secondary, success, warning, danger, info, neutral }

public final class Shelter: Codable, Identifiable {
    public let id: UUID
    public var name, address, city, country: String
    public var latitude, longitude: Double
    public var website, youtube, instagram: URL?
    public init(id: UUID = UUID(), name: String, address: String, city: String, country: String,
                latitude: Double, longitude: Double, website: URL? = nil, youtube: URL? = nil, instagram: URL? = nil) {
        self.id = id; self.name = name; self.address = address; self.city = city; self.country = country
        self.latitude = latitude; self.longitude = longitude
        self.website = website; self.youtube = youtube; self.instagram = instagram
    }
}

public final class Cat: Codable, Identifiable {
    public let id: UUID
    public var name, breed: String
    public var sex: Sex
    public var status: AdoptionStatus
    public var colorCategory: ColorCategory
    public var birthdate: Date?
    public var intakeDate: Date
    public var weightKg: Double
    public var descriptionText: String
    public var photoURLs: [URL]
    public var tags: [String]
    public var shelter: Shelter
    public init(id: UUID = UUID(), name: String, breed: String, sex: Sex, status: AdoptionStatus,
                colorCategory: ColorCategory, birthdate: Date?, intakeDate: Date, weightKg: Double,
                descriptionText: String, photoURLs: [URL], tags: [String], shelter: Shelter) {
        self.id = id; self.name = name; self.breed = breed; self.sex = sex; self.status = status
        self.colorCategory = colorCategory; self.birthdate = birthdate; self.intakeDate = intakeDate
        self.weightKg = weightKg; self.descriptionText = descriptionText; self.photoURLs = photoURLs
        self.tags = tags; self.shelter = shelter
    }
    enum CodingKeys: String, CodingKey { case id, name, breed, sex, status, colorCategory, birthdate, intakeDate, weightKg, descriptionText, photoURLs, tags, shelter }
    public convenience init(from decoder: Decoder) throws {
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
        guard let intake = iso.date(from: try c.decode(String.self, forKey: .intakeDate)) else {
            throw DecodingError.dataCorruptedError(forKey: .intakeDate, in: c, debugDescription: "Invalid intakeDate")
        }
        self.init(id: id, name: name, breed: breed, sex: sex, status: status, colorCategory: colorCategory,
                  birthdate: birthdate, intakeDate: intake, weightKg: weightKg, descriptionText: descriptionText,
                  photoURLs: photoURLs, tags: tags, shelter: shelter)
    }
}

public final class CatCollection: Codable {
    private(set) public var items: [Cat] = []
    public init(items: [Cat] = []) { self.items = items }
    public convenience init(jsonData: Data) throws {
        let dec = JSONDecoder()
        self.init(items: try dec.decode([Cat].self, from: jsonData))
    }
    public var count: Int { items.count }
    public func sortedByIntakeDateAscending() -> [Cat] { items.sorted { $0.intakeDate < $1.intakeDate } }
}
