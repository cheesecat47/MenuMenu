//
//  RecipeSummaryView.swift
//  MenuMenu
//
//  Created by jinkyuhan on 2020/06/11.
//  Copyright © 2020 COMP420. All rights reserved.
//

import Foundation
class RecipeSummaryView {
    var id: Int
    var foodName: String
    var imgPath: URL?
    
    init(id: Int, name: String, imgPath: URL?) {
        self.id = id
        self.foodName = name
        self.imgPath = imgPath
    }
}
