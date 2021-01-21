//
//  PageGenerator.swift
//  Coupage
//
//  Created by Kota4822 on 2019/02/23.
//

import Foundation
import Config

/// ConfluenceのREST APIで、新規ページを出力する
/// https://developer.atlassian.com/server/confluence/confluence-rest-api-examples/
/// クラウド移行してる場合こちら
/// https://developer.atlassian.com/cloud/confluence/rest/api-group-content/#api-api-content-post
public struct PageGenerator {
    
    private init() {}
    
    public static func generate(page: Page, user: Config.User) {
        
        var headerFields: [String: String] {
            var headerFieldsDic = [String: String]()
            headerFieldsDic["Content-Type"] = "application/json"
            guard let credentialData = "\(user.name):\(user.password)".data(using: String.Encoding.utf8) else {
                fatalError("⛔️ 認証用データ生成失敗")
            }
            let credential = credentialData.base64EncodedString(options: [])
            headerFieldsDic["Authorization"] = "Basic \(credential)"
            return headerFieldsDic
        }
        
        var bodyJson: [String: Any] {
            var jsonDic = [String: Any]()
            jsonDic["type"] = "page"
            jsonDic["title"] = page.title
            jsonDic["space"] = ["key": page.config.spaceKey]
            if let ancestorsKey = page.config.ancestorsKey {
                jsonDic["ancestors"] = [["id": ancestorsKey]]
            }
            jsonDic["body"] = ["atlas_doc_format": ["value": page.body, "representation": "atlas_doc_format"]]
            return jsonDic
        }
        
        request(url: page.config.url, header: headerFields, body: bodyJson)
    }
}

private extension PageGenerator {
    
    /// 有効StatusCode
    static var validStatusCodeRange: ClosedRange<Int> {
        return 200...203
    }
    
    /// Confluence REST API を利用してページ追加リクエストを行う
    static func request(url: URL, header: [String: String]?, body: [String: Any]) {

        let semaphore = DispatchSemaphore(value: 0)
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = header
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                print("⛔️ not found status code")
                semaphore.signal()
                return
            }
            
            if validStatusCodeRange.contains(statusCode) {
                print("✅ \(String(describing: response))")
            } else {
                print("🚫 statusCode: \(statusCode)")
                if let error = error {
                    print("🚨 error: \(error)")
                }
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
}
