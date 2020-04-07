//
//  WBNetWorkingController.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/7.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit
import AFNetworking

enum RequestMethod {
    case GET
    case POST
}

class WBNetWorkingController: AFHTTPSessionManager {

    // 创建单例，存储在静态区（常量区），无论哪个控制器访问，都是同一个地址
    static let shared = WBNetWorkingController()
    
//
//    let parameters = ["access_token": "2.00LGIqRE0_Qink518ec8b393lxPQLC"]
    
    
    
    // 封装一个专门做新浪微博请求的方法
    func requestWeiBo(parameters: [String: String], complete: @escaping(_ json: Any?, _ isSuccess: Bool) -> Void) {
        // 请求地址
        let url = "https://api.weibo.com/2/statuses/home_timeline.json"
        request(URLString: url, parameters: parameters, complete: complete)
    }
    
    // 封装 get / post 请求
    private func request(method: RequestMethod = .GET, URLString: String, parameters: [String: String], complete: @escaping(_ json: Any?, _ isSuccess: Bool) -> Void) {
        
        let success = { (dataTask: URLSessionDataTask, json: Any?) in
            complete(json, true)
        }
        
        let failure = { (dataTask: URLSessionDataTask?, error: Error) in
            
            complete(nil, false)
        }
        
        if method == .GET {
            // get 方法
            get(URLString, parameters: parameters, headers: nil, progress: nil, success: success, failure: failure)
        } else {
            // post 方法
            post(URLString, parameters: parameters, headers: nil, progress: nil, success: success, failure: failure)
        }
    }
}
