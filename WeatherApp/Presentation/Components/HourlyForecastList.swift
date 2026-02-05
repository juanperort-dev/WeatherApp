//
//  HourlyRowItem.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 31/1/26.
//

import SwiftUI

struct HourlyForecastList: View {
    let hourlyItems: [HourlyForecast]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(hourlyItems, id: \.id) { item in
                HStack(spacing: 25) {
                    Text(item.time)
                        .font(.subheadline).bold()
                    Image(systemName: item.icon)
                        .renderingMode(.original)
                        .font(.title3)
                        .frame(width: 40)
                    Text(item.temp)
                        .font(.callout).bold()
                    
                    VStack(alignment: .center, spacing: 5) {
                        HStack(spacing: 12) {
                            HourlyDataLabel(icon: "drop.fill", value: item.pop, iconColor: .cyan)
                            HourlyDataLabel(icon: "umbrella.fill", value: item.rainAmount, iconColor: .blue)
                        }
                        HourlyDataLabel(icon: "wind", value: item.windSpeed, iconColor: .white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .bold()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                if item.id != hourlyItems.last?.id {
                    Divider()
                        .background(Color.white.opacity(0.15))
                        .padding(.horizontal, 15)
                }
            }
        }
        .foregroundStyle(.white)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 15)
        
    }
    
}

// MARK: - Previews
#Preview {
    ZStack {
        LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        
        HourlyForecastList(hourlyItems: HourlyForecast.mockArray)
    }
}

