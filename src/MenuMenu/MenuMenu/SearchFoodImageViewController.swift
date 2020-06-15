import UIKit
import WebKit
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
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == messageHandlerName {
            print("\(message.body)")
            // message.body 가 티쳐블 머신 결과물 객체. 이걸로 하고싶은거 하면됨. 이미지 파일 크기와 모델 크기에 따라 쬐에끔 오래걸림
        }
    }
}
