//
//  main.swift
//  Coupage
//
//  Created by Kota4822 on 2019/02/23.
//

import Foundation
import Commander
import CoupageCLI
import Extension

extension Array: ArgumentConvertible where Element: ArgumentConvertible {}

func run() {
    print("📚 Release Confluence Page")

    enum Reserved: String, CaseIterable {
        case pageTitle, templateName, spaceKey, ancestorsKey
    }
    
    var reservedAuguments = [Reserved: String]()
    var templateAuguments = [String: String]()

    let args = ProcessInfo.processInfo.arguments
    
    if args[1] == "init" {
        CoupageCLI.initialize()
        return
    }
    
    args.filter{ $0.contains(":") }
        .compactMap { $0.split(separator: ":").map(String.init) }
        .forEach { arg in
            if let reservedkey = Reserved(rawValue: arg[0]) {
                reservedAuguments[reservedkey] = arg[1]
            } else {
                templateAuguments[arg[0]] = arg[1]
            }
    }

    guard let pageTitle = reservedAuguments[.pageTitle], let templateName = reservedAuguments[.templateName] else {
        fatalError("⛔️ pageTitle/templateNameが存在しません")
    }

    let parameter = CoupageCLI.Parameter(templateName: templateName,
                                         title: pageTitle,
                                         spaceKey: reservedAuguments[.spaceKey],
                                         ancestorsKey: reservedAuguments[.ancestorsKey],
                                         templateAuguments: templateAuguments)
    CoupageCLI.execute(parameter)

    print("🍻 Completion!!!")
}

run()
