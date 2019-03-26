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
    public static func loadConfig(templateName: String) -> Config {
        let user = fetchUserConfig()
        let page = fetchPageConfig(templateName: templateName)
        return Config(user: user, page: page)
    }
}

private extension ConfigLoader {
    
    static var rootPath: String {
        return FileManager.default.currentDirectoryPath + "/.coupage"
    }

    static var userConfigFileName: String {
        return "user_config.yml"
    }
    
    static var pageConfigFileName: String {
        return "page_config.yml"
    }

    static func fetchUserConfig() -> Config.User {

        let path = [rootPath, userConfigFileName].joined(separator: "/")
        let node = fetchConfigFile(at: path)

        /// parse user config
        guard let name = node["id"]?.string,
              !name.isEmpty,
              let password = node["password"]?.string,
              !password.isEmpty else {
                fatalError("⛔️ couldn't load user config")
        }
        
        return Config.User(name: name, password: password)
    }

    static func fetchPageConfig(templateName: String) -> Config.Page {
        
        let path = [rootPath, "templates", templateName, pageConfigFileName].joined(separator: "/")
        let node = fetchConfigFile(at: path)
        
        /// parse confluence config
        guard let urlString = node["url"]?.string,
            let url = URL(string: urlString),
            let defaultSpaceKey = node["default_space_key"]?.string,
            let defaultAncestorsKey = node["default_ancestors_key"]?.string else {
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
