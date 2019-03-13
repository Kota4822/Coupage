//
//  main.swift
//  Coupage
//
//  Created by Kota4822 on 2019/02/23.
//

import Foundation
import CoupageCLI
import Extension


func run() {
    print("📚 Release Confluence Page")

    enum Reserved: String, CaseIterable {
        case pageTitle, spaceKey, ancestorsKey
    }
    
    var reservedAuguments = [Reserved: String]()
    var templateAuguments = [String: String]()

    ProcessInfo.processInfo.arguments.filter{ $0.contains(":") }
        .compactMap { $0.split(separator: ":").map(String.init) }
        .forEach { arg in
            if let reservedkey = Reserved(rawValue: arg[0]) {
                reservedAuguments[reservedkey] = arg[1]
            } else {
                templateAuguments[arg[0]] = arg[1]
            }
    }

    guard let pageTitle = reservedAuguments[.pageTitle] else {
        fatalError("⛔️ pageTitleが存在しません")
    }
    
    let parameter = CoupageCLI.Parameter(title: pageTitle,
                                         spaceKey: reservedAuguments[.spaceKey],
                                         ancestorsKey: reservedAuguments[.ancestorsKey],
                                         templateAuguments: templateAuguments)
    CoupageCLI.execute(parameter)

    print("🍻 Completion!!!")
}

run()
