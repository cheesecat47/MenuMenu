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
//    https://stackoverflow.com/questions/33793211/tableview-rounded-corners-and-shadow/33794065


import UIKit

class SearchIngredientsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.upperTableView.dataSource = self
        self.upperTableView.delegate = self
        self.upperTableView.register(UITableViewCell.self, forCellReuseIdentifier: upperCellIdentifier)
        
        // set rounded table views
        self.upperTableView.layer.cornerRadius = 10
        self.upperTableView.layer.masksToBounds = true
    }

    @IBOutlet weak var upperTableView: UITableView!
    
    let upperCellIdentifier: String = "upperCell"
    
    // lowerTable recipe data
    var recipeTable = RecipeTable()
    lazy var sections = recipeTable.getSections()
    
    // upper table data
    var searchResultArr: [Recipe] = [] {
        didSet {
            dump("SearchIngredientsViewController: searchResultArr: didSet: \(searchResultArr)")
        }
    }
    var searchResultDic: [Int:String] = [:]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showSearchList" {
            let ingredientArray = Array(searchResultDic.values)
            dump("SearchIngredientsViewController: prepare: ingredientArray \(ingredientArray)")
            searchResultArr.removeAll()
            if ingredientArray.count > 0 {
                if let recipesWithSelectedIngredients = RecipeRepository.shared.getRecipesIdByIngredientNames(ingredientNames: ingredientArray) {
                    dump("SearchIngredientsViewController: prepare: recipesWithSelectedIngredients: \(recipesWithSelectedIngredients)")
                    for id in recipesWithSelectedIngredients {
                        if let thisRecipe = RecipeRepository.shared.getRecipeById(id: id) {
                            searchResultArr.append(thisRecipe)
                        }
                    }
                }
            } else {
                dump("SearchIngredientsViewController: prepare: no Selected Ingredients")
            }
            let controller = segue.destination as! SearchResultListViewController
            controller.recipeList = searchResultArr
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
}


extension SearchIngredientsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
//        dump("numberOfSections \(sections.count)")
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 테이블 뷰의 한 섹션당 몇 개의 셀을 담을것인지 반환
//        dump("sections[\(section)]?.items.count \(String(describing: (sections[section]?.items.count)!))")
        return (sections[section]?.items.count)!
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 각 셀을 반환.
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
    }
}


extension SearchIngredientsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 각 섹션 타이틀 문자열 반환
//        dump("sections[\(section)]?.title \(String(describing: sections[section]?.title))")
        return sections[section]?.title
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard var item = sections[indexPath.section]?.items[indexPath.row] else {
            dump("SearchIngredientsViewController: upperTableView: no item")
            return
        }
        item.selected = !item.selected
        dump("item clicked \(String(describing: item))")
        sections[indexPath.section]?.items[indexPath.row] = item
        self.upperTableView.reloadRows(at: [indexPath], with: .automatic)
        
        if item.selected {
            // 만약 체크 상태면 id랑 재료이름 딕셔너리에 추가
            searchResultDic[item.id] = item.name
        } else {
            // 체크 해제하면 딕셔너리에서 제거
            searchResultDic.removeValue(forKey: item.id)
        }
    }
}
