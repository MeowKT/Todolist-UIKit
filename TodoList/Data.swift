//
//  Data.swift
//  TodoList
//
//  Created by Savva on 01.01.2021.
//

import Foundation

struct Note: Codable {
    var title: String
    var description: String
    var date: Date
}
