//
//  MainTabView.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HoursView()
                .tabItem {
                    Label("Horas", systemImage: "clock.fill")
                }
            HomeView()
                .tabItem {
                    Label("Clima", systemImage: "cloud.sun.fill")
                }
        }
    }
}
