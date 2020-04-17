//
//  WBLoginViewController.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/14.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class WBLoginViewController: UIViewController {
    // 懒加载登录页面
    lazy var wkWebView = WKWebView(frame: view.bounds)
    
    override func loadView() {
        super.loadView()
        
        view = wkWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置页面
        setupUI()
        
        // 设置代理
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
    }
    
    /// 设置界面
    private func setupUI() {
        // 设置标题
        title = "微博登录"
        
        // 设置不可滚动
        wkWebView.scrollView.isScrollEnabled = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", target: self, action: #selector(cancel), event: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill), event: .touchUpInside)
        // 请求授权页面
        netWorkRequest()
    }
    
    /// 取消页面
    @objc private func cancel() {
//        SVProgressHUD.dismiss()
        presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    /// 自动填充
    @objc private func autoFill() {
        // 准备 js
        let js = "document.getElementsByName('userId')[0].value = '15210779201';" + "document.getElementsByName('passwd')[0].value = 'Jin8851068';"
        wkWebView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    /// 授权页面请求
    private func netWorkRequest() {
        // 设置网络请求
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(Uid)&redirect_uri=\(WBRedirect_URI)"
        let url = URL(string: urlStr)
        
        let request = URLRequest(url: url!)
        
        wkWebView.load(request)
    }
}

/// 网络请求拓展
extension WBLoginViewController: WKUIDelegate, WKNavigationDelegate {
    
    /// 开始加载数据
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        SVProgressHUD.show()
    }
    
    /// 加载数据结束
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        SVProgressHUD.dismiss()
    }
    
    
    
    

    /// 请求前，是否要加载页面
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    /// 请求已经得到服务器的相应，决定是否要加载页面
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        if navigationResponse.response.url?.absoluteString.hasPrefix("http://baidu.com") == false {
            decisionHandler(.allow)
            return
        }
        
        if navigationResponse.response.url?.query?.hasPrefix("code=") == false {
            decisionHandler(.allow)
            cancel()
            return
        }
        
        // 获取code（授权码）
        let code = navigationResponse.response.url?.query?.components(separatedBy: "=").last ?? ""
        
        WBNetWorkingController.shared.tokenRequest(code: code) { [weak self] (isSuccess) in
            if isSuccess {
                print("加载成功！")
                // 发送用户已经登录通知
                NotificationCenter.default.post(name: .WBUserHasLogin, object: nil)
                self?.cancel()
//                SVProgressHUD.showSuccess(withStatus: "登录成功")
            } else {
//                SVProgressHUD.show(withStatus: "无法加载，请检查网络...")
            }
        }
        
        decisionHandler(.cancel)
    }
    
    /// 点击页面中的超链接后，决定是否要加载新页面
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        
        decisionHandler(.allow, preferences)
    }
}
