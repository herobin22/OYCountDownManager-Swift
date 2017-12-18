//
//  OYMultipleTableVC.swift
//  CellCountDown-Swift
//
//  Created by Gold on 2017/11/14.
//  Copyright © 2017年 herob. All rights reserved.
//

import UIKit

fileprivate let OYMultipleTableSource1 = "OYMultipleTableSource1"
fileprivate let OYMultipleTableSource2 = "OYMultipleTableSource2"

class OYMultipleTableVC: UIViewController {

    private var tableView: UITableView!
    private var tableView2: UITableView!
    private var dataSource: [OYModel]!
    private var dataSource2: [OYModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "多个列表倒计时"
        self.view.backgroundColor = UIColor.gray
        self.getDate()
        self.getDate2()
        self.setupUI()
        
        // 启动倒计时管理
        OYCountDownManager.sharedManager.start()
        // 增加倒计时源
        OYCountDownManager.sharedManager.addSourceWithIdentifier(identifier: OYMultipleTableSource1)
        OYCountDownManager.sharedManager.addSourceWithIdentifier(identifier: OYMultipleTableSource2)
    }

    private func setupUI() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height/2), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OYTableViewCell.classForCoder(), forCellReuseIdentifier: OYTableViewCellID)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(OYMultipleTableVC.reloadData), for: .valueChanged)
        view.addSubview(tableView)
        
        tableView2 = UITableView(frame: CGRect(x: 0, y: view.bounds.size.height/2+50, width: view.bounds.size.width, height: view.bounds.size.height/2), style: .plain)
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.register(OYTableViewCell.classForCoder(), forCellReuseIdentifier: OYTableViewCellID)
        tableView2.refreshControl = UIRefreshControl()
        tableView2.refreshControl?.addTarget(self, action: #selector(OYMultipleTableVC.reloadData2), for: .valueChanged)
        view.addSubview(tableView2)
    }
    
    private func getDate() -> Void {
        dataSource = [OYModel]()
        for i in 0..<50 {
            let count = arc4random_uniform(100)
            let model = OYModel(title: String(format: "第%d条数据", i), count: Int(count))
            dataSource.append(model)
        }
    }
    
    @objc private func reloadData() -> Void {
        getDate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            OYCountDownManager.sharedManager.reloadSourceWithIdentifier(identifier: OYMultipleTableSource1)
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func getDate2() -> Void {
        dataSource2 = [OYModel]()
        for i in 0..<50 {
            let count = arc4random_uniform(100)
            let model = OYModel(title: String(format: "第%d条数据", i), count: Int(count))
            dataSource2.append(model)
        }
    }
    
    @objc private func reloadData2() -> Void {
        getDate2()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            OYCountDownManager.sharedManager.reloadSourceWithIdentifier(identifier: OYMultipleTableSource2)
            self.tableView2.reloadData()
            self.tableView2.refreshControl?.endRefreshing()
        }
    }
    
    deinit {
        OYCountDownManager.sharedManager.removeAllSource()
        OYCountDownManager.sharedManager.invalidate()
    }

}

extension OYMultipleTableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return self.dataSource.count
        }
        return self.dataSource2.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dataSource: [OYModel]
        if tableView == self.tableView {
            dataSource = self.dataSource
        }else {
            dataSource = self.dataSource2
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: OYTableViewCellID) as! OYTableViewCell
        cell.model = dataSource[indexPath.row]
        cell.countDownZero = {
            (timeOutModel: OYModel) -> Void in
            if !timeOutModel.timeOut{
                print("MultipleTableVC--\(timeOutModel.title!)--时间到了")
            }
            timeOutModel.timeOut = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
