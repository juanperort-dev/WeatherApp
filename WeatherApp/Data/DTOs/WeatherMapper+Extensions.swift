//
//  WeatherMapper+Extensions.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 5/2/26.
//

import Foundation

extension CurrentWeatherDTO {
    func toDomain() -> Weather {
        return Weather(
            cityName: self.name,
            temperature: self.main.temp,
            tempMax: self.main.tempMax ?? self.main.temp,
            tempMin: self.main.tempMin ?? self.main.temp,
            condition: self.weather.first?.description.capitalized ?? "Sin descripción",
            conditionIcon: WeatherMapper.mapIcon(self.weather.first?.icon ?? ""),
            humidity: self.main.humidity ?? 0,
            windSpeed: self.wind.speed
        )
    }
}

extension HourlyDTO {
    func toForecastItem() -> ForecastItem {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return ForecastItem(
            hour: formatter.string(from: self.date),
            temp: "\(Int(self.main.temp))°",
            icon: WeatherMapper.mapIcon(self.weather.first?.icon ?? "")
        )
    }
    
    func toHourlyForecast() -> HourlyForecast {
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH:mm"
        
        let speedInMS = self.wind?.speed ?? 0.0
        let speedInKMH = Int(speedInMS * 3.6)
        
        return HourlyForecast(
            time: hourFormatter.string(from: self.date),
            temp: "\(Int(self.main.temp))°",
            icon: WeatherMapper.mapIcon(self.weather.first?.icon ?? ""),
            pop: "\(Int((self.pop ?? 0) * 100))%",
            rainAmount: String(format: "%.1fmm", self.rain?.threeHours ?? 0.0),
            windSpeed: "\(speedInKMH) km/h"
        )
    }
}
