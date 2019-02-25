//
//  YamlLoader.swift
//  Coupage
//
//  Created by Takumi Karibe on 2019/02/23.
//

import Foundation
import Yams

struct YamlLoader {
    private init() {}
    
    /// configファイルをYAML形式でパースします
    ///
    /// - Returns: configから読み込んだUser設定
    static func loadConfig() -> UserConfig {
        guard let config = try? Yams.compose(yaml: fetchConfigFile()),
            let confluence = config?["config"]?["confluence"],
            let name = confluence["user_id"]?.string,
            !name.isEmpty,
            let password = confluence["password"]?.string,
            !password.isEmpty,
            let urlString = confluence["url"]?.string,
            let url = URL(string: urlString) else {
                fatalError("⛔️ couldn't load config")
        }
        
        return UserConfig(name: name, password: password, url: url)
    }
    
    /// configファイルを取得します
    ///
    /// - Returns: configファイルの中身
    private static func fetchConfigFile() -> String {
        let configPath = FileManager.default.currentDirectoryPath + "/config.yml"
        
        if !FileManager.default.fileExists(atPath: configPath) {
            fatalError("⛔️ config is not exist")
        }
        
        guard let configFile = FileManager.default.contents(atPath: configPath), let contents = String(data: configFile, encoding: .utf8) else {
            fatalError("⛔️ config is invalid")
        }
        
        return contents
    }
}
