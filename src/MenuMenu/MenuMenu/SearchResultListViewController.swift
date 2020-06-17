//
//  SearchResultListViewController.swift
//  MenuMenu
//
//  Created by refo on 2020/06/15.
//  Copyright © 2020 COMP420. All rights reserved.
//

import UIKit

class SearchResultListViewController: UIViewController {
    
    @IBOutlet weak var resultTableView: UITableView!
    
    var recipeList: [Recipe]? {
        didSet {
            dump("SearchResultListViewController: recipeList: \(String(describing: recipeList))")
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultTableView.dataSource = self
        self.resultTableView.delegate = self
        
        self.resultTableView.layer.cornerRadius = 10
        self.resultTableView.layer.masksToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showRecipeDetail" {
            if let indexPath = resultTableView.indexPathForSelectedRow {
                dump("SearchIngredientsViewController: prepare: indexPath: \(indexPath)")
                let thisRecipe = recipeList?[indexPath.row]
                dump("SearchIngredientsViewController: prepare: thisRecipe: \(String(describing: thisRecipe?.foodName))")
                let controller = segue.destination as! RecipeDetailViewContoller
                controller.detailRecipe = thisRecipe
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


extension SearchResultListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
//        dump("numberOfSections \(sections.count)")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 테이블 뷰의 한 섹션당 몇 개의 셀을 담을것인지 반환
//        dump("sections[\(section)]?.items.count \(String(describing: (sections[section]?.items.count)!))")
        return (recipeList?.count)!
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 각 셀을 반환.
        let cell: RecipeCell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! RecipeCell
        let item = recipeList?[indexPath.row]
            
        cell.recipeCellLabel?.text = item?.foodName
        cell.recipeCellImage?.image = UIImage(named: "carrot.jpg") // 디폴트 이미지
        if let url = item?.imgPath {
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


extension SearchResultListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 각 섹션 타이틀 문자열 반환
//        dump("sections[\(section)]?.title \(String(describing: sections[section]?.title))")
        return "검색 결과"
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dump("SearchResultListViewController: lowerCell Clicked!")
    }
}
