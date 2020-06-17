import UIKit
import WebKit
import JavaScriptCore

class SearchFoodImageViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    var webView: WKWebView!
    let inBundleURL = Bundle.main.resourceURL?.appendingPathComponent("menumenu.html")
    let htmlURLInDocument = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("menumenu.html")
    let messageHandlerName = "callbackHandler"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let contentController: WKUserContentController = WKUserContentController()
        contentController.add(self, name: messageHandlerName)
        
        let configuration: WKWebViewConfiguration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        contentController.add(self, name: "native_console_log")
        
        webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        self.view = webView
        
        //copy files
        if !FileManager.default.fileExists(atPath: htmlURLInDocument.path) {
            do {
                try FileManager.default.copyItem(atPath: (inBundleURL?.path)!, toPath: htmlURLInDocument.path)
            } catch let error as NSError {
                print("!!! ERROR copy db from bundle to filesystem fail:\n\(error)")
            }
        }

        
        let myRequest = URLRequest(url: htmlURLInDocument)
        
        webView.load(myRequest)
        webView.allowsBackForwardNavigationGestures = true
        
        // https://comxp.tistory.com/354
        // https://bluexmas.tistory.com/818
//        let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
//        let logFunction : @convention(block) (String) -> Void = { (msg:String) in
//            print("Console : \(msg)")
//        }
//        context.objectForKeyedSubscript("console")?.setObject(unsafeBitCast(logFunction, to: AnyObject.self), forKeyedSubscript: "log")
        let js = "var console = { log: function(message) { webkit.messageHandlers.native_console_log.postMessage(JSON.stringify(message)) } }"
        webView.evaluateJavaScript(js)
    }
    
    func native_console_log(didReceive message: WKScriptMessage) {
        print(NSString(string: "console.log: \(message.body)"))
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "native_console_log" {
            dump("SearchFoodImageViewController: userContentController: console log")
            native_console_log(didReceive: message)
        }
        
        if message.name == messageHandlerName {
            dump("SearchFoodImageViewController: userContentController: message")
//            print("SearchFoodImageViewController: userContentController: message: \(message.body) \(type(of: message.body))")
            // message.body 가 티쳐블 머신 결과물 객체. 이걸로 하고싶은거 하면됨. 이미지 파일 크기와 모델 크기에 따라 쬐에끔 오래걸림
            let msgToArr = message.body as! NSArray
//            dump("SearchFoodImageViewController: userContentController: msgToArr: \(msgToArr) \(type(of: msgToArr))")
            
            // 음식 이름 리스트 생성
            var foodNameList: [String] = []
            for each in msgToArr {
//                dump("SearchFoodImageViewController: userContentController: each : \(each) \(type(of: each))")
                let thisRecipe = each as! Dictionary<String, Any>
//                dump("SearchFoodImageViewController: userContentController: thisRecipe : \(thisRecipe) \(type(of: thisRecipe))")
                foodNameList.append(thisRecipe["foodName"] as! String)
            }
//            dump("SearchFoodImageViewController: userContentController: foodNameList : \(foodNameList)")
            
            // 레시피 목록에서 음식 이름 찾아서 레시피 배열 생성
            var recipeList: [Recipe] = []
            if let allRecipes = RecipeRepository.shared.getAllRecipes(){
                for (_, recipe) in allRecipes {
                    let thisFood = recipe.foodName
                    if foodNameList.contains(thisFood) {
                        recipeList.append(recipe)
                    }
                }
            }
            dump("SearchFoodImageViewController: userContentController: recipeList : \(recipeList)")
            
            // https://yzzzzun.tistory.com/27?category=821187
            guard let resultVC = self.storyboard?.instantiateViewController(identifier: "SearchResultListVC") as? SearchResultListViewController else {
                return
            }
            resultVC.recipeList = recipeList
            self.present(resultVC, animated: false)
        }
    }
}
