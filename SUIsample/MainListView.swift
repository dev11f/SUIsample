//
//  MainListView.swift
//  SUIsample
//
//  Created by kook on 2022/10/05.
//

import SwiftUI
import UIKit

struct MainListView: View {

    enum Contents: String, CaseIterable {
        case expenseTracker
        
        var title: String {
            switch self {
            case .expenseTracker: return "Expense Tracker"
            }
        }
        
        var view: some View {
            switch self {
            case .expenseTracker: return ExpenseHome()
            }
        }
    }
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Contents.allCases, id: \.rawValue) { content in
                    NavigationLink {
                        content.view
                            .toolbar(.hidden)
                    } label: {
                        Text(content.title)
                    }
                }
            }
        }
    }
}

// https://stackoverflow.com/a/68650943/8293462
// 네비게이션바 안보여도 백스와이프 되도록
extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}

struct MainListView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}
