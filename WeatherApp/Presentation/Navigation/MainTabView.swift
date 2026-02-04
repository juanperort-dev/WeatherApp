//
//  MainTabView.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 2
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Pantalla de Días (Próximamente)")
                .tabItem {
                    Label("Días", systemImage: "calendar")
                }
                .tag(0)
            HoursView()
                .tabItem {
                    Label("Horas", systemImage: "clock.fill")
                }
                .tag(1)
            HomeView()
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }
                .tag(2)
            Text("Pantalla de Mapa (Próximamente)")
                .tabItem {
                    Label("Mapa", systemImage: "map.fill")
                }
                .tag(3)
            Text("Pantalla de Ajustes (Próximamente)")
                .tabItem {
                    Label("Ajustes", systemImage: "gearshape.fill")
                }
                .tag(4)
            
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
