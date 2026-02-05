//
//  WeatherMapper.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 5/2/26.
//

import Foundation

struct WeatherMapper {
    static func mapIcon(_ iconCode: String) -> String {
        let iconMap = [
            "01d": "sun.max.fill", "01n": "moon.stars.fill",
            "02d": "cloud.sun.fill", "02n": "cloud.moon.fill",
            "03d": "cloud.fill", "03n": "cloud.fill",
            "04d": "smoke.fill", "04n": "smoke.fill",
            "09d": "cloud.drizzle.fill", "09n": "cloud.drizzle.fill",
            "10d": "cloud.sun.rain.fill", "10n": "cloud.moon.rain.fill",
            "11d": "cloud.bolt.rain.fill", "11n": "cloud.bolt.rain.fill",
            "13d": "snowflake", "13n": "snowflake",
            "50d": "cloud.fog.fill", "50n": "cloud.fog.fill"
        ]
        return iconMap[iconCode] ?? "cloud.fill"
    }
    
    static func groupForecastByDay(_ list: [HourlyDTO]) -> [DailyGroup] {
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "es_ES")
        dayFormatter.dateFormat = "EEEE, d 'de' MMMM"
        
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH:mm"
        
        var dayOrder: [String] = []
        var groupedDict: [String: [HourlyForecast]] = [:]
        
        for item in list {
            let date = Date(timeIntervalSince1970: item.dt)
            let dayName = dayFormatter.string(from: date).capitalized
            let speedInMS = item.wind?.speed ?? 0.0
            let speedInKMH = Int(speedInMS * 3.6)
            
            let model = HourlyForecast(
                time: hourFormatter.string(from: date),
                temp: "\(Int(item.main.temp))°",
                icon: mapIcon(item.weather.first?.icon ?? ""),
                pop: "\(Int((item.pop ?? 0) * 100))%",
                rainAmount: String(format: "%.1fmm", item.rain?.threeHours ?? 0.0),
                windSpeed: "\(speedInKMH) km/h"
            )
            
            if groupedDict[dayName] == nil {
                dayOrder.append(dayName)
                groupedDict[dayName] = []
            }
            groupedDict[dayName]?.append(model)
        }
        return dayOrder.map { DailyGroup(date: $0, hours: groupedDict[$0] ?? []) }
    }
}
