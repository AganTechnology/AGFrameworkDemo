//
//  AMapMoudle.swift
//  AGIOSFramework_Example
//
//  Created by 沈晓鹏 on 2024/7/15.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import AGEngineKit

class AMapMoudle : NSObject, AGEngineLocationProvider {
    
    func agEngine(_ engine: AGEngineKit, locationUpdate updater: @escaping (AGLocation) -> Void) {
        updater(AGLocation(coorDinate: .init(latitude: 30.25308, longitude: 120.21551), city: "杭州市"))
    }
}
