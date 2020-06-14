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
        
        self.lowerTableView.dataSource = self
        self.lowerTableView.delegate = self
//        self.lowerTableView.register(RecipeCell.self, forCellReuseIdentifier: lowerCellIdentifier)
        
        // set rounded table views
        self.upperTableView.layer.cornerRadius = 10
        self.upperTableView.layer.masksToBounds = true
        self.lowerTableView.layer.cornerRadius = 10
        self.lowerTableView.layer.masksToBounds = true
    }

    @IBOutlet weak var upperTableView: UITableView!
    @IBOutlet weak var lowerTableView: UITableView!
    
    let upperCellIdentifier: String = "upperCell"
    let lowerCellIdentifier: String = "lowerCell"
    
    var recipeTable = RecipeTable()
    lazy var sections = recipeTable.getSections()
    
    
    @IBAction func searchSelectedIngredients(_ sender: Any) {
        let ingredientArray = Array(searchResultDic.values)
        dump("SearchIngredientsViewController: searchSelectedIngredients: ingredientArray \(ingredientArray)")
        let ingredientConcated = searchResultDic.values.joined(separator: ",")
        dump("SearchIngredientsViewController: searchSelectedIngredients: ingredientConcated \(ingredientConcated)")
    }
    
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
    var searchResultDic: [Int:String] = [:]
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
            cell.recipeCellImage?.image = UIImage(named: "carrot.jpg") // 디폴트 이미지
            if let url = item.imgPath {
                // https://slobell.com/blogs/54
                // 공공데이터에서 사용하는 음식 대표이미지 주소가 http라서 보안 설정에 걸림.
                // info.plist에 설정.
                
                // MultiThreading
                DispatchQueue.global(qos: .userInitiated).async { [weak cell] in
                    let urlContents = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        if let imgData = urlContents {
                            cell?.recipeCellImage?.image = UIImage(data: imgData)
                        }
                    }
                }
            }

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
