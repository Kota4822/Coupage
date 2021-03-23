//
//  ConfigLoader.swift
//  Coupage
//
//  Created by Takumi Karibe on 2019/02/23.
//

import Foundation
import Yams

import Config

enum ConfigFileState {
    case valid(Node)
    case notExist
    case invalid
    case couldNotLoad
}

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

    static func fetchUserConfig() -> Config.User? {
        let path = [rootPath, userConfigFileName].joined(separator: "/")
        let result = fetchConfigFile(at: path)
        guard case .valid(let node) = result else {
            return nil
        }

        /// parse user config
        guard let userId = node["id"]?.string, !userId.isEmpty,
            let apiKey = node["apiKey"]?.string, !apiKey.isEmpty else {
            return nil
        }

        return Config.User(id: userId, apiKey: apiKey)
    }

    static func fetchPageConfig(templateName: String) -> Config.Page {
        let path = [rootPath, "templates", templateName, pageConfigFileName].joined(separator: "/")
        let result = fetchConfigFile(at: path)

        switch result {
        case .invalid:
            fatalError("⛔️ PageConfigが有効ではありません")
        case .couldNotLoad:
            fatalError("⛔️ PageConfigが読み込めません")
        case .notExist:
            fatalError("⛔️ PageConfigがありません")

        case .valid(let node):
            /// parse confluence config
            guard let urlString = node["url"]?.string,
                let url = URL(string: urlString),
                let defaultSpaceKey = node["default_space_key"]?.string,
                let defaultAncestorsKey = node["default_ancestors_key"]?.string else {
                fatalError("⛔️ couldn't load page config")
            }

            return Config.Page(url: url, spaceKey: defaultSpaceKey, ancestorsKey: defaultAncestorsKey)
        }
    }

    static func fetchConfigFile(at filePath: String) -> ConfigFileState {
        if !FileManager.default.fileExists(atPath: filePath) {
            return .notExist
        }

        guard let configFile = FileManager.default.contents(atPath: filePath), let contents = String(data: configFile, encoding: .utf8) else {
            return .invalid
        }

        guard let node = try? Yams.compose(yaml: contents), let result = node else {
            return .couldNotLoad
        }

        return .valid(result)
    }
}
