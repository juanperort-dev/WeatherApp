//
//  HoursView.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 31/1/26.
//

import SwiftUI

struct HoursView: View {
    // MARK: - Properties
    @EnvironmentObject var store: WeatherStore
    @StateObject private var viewModel: HoursViewModel
    
    // MARK: - Initialization
    init(viewModel: HoursViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                
                switch viewModel.state {
                case .loading:
                    loadingView
                case .error(let message):
                    errorContent(message)
                case .success(let dailyGroups):
                    forecastList(dailyGroups)
                case .idle:
                    Color.clear
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.getForecast(for: store.selectedCity)
            }
            .onChange(of: store.selectedCity) { newCity in
                Task { await viewModel.getForecast(for: newCity) }
            }
        }
    }
}

// MARK: - Private View Components
private extension HoursView {
    var backgroundGradient: some View {
        LinearGradient(colors: [.blue, .cyan.opacity(0.8)], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
    
    var loadingView: some View {
        ProgressView("Cargando pronóstico...")
            .tint(.white)
            .foregroundColor(.white)
            .font(.title2)
    }
    
    func errorContent(_ message: String) -> some View {
        ContentUnavailableView {
            Label("Error de Carga", systemImage: "exclamationmark.triangle.fill")
        } description: {
            Text(message)
        } actions: {
            Button("Reintentar") {
                Task { await viewModel.getForecast(for: store.selectedCity) }
            }
        }
        .foregroundColor(.white)
    }
    
    func forecastList(_ groups: [DailyGroup]) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                ForEach(groups) { group in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(group.date)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                        
                        HourlyForecastList(hourlyItems: group.hours)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Previews
#Preview("Success") {
    HoursView(viewModel: HoursViewModel.mockSuccess())
        .environmentObject(WeatherStore())
}
