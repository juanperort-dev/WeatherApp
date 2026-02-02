# 🌦️ WeatherPro - Professional Weather App

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B-blue.svg)](https://www.apple.com/ios/)
[![Architecture](https://img.shields.io/badge/Architecture-MVVM%20+%20Repository-green.svg)]()

**WeatherPro** es una aplicación de meteorología de alto rendimiento diseñada bajo estándares de ingeniería de software modernos. Este proyecto forma parte de mi portfolio profesional y demuestra el uso de arquitecturas limpias, concurrencia avanzada y las últimas tecnologías de Apple.

---

## 🚀 Características Principales

- **Pronóstico en Tiempo Real:** Datos precisos utilizando **OpenWeather API**.
- **Geolocalización:** Uso de **CoreLocation** para clima basado en la ubicación del usuario.
- **Gráficos Avanzados:** Visualización de tendencias de temperatura con **Swift Charts**.
- **Modo Offline:** Persistencia de datos local mediante **SwiftData**.
- **Widgets:** Soporte para la pantalla de inicio con **WidgetKit**.

## 🏗️ Arquitectura y Buenas Prácticas

La aplicación sigue el patrón **MVVM (Model-View-ViewModel)** combinado con el **Repository Pattern**, garantizando un código modular, escalable y fácil de testear.

- **Domain Layer:** Contiene los modelos de negocio puros y las definiciones de protocolos (Interfaces).
- **Data Layer:** Implementa los repositorios, la lógica de red (API) y la persistencia local.
- **Presentation Layer:** Vistas reactivas en SwiftUI y ViewModels que gestionan el estado de la UI.
- **Dependency Injection:** Implementada a través de inicializadores para facilitar el Unit Testing.
- **Swift Concurrency:** Uso nativo de `async/await` para todas las operaciones asíncronas.

## 🛠️ Stack Tecnológico

- **Lenguaje:** Swift 6
- **UI Framework:** SwiftUI
- **Data:** OpenWeather API, SwiftData, CoreLocation
- **Tooling:** SwiftLint (Code Quality), Git (Version Control)

## 📸 Screenshots
<p align="center">
  <img
    src="https://github.com/user-attachments/assets/d23e5c25-32eb-4e02-b9e4-936e7ab9bdd3"
    width="300"
  />
</p>


---

## 🛠️ Instalación y Requisitos

1. Clonar el repositorio: `git clone https://github.com/juanperort-dev/WeatherApp-Pro.git`
2. Abrir `WeatherApp.xcodeproj` en **Xcode 15+**.
3. Crear un archivo `Config.xcconfig` y añadir `OPENWEATHER_API_KEY = YOUR_API_KEY`.
4. Configurar el target de la app en Info.plist `Key = API_KEY` y `Value = $(OPENWEATHER_API_KEY)`.
5. Configurar en el target `Debug` y `Release` para que utilicen este nuevo archivo.

---

## 👤 Autor
**Juan José Perálvarez Ortiz**
- [LinkedIn](https://www.linkedin.com/in/juanperort/)
- [Portfolio]()
