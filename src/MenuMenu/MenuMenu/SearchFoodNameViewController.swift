//
//  SearchAsFoodName.swift
//  MenuMenu
//
//  Created by refo on 2020/06/12.
//  Copyright © 2020 COMP420. All rights reserved.
//

// reference
// https://devmjun.github.io/archive/SearchController

import UIKit

class SearchFoodNameViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var recipes = [Recipe]()
    private var filteredRecipes = [Recipe]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup search controller
        searchController.searchResultsUpdater = self // UISearchBar 내의 텍스트 변경 시 알림
        searchController.obscuresBackgroundDuringPresentation = false // 배경 안 흐리게
        searchController.searchBar.placeholder = "레시피 이름 검색"
        navigationItem.searchController = searchController
        definesPresentationContext = true // 다른 뷰 컨트롤러로 이동하면 search bar가 화면에서 사라지도록.

        // Do any additional setup after loading the view.
        if let recipesFromDB = RecipeRepository.shared.getAllRecipes() {
            for (_, each) in recipesFromDB {
                recipes.append(each)
            }
        }
        dump("SearchFoodNameViewController: viewDidLoad: init recipes array")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension SearchFoodNameViewController: UISearchResultsUpdating {
    func searchBarIsEmpty() -> Bool {
        dump("SearchFoodNameViewController: searchBarIsEmpty")
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "ALL") {
        // searchText를 기반으로 filteredRecipes 배열에 방금 추가한 결과를 놓음.
        dump("SearchFoodNameViewController: filterContentForSearchText")
        filteredRecipes = recipes.filter({(recipe:Recipe) -> Bool in
            return recipe.foodName.contains(searchText)
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // update search results based on user's input
        dump("SearchFoodNameViewController: updateSearchResult")
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func isFiltering() -> Bool {
        dump("SearchFoodNameViewController: isFiltering")
        return searchController.isActive && !searchBarIsEmpty()
    }
}


extension SearchFoodNameViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
//        dump("numberOfSections \(sections.count)")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 테이블 뷰의 한 섹션당 몇 개의 셀을 담을것인지 반환
        if isFiltering() {
            return filteredRecipes.count
        }
        return recipes.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 각 셀을 반환.
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeNameCellTest", for: indexPath)
        
        let recipe: Recipe
        if isFiltering() {
            recipe = filteredRecipes[indexPath.row]
        } else {
            recipe = recipes[indexPath.row]
        }
        
        cell.textLabel?.text = recipe.foodName
//        cell.recipeCellImage!.imageURL = recipe.imgPath
        return cell
    }
}


extension SearchFoodNameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 각 섹션 타이틀 문자열 반환
//        dump("sections[\(section)]?.title \(String(describing: sections[section]?.title))")
        return "검색 결과"
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dump("item clicked")
    }
}


