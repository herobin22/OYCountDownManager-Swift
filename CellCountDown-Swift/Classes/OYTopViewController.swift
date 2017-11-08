//
//  OYTopViewController.swift
//  CellCountDown-Swift
//
//  Created by Gold on 2017/11/7.
//  Copyright © 2017年 herob. All rights reserved.
//

import UIKit

class OYTopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func singleTableBtnClick(_ sender: Any) {
        self.navigationController?.pushViewController(OYSingleTableVC(), animated: true)
    }
 
    @IBAction func mutipleTableBtnClick(_ sender: Any) {
    }
    
    @IBAction func pagingTableBtnClick(_ sender: Any) {
    }
    
}
