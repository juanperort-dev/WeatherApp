//
//  CitySelectionView.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 6/2/26.
//

import SwiftUI
import SwiftData

struct CitySelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: WeatherStore
    
    @Query(sort: \FavoriteCity.name) private var favoriteCities: [FavoriteCity]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(favoriteCities) { city in
                    cityRow(city)
                }
                .onDelete(perform: deleteCity)
            }
            .navigationTitle("Ciudades Guardadas")
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                if favoriteCities.isEmpty {
                    ContentUnavailableView("Sin Favoritos", systemImage: "star.slash")
                }
            }
        }
    }
    
    private func cityRow(_ city: FavoriteCity) -> some View {
        Button {
            store.selectCity(city.name)
            dismiss()
        } label: {
            HStack {
                Text(city.name).foregroundColor(.primary)
                Spacer()
                if store.selectedCity == city.name {
                    Image(systemName: "checkmark").foregroundColor(.blue)
                }
            }
        }
    }
    
    private func deleteCity(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(favoriteCities[index])
        }
    }
}

#Preview {
    CitySelectionView()
}
