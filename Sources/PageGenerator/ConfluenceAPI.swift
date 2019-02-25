//
//  ConfluenceAPI.swift
//  Coupage
//
//  Created by Kota4822 on 2019/02/23.
//

import Foundation

/// ConfluenceのREST APIで、新規ページを出力する
/// https://developer.atlassian.com/server/confluence/confluence-rest-api-examples/
public struct ConfluenceAPI {
    
    /// TODO: 外部設定から読み込みを行うようにする
    private let urlString = "https://confluence.XXXXXXX"
    
    /// TODO: 外部設定から読み込みを行うようにする
    private let username = "username"
    private let password = "password"

    /// Confluenceに新規にリリースノートページを追加します
    ///
    /// - Parameters:
    ///   - spaceKey: 追加対象のスペースキー
    ///   - ancestorsKey: 追加対象の親ページキー
    ///   - pageTitle: ページのタイトル
    ///   - pageValueString: ページの内容
    public func generateReleaseNote(spaceKey: String, ancestorsKey: String?, pageTitle: String, pageValueString: String) {
        guard let url = URL(string: urlString) else {
            print("⛔️ URL生成失敗")
            assertionFailure()
            return
        }
        
        var headerFields: [String: String]? {
            var headerFieldsDic = [String: String]()
            headerFieldsDic["Content-Type"] = "application/json"
            guard let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8) else {
                print("⛔️ 認証用データ生成失敗")
                assertionFailure()
                return nil
            }
            let credential = credentialData.base64EncodedString(options: [])
            headerFieldsDic["Authorization"] = "Basic \(credential)"
            return headerFieldsDic
        }
        
        var bodyJson: [String: Any] {
            var jsonDic = [String: Any]()
            jsonDic["type"] = "page"
            jsonDic["title"] = pageTitle
            jsonDic["space"] = ["key": spaceKey]
            if let ancestorsKey = ancestorsKey {
                jsonDic["ancestors"] = [["id": ancestorsKey]]
            }
            // TODO: use template
            jsonDic["body"] = ["storage": ["value": "<p>This is a new page</p>", "representation": "storage"]]
            return jsonDic
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headerFields
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyJson, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("✅ \(String(describing: response))")
            if let error = error {
                print("⛔️ \(error)")
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        print("🍻 Completion!!!")
    }
}
