# 🌦️ WeatherPro — Professional Weather App

<p align="center">
  <a href="https://juanperort.dev">
    <img src="https://img.shields.io/badge/Portfolio-juanperort.dev-111827?style=for-the-badge&logo=google-chrome&logoColor=white" alt="Portfolio" />
  </a>
  <a href="https://www.linkedin.com/in/juanperort/">
    <img src="https://img.shields.io/badge/LinkedIn-Juan%20Jos%C3%A9%20Per%C3%A1lvarez%20Ortiz-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn" />
  </a>
</p>

<p align="center">
  <a href="https://swift.org">
    <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift 6.0" />
  </a>
  <a href="https://www.apple.com/ios/">
    <img src="https://img.shields.io/badge/Platform-iOS%2017%2B-blue.svg" alt="iOS 17+" />
  </a>
  <img src="https://img.shields.io/badge/Architecture-MVVM%20%2B%20Repository-green.svg" alt="Architecture" />
</p>

**WeatherPro** is a high-performance weather application built with modern Apple technologies and production-oriented software engineering practices.  
This project is part of my professional portfolio and showcases clean architecture, advanced concurrency, local persistence, and a scalable SwiftUI codebase.

> 🚀 Explore this and other projects in my portfolio: **[juanperort.dev](https://juanperort.dev)**

---

## 🎬 Demo

- **Portfolio case study:** [juanperort.dev](https://juanperort.dev)
- **App preview:** See the screenshots below

## 📸 Screenshots

<p align="center">
  <img
    src="https://github.com/user-attachments/assets/2957876b-20bc-4a99-97e0-4e32870c7ab6"
    width="300"
    alt="WeatherPro screenshot 1"
  />
  <img
    src="https://github.com/user-attachments/assets/5f249b00-8f02-4b35-9810-aebf3cb374c5"
    width="300"
    alt="WeatherPro screenshot 2"
  />
</p>

---

## ✨ Why this project stands out

This project was built to demonstrate professional iOS development practices beyond basic UI implementation. It focuses on:
- Clean and scalable architecture
- Separation of concerns through MVVM and Repository Pattern
- Modern asynchronous programming with `async/await`
- Offline data persistence with SwiftData
- Native Apple framework integration for a polished user experience

---

## 🚀 Features

- **Real-Time Weather:** Accurate forecast data powered by **OpenWeather API**
- **Location-Based Forecasts:** Integrated with **CoreLocation**
- **Interactive Charts:** Temperature trends built with **Swift Charts**
- **Offline Support:** Local data persistence using **SwiftData**
- **Home Screen Widgets:** Widget support with **WidgetKit**

---

## 🏗️ Architecture

The application follows **MVVM (Model-View-ViewModel)** combined with the **Repository Pattern**, enabling a modular, maintainable, and testable codebase.

- **Domain Layer:** Pure business models and protocol definitions
- **Data Layer:** Repository implementations, networking, and local persistence
- **Presentation Layer:** SwiftUI views and ViewModels managing UI state
- **Dependency Injection:** Constructor-based injection to improve modularity and testability
- **Swift Concurrency:** Native `async/await` used across asynchronous flows

---

## 🧱 Project Structure

```bash
WeatherPro/
├── Domain/          # Business models and protocols
├── Data/            # Repositories, API services, persistence
├── Presentation/    # SwiftUI views and ViewModels
├── Core/            # Shared utilities, helpers, constants
├── Resources/       # Assets and configuration files
└── Widgets/         # Home screen widgets
```

---

## 🛠️ Tech Stack

- **Language:** Swift 6
- **UI Framework:** SwiftUI
- **Architecture:** MVVM + Repository Pattern
- **Persistence:** SwiftData
- **Location Services:** CoreLocation
- **Data Visualization:** Swift Charts
- **Widgets:** WidgetKit
- **API:** OpenWeather API
- **Tooling:** SwiftLint, Git

---

## ✅ Code Quality

This project is designed with maintainability and scalability in mind.

- Clean architecture with clear layer separation
- Dependency Injection for loose coupling
- Async code built with native Swift Concurrency
- Readable and modular SwiftUI components
- SwiftLint integration for consistent code style
- Structure prepared for unit testing and future expansion

---

## ⚙️ Getting Started

### Requirements

- Xcode 15+
- iOS 17+
- OpenWeather API key

### Installation

1. Clone the repository:

```bash
git clone https://github.com/juanperort-dev/WeatherApp-Pro.git
```

2. Open the project in Xcode:

```bash
open WeatherApp.xcodeproj
```

3. Create a `Config.xcconfig` file and add your API key:

```xcconfig
OPENWEATHER_API_KEY = YOUR_API_KEY
```

4. In `Info.plist`, add the following key:
- **Key:** `API_KEY`
- **Value:** `$(OPENWEATHER_API_KEY)`

5. Assign the `Config.xcconfig` file to both **Debug** and **Release** configurations

---

## 🚧 Roadmap

- [ ] Add unit tests for ViewModels and business logic
- [ ] Improve offline caching strategy
- [ ] Support multiple saved locations
- [ ] Add more forecast insights and advanced charts
- [ ] Enhance widget customization

---

## 👨‍💻 Author

**Juan José Perálvarez Ortiz**

iOS developer focused on building clean, scalable, and modern applications for Apple platforms.

- [Portfolio](https://juanperort.dev)
- [LinkedIn](https://www.linkedin.com/in/juanperort/)
