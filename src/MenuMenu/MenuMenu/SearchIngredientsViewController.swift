//
//  RecipeListViewController.swift
//  MenuMenu
//
//  Created by refo on 2020/05/24.
//  Copyright © 2020 COMP420. All rights reserved.
//

//    references
//    https://stackoverrun.com/ko/q/11646578
//    https://zeddios.tistory.com/169
//    https://etst.tistory.com/105?category=861730


import UIKit

class SearchIngredientsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.upperTableView.dataSource = self
        self.upperTableView.delegate = self
        self.upperTableView.register(UITableViewCell.self, forCellReuseIdentifier: upperCellIdentifier)
        
        self.lowerTableView.dataSource = self
        self.lowerTableView.delegate = self
//        self.lowerTableView.register(RecipeCell.self, forCellReuseIdentifier: lowerCellIdentifier)
    }

    @IBOutlet weak var upperTableView: UITableView!
    @IBOutlet weak var lowerTableView: UITableView!
    
    let upperCellIdentifier: String = "upperCell"
    let lowerCellIdentifier: String = "lowerCell"
    
    var recipeTable = RecipeTable()
    lazy var sections = recipeTable.getSections()
    
    var searchResultDic: [Int:Recipe] = [:] {
        didSet {
            dump("searchResultDic: \(searchResultDic)")
        }
    }
}

extension SearchIngredientsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
//        dump("numberOfSections \(sections.count)")
        if tableView == upperTableView {
            return sections.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 테이블 뷰의 한 섹션당 몇 개의 셀을 담을것인지 반환
//        dump("sections[\(section)]?.items.count \(String(describing: (sections[section]?.items.count)!))")
        if tableView == upperTableView {
            return (sections[section]?.items.count)!
        } else {
            return 10
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 각 셀을 반환.
        if tableView == upperTableView {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: upperCellIdentifier, for: indexPath)
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
        } else {
            let cell: RecipeCell = tableView.dequeueReusableCell(withIdentifier: lowerCellIdentifier, for: indexPath) as! RecipeCell
            cell.recipeCellLabel?.text = "food name"
            cell.recipeCellImage?.image = UIImage(named: "carrot.jpg")
//            dump("\(cell)")
            return cell
        }
    }
}


extension SearchIngredientsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 각 섹션 타이틀 문자열 반환
//        dump("sections[\(section)]?.title \(String(describing: sections[section]?.title))")
        if tableView == upperTableView {
            return sections[section]?.title
        } else {
            return "검색 결과"
        }
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == upperTableView {
            // upper cell item 클릭되면
            guard var item = sections[indexPath.section]?.items[indexPath.row] else {
                dump("SearchIngredientsViewController: upperTableView: no item")
                return
            }
            item.selected = !item.selected
            dump("item clicked \(String(describing: item))")
            sections[indexPath.section]?.items[indexPath.row] = item
            self.upperTableView.reloadRows(at: [indexPath], with: .automatic)
            
            if item.selected {
                // 만약 체크 상태면 db에 쿼리해서 Recipe 객체 가져오고
                guard let selectedRecipe = RecipeRepository.shared.getRecipeById(id: item.id) else {
                    dump("SearchIngredientsViewController: upperTableView: no selected recipe")
                    return
                }
                // 딕셔너리에 추가
                searchResultDic[item.id] = selectedRecipe
            } else {
                // 체크 해제하면 딕셔너리에서 제거
                searchResultDic.removeValue(forKey: item.id)
            }
            
        } else {
            dump("lowerCell Clicked!")
        }
    }
}
