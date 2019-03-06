//
//  main.swift
//  Coupage
//
//  Created by Kota4822 on 2019/02/23.
//

import Foundation
import CoupageCLI
import Extension

print("📚 Release Confluence Page")

func run() {
    let argv = ProcessInfo.processInfo.arguments
    let spaceKey = argv[safe: 1] ?? ""
    let ancestorsKey = argv[safe: 2] ?? ""
    CoupageCLI.execute(auguments: [spaceKey, ancestorsKey])
}

run()

print("🍻 Completion!!!")
