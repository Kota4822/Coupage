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
        let user = fetchUserConfig()
        let page = fetchPageConfig()
        return Config(user: user, page: page)
    }
}

private extension ConfigLoader {
    
    private static var userConfigFileName: String {
        return "user_config.yml"
    }
    
    private static var pageConfigFileName: String {
        return "page_config.yml"
    }

    static func fetchUserConfig() -> Config.User {

        let path = FileManager.default.currentDirectoryPath + "/" + userConfigFileName
        let node = fetchConfigFile(at: path)
        
        /// parse user config
        guard let userConfig = node["user"],
              let name = userConfig["user_id"]?.string,
              !name.isEmpty,
              let password = userConfig["password"]?.string,
              !password.isEmpty else {
                fatalError("⛔️ couldn't load user config")
        }
        
        return Config.User(name: name, password: password)
    }

    static func fetchPageConfig() -> Config.Page {
        
        let path = FileManager.default.currentDirectoryPath + "/" + userConfigFileName
        let node = fetchConfigFile(at: path)
        
        /// parse confluence config
        guard let pageConfig = node["page"],
            let urlString = pageConfig["url"]?.string,
            let url = URL(string: urlString),
            let defaultSpaceKey = pageConfig["default_space_key"]?.string,
            let defaultAncestorsKey = pageConfig["default_ancestors_key"]?.string else {
                fatalError("⛔️ couldn't load page config")
        }
        
        return Config.Page(url: url, spaceKey: defaultSpaceKey, ancestorsKey: defaultAncestorsKey)
    }
    
    static func fetchConfigFile(at filePath: String) -> Node {
        if !FileManager.default.fileExists(atPath: filePath) {
            fatalError("⛔️ config is not exist")
        }
        
        guard let configFile = FileManager.default.contents(atPath: filePath), let contents = String(data: configFile, encoding: .utf8) else {
            fatalError("⛔️ config is invalid")
        }
        
        guard let node = try? Yams.compose(yaml: contents), let result = node else {
            fatalError("⛔️ couldn't load config")
        }

        return result
    }
    
}
