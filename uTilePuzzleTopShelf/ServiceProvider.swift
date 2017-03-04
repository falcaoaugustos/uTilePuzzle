//
//  ServiceProvider.swift
//  uPuzzleTopShelf
//
//  Created by Augusto Falcão on 2/9/17.
//  Copyright © 2017 Augusto Falcão. All rights reserved.
//

import Foundation
import TVServices

class ServiceProvider: NSObject, TVTopShelfProvider {

    override init() {
        super.init()
    }

    // MARK: - TVTopShelfProvider protocol

    var topShelfStyle: TVTopShelfContentStyle {
        // Return desired Top Shelf style.
        return .sectioned
    }

    var topShelfItems: [TVContentItem] {
        // Create an array of TVContentItems.
        return []
    }

}

