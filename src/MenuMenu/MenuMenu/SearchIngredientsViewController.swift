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
    
//    var searchResultArr: [Recipe] = []
    var searchResultArr: [Recipe] = [
        RecipeRepository.shared.getRecipeById(id: 1)!,
        RecipeRepository.shared.getRecipeById(id: 2)!,
        RecipeRepository.shared.getRecipeById(id: 3)!
        ] {
        didSet {
            dump("SearchIngredientsViewController: searchResultArr: didSet: \(searchResultArr)")
        }
    }
    var searchResultDic: [Int:String] = [:] {
        didSet {
//            dump("SearchIngredientsViewController: searchResultDic: didSet: \(searchResultDic)")
            // 선택된 재료 목록이 바뀔 때마다
//            searchResultArr.removeAll() // lowerTable에 들어갈 목록 클리어.
            let ingredientConcated = searchResultDic.values.joined(separator: ",")
            dump("SearchIngredientsViewController: searchResultDic: didSet: ingredientConcated \(ingredientConcated)")
            // 이거로 db에 쿼리
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
            return searchResultArr.count
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
            let item = searchResultArr[indexPath.row]
            
            cell.recipeCellLabel?.text = item.foodName
            if let url = item.imgPath {
                // MultiThreading
                DispatchQueue.global(qos: .userInitiated).async { [weak cell] in
                    let urlContents = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        if let imgData = urlContents, url == item.imgPath {
                            cell?.recipeCellImage?.image = UIImage(data: imgData)
                        }
                    }
                }
            } else {
                cell.recipeCellImage?.image = UIImage(named: "carrot.jpg")
            }

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
                // 만약 체크 상태면 id랑 재료이름 딕셔너리에 추가
                searchResultDic[item.id] = item.name
            } else {
                // 체크 해제하면 딕셔너리에서 제거
                searchResultDic.removeValue(forKey: item.id)
            }
            
        } else {
            dump("lowerCell Clicked!")
        }
    }
}
