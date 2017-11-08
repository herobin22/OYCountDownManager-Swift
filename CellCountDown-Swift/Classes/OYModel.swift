//
//  OYModel.swift
//  CellCountDown-Swift
//
//  Created by Gold on 2017/11/7.
//  Copyright © 2017年 herob. All rights reserved.
//

import UIKit

class OYModel: NSObject {
    
    var title: String?
    var count: Int = 0
    
    /// 表示时间已经到了
    var timeOut: Bool = false
    
    /// 倒计时源
    var countDownSource: String?
    
    init(title: String, count: Int) {
        self.title = title
        self.count = count
    }

}
