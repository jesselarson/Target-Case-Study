//
//  DetailSectionConfiguration.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/13/22.
//  Copyright © 2022 Target. All rights reserved.
//

import UIKit

enum DetailSectionConfiguration: Int, CaseIterable {
    case summary
    case description
    
    var itemCount: Int {
        switch self {
            case .summary, .description:
                return 1
        }
    }
    
    var estimatedHeight: CGFloat {
        switch self {
            case .summary:
                return 490.0
            case .description:
                return 200.0
        }
    }
    
    var contentInsets: NSDirectionalEdgeInsets {
        switch self {
            case .summary:
                return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20,trailing: 0)
            case .description:
                return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0,trailing: 0)
        }
    }
}
