//
//  FiltersViewControllerDelegate.swift
//  GetGoingClass
//
//  Created by shaunyan on 2019-02-25.
//  Copyright © 2019 SMU. All rights reserved.
//

import Foundation

// Custom protocol
protocol FiltersViewControllerDelegate: class {
    func filterResponse(raduis:Float, rankby:String, opennow:Bool?)
}
