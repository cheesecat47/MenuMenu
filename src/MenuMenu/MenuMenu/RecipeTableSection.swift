//
//  RecipeTableSection.swift
//  MenuMenu
//
//  Created by refo on 2020/05/27.
//  Copyright © 2020 COMP420. All rights reserved.
//

import Foundation

class RecipeTable {

    private let ingredientNames: [String]
    
    private var sections : [Int:Section] = [:]
    func getSections() -> [Int:Section] {
        return self.sections
    }
    
    private static var identifierFactory = -1
    static func getUniqueId() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.ingredientNames = RecipeRepository.shared.getAllIngredientName()
        dump("RecipeTable: init: get ingredientNames from db")
        sections[RecipeTable.getUniqueId()] = Section(isMultiple: true, title: "재료 목록", items: self.ingredientNames)
        dump("RecipeTable: init: set sections")
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
