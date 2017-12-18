//
//  OYTableViewCell.swift
//  CellCountDown-Swift
//
//  Created by Gold on 2017/11/7.
//  Copyright © 2017年 herob. All rights reserved.
//

import UIKit

let OYTableViewCellID = "OYTableViewCell"

class OYTableViewCell: UITableViewCell {
    
    var model: OYModel? {
        didSet {
            self.textLabel?.text = model!.title
            self.countDownNotification()
        }
    }
    
    var countDownZero: ((_ timeOutModel: OYModel)->Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.countDownNotification), name: .OYCountDownNotification, object: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.countDownNotification), name: .OYCountDownNotification, object: nil)
    }
    
    @objc private func countDownNotification() {
        
        // 判断是否需要倒计时 -- 可能有的cell不需要倒计时,根据真实需求来进行判断
        if false {
            return;
        }
        // 计算倒计时
        let model = self.model!
        let timeInterval: Int
        if model.countDownSource == nil {
            timeInterval = OYCountDownManager.sharedManager.timeInterval
        }else {
            timeInterval = OYCountDownManager.sharedManager.timeIntervalWithIdentifier(identifier: model.countDownSource!)
        }
        let countDown = model.count - timeInterval
        // 当倒计时到了进行回调
        if (countDown <= 0) {
            self.detailTextLabel?.text = "活动开始"
            // 回调给控制器
            if self.countDownZero != nil {
                self.countDownZero!(model)
            }
            return;
        }
        // 重新赋值
        self.detailTextLabel?.text = String(format: "%02d:%02d:%02d", countDown/3600, (countDown/60)%60, countDown%60)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
