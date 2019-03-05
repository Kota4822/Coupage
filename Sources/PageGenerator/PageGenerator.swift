//
//  PageGenerator.swift
//  Coupage
//
//  Created by Kota4822 on 2019/02/23.
//

import Foundation
import ConfigLoader
import Config
import TemplateLoader

/// ConfluenceのREST APIで、新規ページを出力する
/// https://developer.atlassian.com/server/confluence/confluence-rest-api-examples/
public struct PageGenerator {
    
    private init() {}
    
    /// Confluenceに新規にページを追加します
    ///
    /// - Parameters:
    ///   - pageTitle: ページのタイトル
    ///   - spaceKey: 追加対象のスペースキー
    ///   - ancestorsKey: 追加対象の親ページキー
    public static func generate(pageTitle: String, spaceKey: String? = nil, ancestorsKey: String? = nil) {
       
        let config = ConfigLoader.loadConfig()
        let template = TemplateLoader.fetchTemplate()
        
        var headerFields: [String: String] {
            var headerFieldsDic = [String: String]()
            headerFieldsDic["Content-Type"] = "application/json"
            guard let credentialData = "\(config.user.name):\(config.user.password)".data(using: String.Encoding.utf8) else {
                fatalError("⛔️ 認証用データ生成失敗")
            }
            let credential = credentialData.base64EncodedString(options: [])
            headerFieldsDic["Authorization"] = "Basic \(credential)"
            return headerFieldsDic
        }
        
        var bodyJson: [String: Any] {
            var jsonDic = [String: Any]()
            jsonDic["type"] = "page"
            jsonDic["title"] = pageTitle
            jsonDic["space"] = spaceKey ?? ["key": config.confluence.spaceKey]
            if let ancestorsKey = ancestorsKey ?? config.confluence.ancestorsKey {
                jsonDic["ancestors"] = [["id": ancestorsKey]]
            }
            jsonDic["body"] = ["storage": ["value": template, "representation": "storage"]]
            return jsonDic
        }
        
        request(url: config.confluence.url, header: headerFields, body: bodyJson)
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
        }
        
        task.resume()
        semaphore.wait()
    }
}
