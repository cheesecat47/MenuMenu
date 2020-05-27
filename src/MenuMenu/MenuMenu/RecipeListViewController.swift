//
//  RecipeListViewController.swift
//  MenuMenu
//
//  Created by refo on 2020/05/24.
//  Copyright © 2020 COMP420. All rights reserved.
//

import UIKit

class RecipeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    https://stackoverrun.com/ko/q/11646578 여기 참고함.
    
    @IBOutlet weak var ingredientsSelectView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier: String = "cell"
    
    var recipeTable = RecipeTable()
    lazy var sections = recipeTable.getSections()
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        dump("numberOfSections \(sections.count)")
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 각 섹션 타이틀 문자열 반환
//        dump("sections[\(section)]?.title \(String(describing: sections[section]?.title))")
        return sections[section]?.title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 테이블 뷰의 한 섹션당 몇 개의 셀을 담을것인지 반환
//        dump("sections[\(section)]?.items.count \(String(describing: (sections[section]?.items.count)!))")
        return (sections[section]?.items.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 각 셀을 반환.
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = sections[indexPath.section]?.items[indexPath.row]
        
        if item!.selected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = item?.name ?? ""
        
//        dump("cell: \(cell)")
        // 테이블 움직일 때 실시간으로 생성.
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item = sections[indexPath.section]?.items[indexPath.row]
        item!.selected = !item!.selected
        dump("item clicked \(String(describing: item))")
        sections[indexPath.section]?.items[indexPath.row] = item!
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
