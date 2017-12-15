//
//  OYPagingTableVC.swift
//  CellCountDown-Swift
//
//  Created by Gold on 2017/11/14.
//  Copyright © 2017年 herob. All rights reserved.
//

import UIKit
import MJRefresh

class OYPagingTableVC: UIViewController {

    private var tableView: UITableView!
    private var dataSource: [OYModel] = {
        return [OYModel]()
    }()
    
    private var pageNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "分页列表倒计时"
        self.view.backgroundColor = UIColor.white
        self.setupUI()
        self.setupRefresh()

        
        // 启动倒计时管理
        OYCountDownManager.sharedManager.start()
    }
    
    private func setupUI() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OYTableViewCell.classForCoder(), forCellReuseIdentifier: OYTableViewCellID)
        view.addSubview(tableView)
    }
    
    private func setupRefresh() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(OYPagingTableVC.headerRefresh))
        tableView.mj_header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(OYPagingTableVC.footerRefresh))
        tableView.mj_footer = footer
        
        header?.beginRefreshing()
    }
    
    @objc private func headerRefresh() {
        pageNumber = 0
        self.reloadData()
    }
    
    @objc private func footerRefresh() {
        pageNumber += 1
        self.reloadData()
    }
    
    private func endRefreshing() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
    
    @objc private func reloadData() -> Void {
        if pageNumber == 0 {
            self.dataSource.removeAll()
        }
        for i in 0..<10 {
            let count = arc4random_uniform(100)
            let model = OYModel(title: String(format: "第%d条数据", pageNumber*10+i), count: Int(count))
            model.countDownSource = "OYPagingSource" + "\(pageNumber)"
            dataSource.append(model)
        }
        // 增加倒计时源
        OYCountDownManager.sharedManager.addSourceWithIdentifier(identifier: "OYPagingSource" + "\(pageNumber)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            OYCountDownManager.sharedManager.reload()
            self.tableView.reloadData()
            self.endRefreshing()
        }
    }
    
    deinit {
        OYCountDownManager.sharedManager.invalidate()
        OYCountDownManager.sharedManager.reload()
    }
}

extension OYPagingTableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OYTableViewCellID) as! OYTableViewCell
        cell.model = self.dataSource[indexPath.row]
        cell.countDownZero = {
            (timeOutModel: OYModel) -> Void in
            if !timeOutModel.timeOut{
                print("PagingTableVC--\(timeOutModel.title!)--时间到了")
            }
            timeOutModel.timeOut = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

