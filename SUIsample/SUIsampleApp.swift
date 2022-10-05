//
//  SUIsampleApp.swift
//  SUIsample
//
//  Created by kook on 2022/10/05.
//

import SwiftUI

@main
struct SUIsampleApp: App {
    var body: some Scene {
        WindowGroup {
            //ContentView()
            NavigationView {
                ExpenseHome()
                    .toolbar(.hidden)
            }
            
        }
    }
}
