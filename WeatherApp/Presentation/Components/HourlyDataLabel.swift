//
//  HourlyDataLAbel.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 31/1/26.
//

import SwiftUI

struct HourlyDataLabel: View {
    let icon: String
    let value: String
    let iconColor: Color
    
    var body: some View {
        HStack() {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.caption)
            Text(value)
                .font(.caption)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    HourlyDataLabel(icon: "cloud.fill", value: "10 ºC", iconColor: Color.blue)
    HourlyDataLabel(icon: "cloud.fill", value: "5 ºC", iconColor: Color.blue)
    HourlyDataLabel(icon: "cloud.fill", value: "7 ºC", iconColor: Color.blue)
    HourlyDataLabel(icon: "cloud.fill", value: "6 ºC", iconColor: Color.blue)
}
