//
//  HomeView.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: WeatherStore
    @StateObject private var viewModel: HomeViewModel
    @State private var searchText: String = ""
    @State private var isSearching = false
    
    // MARK: - Initialization
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    switch viewModel.state {
                    case .idle:
                        idleView
                    case .loading:
                        loadingView
                    case .success(let weather):
                        successContent(weather)
                    case .error(let message):
                        errorView(message)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .background(backgroundGradient)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadWeather(for: store.selectedCity)
            }
            .onChange(of: store.selectedCity) { newCity in
                Task { await viewModel.loadWeather(for: newCity) }
            }
            .searchable(
                text: $searchText,
                isPresented: $isSearching,
                prompt: "Buscar ciudad"
            )
            .onSubmit(of: .search) {
                handleSearchSubmit()
            }
        }
    }
}

// MARK: - Private View Components
private extension HomeView {
    var backgroundGradient: some View {
        LinearGradient(colors: [.blue, .cyan.opacity(0.6)],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }
    
    var idleView: some View {
        ContentUnavailableView("Busca una ciudad", systemImage: "magnifyingglass")
            .foregroundColor(.white)
            .padding(.top, 100)
    }
    
    var loadingView: some View {
        ProgressView()
            .tint(.white)
            .padding(.top, 100)
    }
    
    func errorView(_ message: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
            Text(message)
                .multilineTextAlignment(.center)
        }
        .foregroundColor(.white)
        .padding(.top, 100)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func successContent(_ weather: Weather) -> some View {
        WeatherMainContent(weather: weather)
            .padding(.top, 40)
        
        if !viewModel.hourlyForecast.isEmpty {
            HourlyForecastCard(forecastItems: viewModel.hourlyForecast)
                .padding(.vertical, 10)
        }
        
        renderDetailCards(weather: weather)
            .padding(.horizontal)
            .padding(.bottom, 30)
    }
    
    func handleSearchSubmit() {
        guard !searchText.isEmpty else { return }
        let searched = searchText
        searchText = ""
        isSearching = false
        store.selectedCity = searched
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
#Preview("Success") {
    HomeView(viewModel: HomeViewModel.mockSuccess())
        .environmentObject(WeatherStore())
}

#Preview("Componentes - Main Content") {
    ZStack {
        LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        
        ScrollView {
            VStack(spacing: 30) {
                WeatherMainContent(weather: .mock)
                
                HourlyForecastCard(forecastItems: ForecastItem.mockArray)
                
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
