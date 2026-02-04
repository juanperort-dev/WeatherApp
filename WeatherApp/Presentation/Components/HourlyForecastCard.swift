//
//  HourlyForecastView.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 17/1/26.
//

import SwiftUI

struct HourlyForecastCard: View {
    let forecastItems: [ForecastItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("PRONÓSTICO POR HORAS")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.8))
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(forecastItems) { item in
                        VStack(spacing: 8) {
                            Text(item.hour)
                                .font(.caption)
                            Image(systemName: item.icon)
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                            Text(item.temp)
                                .font(.body)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 10)
    }
}

// MARK: - Previews
#Preview {
    ZStack {
        LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
        
        HourlyForecastCard(forecastItems: [
            ForecastItem(hour: "Ahora", temp: "22°", icon: "cloud.sun.fill"),
            ForecastItem(hour: "14:00", temp: "23°", icon: "sun.max.fill"),
            ForecastItem(hour: "15:00", temp: "21°", icon: "cloud.fill"),
            ForecastItem(hour: "16:00", temp: "20°", icon: "cloud.rain.fill"),
            ForecastItem(hour: "17:00", temp: "19°", icon: "cloud.bolt.fill"),
            ForecastItem(hour: "18:00", temp: "18°", icon: "cloud.moon.fill"),
        ])
    }
}
