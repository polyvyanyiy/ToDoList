//
//  Resource.swift
//  ToDoListTask
//
//  Created by Иван on 21.05.2026.
//

import UIKit

enum R {
    
    enum Color {
        static let value = UIColor(hex: "#F4F4F4")
        static let backgroundView = UIColor(hex: "#272729")
    }
    
    enum searchTextField {
        
        enum Color {}
        
        enum String {
            static let placeholder = "Search"
        }
        
        enum image {
            static let search = UIImage(named: "search")
            static let mike = UIImage(named: "mike")
        }
    }
    
    enum BottomView {
        
        enum Color {
            static let orangeIcon = UIColor(hex: "#FED702")
        }
        
        enum String {}
        
        enum image {
            static let edit = UIImage(named: "edit")
        }
    }
    
    enum TableView {
        
        enum Color {
            static let borderFonMain = UIColor(hex: "#EDEDED")
        }
        
        enum String {}
        
        enum image {
            static let iconNil = UIImage(named: "IconNil")
            static let iconOK = UIImage(named: "IconOK")
        }
    }
    
    enum EditTaskView {
        
        enum Color {
            static let backgroundColor = UIColor(hex: "#272729")
        }
        
        enum String {}
        
        enum image {}
    }
    
    enum EditTaskMenuView {
        
        enum Color {}
        
        enum String {}
        
        enum image {
            static let editMenu = UIImage(named: "editMenu")
            static let delMenu = UIImage(named: "delMenu")
            static let exportMenu = UIImage(named: "exportMenu")
        }
    }
}

