import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: CatsViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(radius: 6)

                Text("Adopción de Gatos")
                    .font(.title2).bold()
                    .foregroundStyle(.primary)

                if let error = vm.errorMessage {
                    Text("Error: \(error)")
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                }

                List(vm.cats) { cat in
                    CatRow(cat: cat)
                }
                .listStyle(.insetGrouped)
            }
            .padding()
            .navigationTitle("Inicio")
        }
    }
}

struct CatRow: View {
    let cat: Cat
    private var statusColor: Color {
        switch cat.status {
        case .available: return .green
        case .reserved:  return .orange
        case .adopted:   return .blue
        }
    }
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(statusColor.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay(Text(String(cat.name.prefix(1))).bold())
            VStack(alignment: .leading, spacing: 4) {
                Text(cat.name).font(.headline)
                Text("\(cat.breed) • \(cat.shelter.city)")
                    .font(.subheadline).foregroundStyle(.secondary)
                Text(cat.status.rawValue.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(statusColor.opacity(0.15))
                    .clipShape(Capsule())
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

#Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let shelter = Shelter(name: "Refugio Demo", address: "C/ Demo 1", city: "Madrid", country: "España", latitude: 40.4, longitude: -3.7)
        let sample = Cat(name: "Luna", breed: "European Shorthair", sex: .female, status: .available, colorCategory: .primary, birthdate: nil, intakeDate: Date(), weightKg: 3.5, descriptionText: "Demo preview", photoURLs: [], tags: ["demo"], shelter: shelter)
        let vm = CatsViewModel(); vm.cats = [sample]
        return ContentView().environmentObject(vm)
    }
}
