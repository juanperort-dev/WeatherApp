//
//  HomeView.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .cyan.opacity(0.6)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    switch viewModel.state {
                    case .idle:
                        Color.clear.onAppear {
                            Task { await viewModel.getCityWeather(city: "Madrid") }
                        }
                    case .loading:
                        ProgressView().tint(.white).padding(.top, 100)
                        
                    case .success(let weather):
                        WeatherMainContent(weather: weather)
                            .padding(.top, 40)
                        
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
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                        
                    case .error(let message):
                        Text(message).foregroundColor(.white).padding(.top, 100)
                    }
                }
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
            
            HStack(spacing: 40) {
                WeatherDetailItem(icon: "humidity", value: "\(weather.humidity)%", label: "Humedad")
                WeatherDetailItem(icon: "wind", value: "\(Int(weather.windSpeed)) km/h", label: "Viento")
            }
            .padding(.top)
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
