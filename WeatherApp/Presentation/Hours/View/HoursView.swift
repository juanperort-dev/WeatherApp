//
//  HoursView.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 31/1/26.
//

import SwiftUI

struct HoursView: View {
    @EnvironmentObject var store: WeatherStore
    @StateObject private var viewModel = HoursViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.blue, .cyan.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    if viewModel.isLoading {
                        ProgressView("Cargando pronóstico...")
                            .tint(.white)
                            .foregroundColor(.white)
                            .font(.title2)
                    } else if let error = viewModel.errorMessage {
                        ContentUnavailableView {
                            Label("Error de Carga", systemImage: "exclamationmark.triangle.fill")
                        } description: {
                            Text(error)
                        } actions: {
                            Button("Reintentar") {
                                Task { await viewModel.getForecast(for: store.selectedCity) }
                            }
                        }
                        .foregroundColor(.white)
                    } else if viewModel.dailyGroups.isEmpty {
                        ContentUnavailableView {
                            Label("No hay datos disponibles", systemImage: "cloud.slash.fill")
                        } description: {
                            Text("No se encontró pronóstico para \(store.selectedCity).")
                        }
                        .foregroundColor(.white)
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 30) {
                                ForEach(viewModel.dailyGroups) { group in
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

// MARK: - Previews

struct HoursView_Previews: PreviewProvider {
    static var previews: some View {
        HoursView()
    }
}

#Preview {
    HoursView()
}
