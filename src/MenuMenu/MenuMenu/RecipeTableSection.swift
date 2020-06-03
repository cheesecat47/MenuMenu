//
//  RecipeTableSection.swift
//  MenuMenu
//
//  Created by refo on 2020/05/27.
//  Copyright © 2020 COMP420. All rights reserved.
//

import Foundation

class RecipeTable {
    
    let cellTitle: [String] = ["채소류","육류","향신료"]
    let ingredients: [String:Array<String>] = [
        "채소류": ["당근","양파","파","마늘"],
        "육류": ["소고기","양고기","돼지고기","닭고기"],
        "향신료": ["소금","후추"]
    ]
    
    var sections : [Int:Section] = [:]
    func getSections() -> [Int:Section] {
        return self.sections
    }
    
    static var identifierFactory = -1
    static func getUniqueId() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        for key in cellTitle {
            sections[RecipeTable.getUniqueId()] = Section(isMultiple: true, title: key, items: ingredients[key]!)
        }
//        dump("RecipeTableSection: init: sections: \(sections)")
    }
}

struct Section {
    var isMultiple: Bool
    var title: String
    var items: [Item] = []
    
    init(isMultiple: Bool, title: String, items: [String]) {
        self.isMultiple = isMultiple
        self.title = title
        for item in items {
            self.items.append(Item(name: item))
        }
    }
}

struct Item {
    var id: Int
    var name: String
    var selected: Bool = false
    
    static var identifierFactory = 0
    static func getUniqueId() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init(name: String) {
        self.id = Item.getUniqueId()
        self.name = name
    }
}
