# CatsAdoption (CLI + iOS UI)

## CLI (Codespaces/Linux/macOS)
```bash
swift build
swift run cats-cli
```

## iOS App (Xcode)
1) Añade este repo como **package local** y referencia `CatsCore`.
2) Copia `iOSApp/*.swift` y `iOSApp/Assets.xcassets` a tu target iOS.
3) Incluye `Resources/cats.json` en el **bundle** (Add to targets).
4) Run.
