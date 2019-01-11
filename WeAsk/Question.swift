//
//  Question.swift
//  WeAsk
//
//  Created by Sheng Loong Su on 1/10/19.
//  Copyright © 2019 ShengLoong Su. All rights reserved.
//

import Foundation

struct Card: Codable {
    var question: String
    
    init(question: String) {
        self.question = question
    }
}
