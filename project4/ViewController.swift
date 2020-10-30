import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["google.com", "hackingwithswift.com"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Open",
            style: .plain,
            target: self,
            action: #selector(openTapped))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let spacer = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        
        let refresh = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: webView,
            action: #selector(webView.reload))
        
        let backButton = UIBarButtonItem(
            barButtonSystemItem: .rewind,
            target: webView,
            action: #selector(webView.goBack))
        
        let forwardButton = UIBarButtonItem(
            barButtonSystemItem: .fastForward,
            target: webView,
            action: #selector(webView.goForward))
        
        toolbarItems = [backButton, forwardButton, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
    }
    
    @objc func openTapped() {
        let vc = UIAlertController(
            title: "Opening...",
            message: nil,
            preferredStyle: .actionSheet)
        
        for website in websites {
            vc.addAction(UIAlertAction(
                            title: website,
                            style: .default,
                            handler: openPage))
        }
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        progressView.progress = Float(webView.estimatedProgress)
    }
    
    func rejectedAlert() {
        let alert = UIAlertController(title: "Not Allowed", message: "Browsing outside of this website is not allowed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok, I won't do it again.", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor
                 navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    print("\(host) contains \(website)")
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
        rejectedAlert()
    }
}
