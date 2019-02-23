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
    
    static func loadConfig() -> UserConfig {
        guard let config = try? Yams.compose(yaml: fetchConfigFile()),
              let confluence = config?["config"]?["confluence"],
              let userConfig = UserConfig(name: confluence["user_id"]?.string, password: confluence["password"]?.string, urlString: confluence["url"]?.string) else {
            fatalError("⛔️ couldn't load config")
        }
        
        return userConfig
    }
}
