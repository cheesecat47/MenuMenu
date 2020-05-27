//
//  RecipeListViewController.swift
//  MenuMenu
//
//  Created by refo on 2020/05/24.
//  Copyright © 2020 COMP420. All rights reserved.
//

import UIKit

class RecipeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var ingredientsSelectView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier: String = "cell"
    
    let cellTitle: [String] = ["채소류","육류","향신료"]
    let ingredients: [String:Array<String>] = [
        "채소류": ["당근","양파","파","마늘"],
        "육류": ["소고기","양고기","돼지고기","닭고기"],
        "향신료": ["소금","후추"]
    ]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 각 섹션 타이틀 문자열 반환
        return cellTitle[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 테이블 뷰의 한 섹션당 몇 개의 셀을 담을것인지 반환
        return ingredients[cellTitle[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 각 셀을 반환.
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let text: String = ingredients[cellTitle[indexPath.section]]![indexPath.row]
        
        cell.textLabel?.text = text
        
        return cell
    }
}
