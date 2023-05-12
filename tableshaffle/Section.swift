//
//  Section.swift
//  tableshaffle
//
//  Created by Эллина Коржова on 12.05.23.
//

import Foundation

enum Section: Hashable {
    case numbers
}

struct SectionData {
    var key: Section
    var values: [Int]
}

struct CellData: Hashable {
    let title: Int
    var isFavorite: Bool = false
}
