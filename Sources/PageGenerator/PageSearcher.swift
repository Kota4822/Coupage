//
//  File.swift
//  
//
//  Created by kosuke-matsumura on 2021/05/11.
//

import Config
import Foundation

/// ConfluenceのREST APIで、新規ページを出力する
/// https://developer.atlassian.com/cloud/confluence/rest/api-group-content/#api-api-content-post
public struct PageSearcher {
    private init() {}
    
    public static func search(config: Config.Page, title: String, user: Config.User) -> String? {
        var headerFields: [String: String] {
            var headerFieldsDic = [String: String]()
            headerFieldsDic["Content-Type"] = "application/json"
            guard let credentialData = "\(user.id):\(user.apiKey)".data(using: String.Encoding.utf8) else {
                fatalError("⛔️ 認証用データ生成失敗")
            }
            let credential = credentialData.base64EncodedString(options: [])
            headerFieldsDic["Authorization"] = "Basic \(credential)"
            return headerFieldsDic
        }
        
        let urlString = "\(config.url)?spaceKey=\(config.spaceKey)&title=\(title)"
        guard let url = URL(string: urlString) else {
            fatalError("⛔️ invalid URL: \(urlString)")
        }
        return request(url: url, header: headerFields)
    }
}

struct PageSearchResponse: Codable {
    let results: [PageInfo]
    
    struct PageInfo: Codable {
        let id: String
        let title: String
    }
}

private extension PageSearcher {
    /// 有効StatusCode
    static var validStatusCodeRange: ClosedRange<Int> {
        return 200...203
    }
    
    /// Confluence REST API を利用してページ追加リクエストを行う
    static func request(url: URL, header: [String: String]?) -> String? {
        let semaphore = DispatchSemaphore(value: 0)
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = header
        request.httpMethod = "GET"
        
        var result: PageSearchResponse.PageInfo?
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                print("⛔️ not found status code")
                semaphore.signal()
                return
            }
            
            guard let data = data else {
                print("⛔️ response is nil")
                semaphore.signal()
                return
            }

            if validStatusCodeRange.contains(statusCode) {
                let response = try? JSONDecoder().decode(PageSearchResponse.self, from: data)
                result = response?.results.first
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
        return result?.id
    }
}
