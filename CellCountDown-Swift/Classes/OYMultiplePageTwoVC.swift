//
//  OYMultiplePageTwoVC.swift
//  CellCountDown-Swift
//
//  Created by Gold on 2017/11/14.
//  Copyright © 2017年 herob. All rights reserved.
//

import UIKit

fileprivate let OYMultiplePageSource2 = "OYMultiplePageSource2"

class OYMultiplePageTwoVC: UIViewController {

    private var tableView: UITableView!
    private var dataSource: [OYModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.title = "页面2倒计时";
        self.view.backgroundColor = UIColor.white
        self.getDate()
        self.setupUI()
        
        // 启动倒计时管理
        OYCountDownManager.sharedManager.start()
        // 增加倒计时源
        OYCountDownManager.sharedManager.addSourceWithIdentifier(identifier: OYMultiplePageSource2)
    }
    
    private func setupUI() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OYTableViewCell.classForCoder(), forCellReuseIdentifier: OYTableViewCellID)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(OYMultiplePageTwoVC.reloadData), for: .valueChanged)
        view.addSubview(tableView)
    }
    
    private func getDate() -> Void {
        self.dataSource = [OYModel]()
        for i in 0..<50 {
            let count = arc4random_uniform(100)
            let model = OYModel(title: String(format: "第%d条数据", i), count: Int(count))
            dataSource.append(model)
        }
    }
    
    @objc private func reloadData() -> Void {
        getDate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            OYCountDownManager.sharedManager.reload()
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    deinit {
        OYCountDownManager.sharedManager.invalidate()
        OYCountDownManager.sharedManager.reload()
    }
}

extension OYMultiplePageTwoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OYTableViewCellID) as! OYTableViewCell
        cell.model = self.dataSource[indexPath.row]
        cell.countDownZero = {
            (timeOutModel: OYModel) -> Void in
            if !timeOutModel.timeOut{
                print("MultiplePageTwoVC--\(timeOutModel.title!)--时间到了")
            }
            timeOutModel.timeOut = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

