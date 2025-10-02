import SwiftUI
import CatsCore

struct ContentView: View {
    @EnvironmentObject var vm: CatsViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image("AppLogo")
                    .resizable().scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(radius: 6)

                Text("Adopción de Gatos").font(.title2).bold()

                if let e = vm.errorMessage {
                    Text("Error: \(e)").foregroundStyle(.red)
                }

                List(vm.cats) { cat in
                    HStack(spacing: 12) {
                        Circle().fill(color(for: cat).opacity(0.2))
                            .frame(width: 44, height: 44)
                            .overlay(Text(String(cat.name.prefix(1))).bold())
                        VStack(alignment: .leading) {
                            Text(cat.name).font(.headline)
                            Text("\(cat.breed) • \(cat.shelter.city)")
                                .font(.subheadline).foregroundStyle(.secondary)
                            Text(cat.status.rawValue.capitalized)
                                .font(.caption)
                                .padding(.horizontal, 8).padding(.vertical, 3)
                                .background(color(for: cat).opacity(0.15))
                                .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding(.vertical, 6)
                }
                .listStyle(.insetGrouped)
            }
            .padding()
            .navigationTitle("Inicio")
        }
    }

    private func color(for cat: Cat) -> Color {
        switch cat.status {
        case .available: return .green
        case .reserved:  return .orange
        case .adopted:   return .blue
        }
    }
}
