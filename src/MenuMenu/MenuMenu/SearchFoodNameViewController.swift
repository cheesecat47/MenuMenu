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
    private var recipies = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let recipesFromDB = RecipeRepository.shared.getAllRecipes() {
            for (_, each) in recipesFromDB {
                recipies.append(each)
            }
        }
        
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

extension SearchFoodNameViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
//        dump("numberOfSections \(sections.count)")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 테이블 뷰의 한 섹션당 몇 개의 셀을 담을것인지 반환
    //        dump("sections[\(section)]?.items.count \(String(describing: (sections[section]?.items.count)!))")
        return recipies.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 각 셀을 반환.
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeNameCellTest", for: indexPath)
        
        let recipe = recipies[indexPath.row]
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
