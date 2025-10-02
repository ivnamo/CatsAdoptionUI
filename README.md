// ===============================================================
//  Archivo: README.md
//  Proyecto: CatsAdoptionUI
//  Descripción: Instrucciones rápidas y notas.
//  Nota: Este archivo está *super comentado* para uso didáctico.
//  (Puedes borrar comentarios cuando pases a producción.)
// ===============================================================

# CatsAdoptionUI (EXTRA-COMMENTED)

Este proyecto incluye **comentarios exhaustivos** en todos los archivos:
- `CatsAdoptionUIApp.swift` → Inicio de app + impresión de JSON en consola (solo DEBUG).
- `ContentView.swift` → UI con logo y lista de gatos.
- `Models/*.swift` → Modelos, VM y utilidades con doc y notas.
- `Resources/cats.json` → Datos de ejemplo.
- `Assets.xcassets/AppLogo.imageset` → Logo placeholder (cámbialo por el tuyo).

## Uso (Xcode)
1. Crea un proyecto iOS (SwiftUI) o abre uno vacío.
2. Arrastra **todo el contenido** de esta carpeta al proyecto (marca **Add to targets**).
3. Ejecuta en simulador.
4. Abre la **Console** de Xcode para ver:
   - JSON RAW
   - JSON Pretty
   - Resumen (count y primer gato por antigüedad)

> Si no ves comentarios: verifica que abres los archivos **.swift** correctos desde el navegador del proyecto, no el producto compilado.
