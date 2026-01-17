//
//  HomeView.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var searchText: String = ""
    @State private var isSearching = false
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    init() {
        self.init(viewModel: HomeViewModel())
    }
    
    var body: some View {
        NavigationStack {
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
                        
                        if !viewModel.hourlyForecast.isEmpty {
                            HourlyForecastView(forecastItems: viewModel.hourlyForecast)
                                .padding(.vertical, 10)
                        }
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
                    Task {
                        await viewModel.getCityWeather(city: searchText)
                        searchText = ""
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
        VStack(spacing: 10) {
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

#Preview("HomeView - Estados de Carga") {
    HomeView()
}

#Preview("HomeView - Éxito (Success)") {
    HomeView(viewModel: .mockSuccess())
}

#Preview("Componentes - Main Content") {
    ZStack {
        LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        
        ScrollView {
            VStack(spacing: 30) {
                WeatherMainContent(weather: .mock)
                
                HourlyForecastView(forecastItems: ForecastItem.mockArray)
                
                HStack(spacing: 15) {
                    WeatherDetailCard(title: "Humedad", value: "70%", icon: "humidity", color: .blue)
                    WeatherDetailCard(title: "Viento", value: "15 km/h", icon: "wind", color: .green)
                }
                .padding(.horizontal)
                HStack(spacing: 15) {
                    WeatherDetailCard(title: "Sensación", value: "22°", icon: "thermometer.medium", color: .orange)
                    WeatherDetailCard(title: "Visibilidad", value: "10 km", icon: "eye.fill", color: .purple)
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview("Detail Cards - Variaciones") {
    VStack(spacing: 20) {
        WeatherDetailCard(title: "Humedad", value: "70%", icon: "humidity", color: .blue)
        WeatherDetailCard(title: "Viento", value: "15 km/h", icon: "wind", color: .green)
        WeatherDetailCard(title: "Sensación", value: "22°", icon: "thermometer.medium", color: .orange)
        WeatherDetailCard(title: "Visibilidad", value: "10 km", icon: "eye.fill", color: .purple)
    }
    .padding()
    .background(LinearGradient(colors: [.blue, .cyan.opacity(0.6)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
        .ignoresSafeArea())
}
