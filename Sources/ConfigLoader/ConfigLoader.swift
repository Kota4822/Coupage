//
//  ConfigLoader.swift
//  Coupage
//
//  Created by Takumi Karibe on 2019/02/23.
//

import Foundation
import Yams

import Config

public struct ConfigLoader {
    private init() {}
    
    /// configファイルをYAML形式でパースします
    ///
    /// - Returns: configから読み込んだUser設定
    public static func loadConfig() -> Config {
        
        /// fetch config.yml
        guard let config = try? Yams.compose(yaml: fetchConfigFile()) else {
            fatalError("⛔️ couldn't load config")
        }
        
        /// parse user config
        guard let userConfig = config?["config"]?["user"],
            let name = userConfig["user_id"]?.string,
            !name.isEmpty,
            let password = userConfig["password"]?.string,
            !password.isEmpty else {
                fatalError("⛔️ couldn't load config")
        }
        
        /// parse confluence config
        guard let confluenceConfig = config?["config"]?["confluence"],
            let urlString = confluenceConfig["url"]?.string,
            let url = URL(string: urlString),
            let defaultSpaceKey = confluenceConfig["default_space_key"]?.string,
            let defaultAncestorsKey = confluenceConfig["default_ancestors_key"]?.string else {
                fatalError("⛔️ couldn't load config")
        }
        
        let user = Config.User(name: name, password: password)
        let confluence = Config.Confluence(url: url, spaceKey: defaultSpaceKey, ancestorsKey: defaultAncestorsKey)
        return Config(user: user, confluence: confluence)
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
