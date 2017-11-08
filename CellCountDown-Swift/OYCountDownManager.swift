//
//  OYCountDownManager.swift
//  CellCountDown-Swift
//
//  Created by Gold on 2017/11/7.
//  Copyright © 2017年 herob. All rights reserved.
//

import UIKit

/** 通知名 */
let OYCountDownNotification = Notification.Name("OYCountDownNotification")

class OYCountDownManager: NSObject {
    
    /** 使用单例 */
    static let sharedManager: OYCountDownManager = OYCountDownManager()
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    /** 开始倒计时 */
    func start() -> Void {
        // 启动定时器
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer!, forMode: .commonModes)
        }
    }
    
    /** 停止倒计时 */
    func invalidate() -> Void {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    
// ======== v1.0 ========
// 如果只需要一个倒计时差, 可继续使用timeInterval属性
// 增加后台模式, 后台状态下会继续计算时间差
    
    /** 时间差(单位:秒) */
    var timeInterval: Int = 0
    
    /** 刷新倒计时(兼容旧版本, 如使用identifier标识的时间差, 请调用reloadAllSource方法) */
    func reload() -> Void {
        self.timeInterval = 0
    }
    

// ======== v2.0 ========
// 增加identifier:标识符, 一个identifier支持一个倒计时源, 有一个单独的时间差


    /** 添加倒计时源 */
    func addSourceWithIdentifier(identifier: String) -> Void {
        let timeInterval = self.timeIntervalDict[identifier]
        if timeInterval != nil {
            timeInterval?.timeInterval = 0
        }else {
            self.timeIntervalDict[identifier] = OYTimeInterval(timerInterval: 0)
        }
    }
    
    /** 获取时间差 */
    func timeIntervalWithIdentifier(identifier: String) -> Int {
        return self.timeIntervalDict[identifier]?.timeInterval ?? 0
    }
    
    /** 刷新倒计时源 */
    func reloadSourceWithIdentifier(identifier: String) -> Void {
        self.timeIntervalDict[identifier]?.timeInterval = 0
    }
    
    /** 刷新所有倒计时源 */
    func reloadAllSource() -> Void {
        for (_, timeInterval) in self.timeIntervalDict {
            timeInterval.timeInterval = 0
        }
    }
    
    /** 清除倒计时源 */
    func removeSourceWithIdentifier(identyfier: String) -> Void {
        self.timeIntervalDict.removeValue(forKey: identyfier)
    }
    
    /** 清除所有倒计时源 */
    func removeAllSource(identifier: String) -> Void {
        self.timeIntervalDict.removeAll()
    }
    
    /// 定时器
    private var timer: Timer?
    
    /// 时间差字典(单位:秒)(使用字典来存放, 支持多列表或多页面使用)
    private lazy var timeIntervalDict: [String : OYTimeInterval] = {
        let lazyDict = [String : OYTimeInterval]()
        return lazyDict
    }()
    
    /// 后台模式使用, 记录进入后台的本地时间
    private var backgroudRecord: Bool = false
    private var lastData: Date?
    
    /// 定时器回调
    @objc private func timerAction() -> Void {
        // 定时器计数每次加1
        self.timerActionWithTimeInterval(interval: 1)
    }
    private func timerActionWithTimeInterval(interval: Int) -> Void {
        // 时间差+
        self.timeInterval += interval
        for (_, timeInterval) in self.timeIntervalDict {
            timeInterval.timeInterval += interval
        }
        // 发出通知
        NotificationCenter.default.post(name: OYCountDownNotification, object: nil)
    }
    
    /// 程序进入后台回调
    @objc private func applicationDidEnterBackground() -> Void {
        self.backgroudRecord = (self.timer != nil)
        if self.backgroudRecord {
            self.lastData = Date()
            self.invalidate()
        }
    }
    
    /// 程序进入前台回调
    @objc private func applicationWillEnterForeground() -> Void {
        if self.backgroudRecord {
            let timeInterval = Date().timeIntervalSince(self.lastData!)
            // 取整
            self.timerActionWithTimeInterval(interval: Int(timeInterval))
            self.start()
        }
    }
}


class OYTimeInterval: NSObject {
    /** 时间差 */
    var timeInterval: Int = 0
    
    init(timerInterval: Int) {
        self.timeInterval = timerInterval
    }
}
