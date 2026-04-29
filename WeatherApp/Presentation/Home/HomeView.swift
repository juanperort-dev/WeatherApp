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
    @State private var showCitySheet = false
    @State private var scrollOffset: CGFloat = 0
    @State private var lastScrollOffset: CGFloat = 0
    @State private var toolbarVisible: Bool = true
    @FocusState private var isSearchFocused: Bool
    
    // MARK: - Initialization
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollViewWithOffset(offset: $scrollOffset) {
                VStack(spacing: 25) {
                    VStack(spacing: 0) {
                        HStack(spacing: 12) {
                            searchBar
                            cityButton
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                        .opacity(toolbarVisible ? 1 : 0)
                        .animation(.easeInOut(duration: 0.25), value: toolbarVisible)
                    }
                    
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
            .navigationTitle("")
            .toolbarBackground(.hidden, for: .navigationBar)
            .sheet(isPresented: $showCitySheet) {
                CitySelectionView()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .task {
                await viewModel.loadWeather(for: store.selectedCity)
            }
            .onChange(of: store.selectedCity) { newCity in
                Task { await viewModel.loadWeather(for: newCity) }
            }
            .onChange(of: scrollOffset) { newOffset in
                handleScrollChange(newOffset)
            }
        }
    }
}

// MARK: - Private View Components
private extension HomeView {
    var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.system(size: 17, weight: .regular))
            
            TextField("Buscar ciudad", text: $searchText)
                .textFieldStyle(.plain)
                .focused($isSearchFocused)
                .submitLabel(.search)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.words)
                .onSubmit {
                    handleSearchSubmit()
                }
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 17, weight: .regular))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.white.opacity(0.15), lineWidth: 0.5)
        )
        .frame(maxWidth: .infinity)
    }
    
    var cityButton: some View {
        Button {
            showCitySheet = true
        } label: {
            Image(systemName: "list.bullet.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 35))
                .foregroundColor(.white)
        }
        .buttonStyle(.plain)
    }
    
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
        isSearchFocused = false
        store.selectedCity = searched
    }
    
    func handleScrollChange(_ newOffset: CGFloat) {
        let threshold: CGFloat = 10
        let delta = newOffset - lastScrollOffset
        
        if newOffset < 50 {
            toolbarVisible = true
        }
        else if delta > threshold {
            toolbarVisible = false
        }
        else if delta < -threshold {
            toolbarVisible = true
        }
        
        lastScrollOffset = newOffset
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

// MARK: - Scroll Offset Tracking
struct ScrollViewWithOffset<Content: View>: View {
    @Binding var offset: CGFloat
    let content: Content
    
    init(offset: Binding<CGFloat>, @ViewBuilder content: () -> Content) {
        self._offset = offset
        self.content = content()
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            GeometryReader { geometry in
                Color.clear.preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geometry.frame(in: .named("scrollView")).minY
                )
            }
            .frame(height: 0)
            
            content
        }
        .coordinateSpace(name: "scrollView")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            offset = -value
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
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

#Preview("Search Bar") {
    ZStack {
        LinearGradient(colors: [.blue, .cyan.opacity(0.6)],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .ignoresSafeArea()
        
        VStack(spacing: 20) {
            // Sin texto
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                        .font(.system(size: 17, weight: .regular))
                    
                    Text("Buscar ciudad")
                        .foregroundColor(.secondary)
                        .font(.system(size: 17))
                    
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.15), lineWidth: 0.5)
                )
                
                Button {} label: {
                    Image(systemName: "list.bullet.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            
            // Con texto
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                        .font(.system(size: 17, weight: .regular))
                    
                    Text("Madrid")
                        .foregroundColor(.primary)
                        .font(.system(size: 17))
                    
                    Spacer()
                    
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 17, weight: .regular))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.15), lineWidth: 0.5)
                )
                
                Button {} label: {
                    Image(systemName: "list.bullet.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 100)
    }
}
