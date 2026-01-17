//
//  HomeView.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var searchText: String = ""
    @State private var isSearching = false
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        switch viewModel.state {
                        case .idle:
                            ContentUnavailableView("Busca una ciudad", systemImage: "magnifyingglass")
                                .foregroundColor(.white)
                        case .loading:
                            ProgressView().tint(.white).padding(.top, 100)
                        case .success(let weather):
                            WeatherMainContent(weather: weather)
                                .padding(.top, 40)
                            
                            renderDetailCards(weather: weather)
                                .padding(.horizontal)
                                .padding(.bottom, 30)
                            
                        case .error(let message):
                            Text(message).foregroundColor(.white).padding(.top, 100)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .background(
                    LinearGradient(colors: [.blue, .cyan.opacity(0.6)],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                )
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(
                    text: $searchText,
                    isPresented: $isSearching,
                    placement: .navigationBarDrawer(displayMode: .automatic),
                    prompt: "Buscar ciudad")
                .onSubmit(of: .search) {
                    if !searchText.isEmpty {
                        isSearching = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            withAnimation(.easeOut(duration: 0.25)) {
                                proxy.scrollTo("TOP", anchor: .top)
                            }
                        }
                        Task {
                            await viewModel.getCityWeather(city: searchText)
                            searchText = ""
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func renderDetailCards(weather: Weather) -> some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                WeatherDetailCard(title: "Humedad", value: "\(weather.humidity)%", icon: "humidity", color: .blue)
                WeatherDetailCard(title: "Viento", value: "\(Int(weather.windSpeed)) km/h", icon: "wind", color: .green)
            }
            HStack(spacing: 15) {
                WeatherDetailCard(title: "Sensación", value: "22°", icon: "thermometer.medium", color: .orange)
                WeatherDetailCard(title: "Visibilidad", value: "10 km", icon: "eye.fill", color: .purple)
            }
        }
    }
}

// MARK: - SubViews

struct WeatherMainContent: View {
    let weather: Weather
    
    var body: some View {
        VStack(spacing: 20) {
            Text(weather.cityName)
                .font(.system(size: 32, weight: .medium))
            
            Image(systemName: weather.conditionIcon)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
            
            Text(weather.temperatureString)
                .font(.system(size: 70, weight: .bold))
            
            Text(weather.condition.capitalized)
                .font(.title2)
            
            HStack(spacing: 15) {
                Text("Max: \(Int(weather.tempMax))°")
                Text("|")
                    .opacity(0.5)
                Text("Min: \(Int(weather.tempMin))°")
            }
            .font(.title3)
            .fontWeight(.medium)
        }
        .foregroundColor(.white)
    }
}

struct WeatherDetailItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
            Text(value).bold()
            Text(label).font(.caption)
        }
    }
}

// MARK: - Previews

#Preview("Pantalla Completa") {
    HomeView()
}

#Preview("Contenido Principal con Datos") {
    ZStack {
        Color.blue.ignoresSafeArea()
        WeatherMainContent(weather: .mock)
    }
}

#Preview("Tarjeta de Detalle Individual") {
    ZStack {
        Color.gray.ignoresSafeArea()
        WeatherDetailCard(
            title: "Humedad",
            value: "\(Weather.mock.humidity)%",
            icon: "humidity",
            color: .blue
        )
        .padding()
    }
}
