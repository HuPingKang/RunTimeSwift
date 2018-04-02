//
//  ViewController.swift
//  RunTimeSwift
//
//  Created by qwer on 2018/3/30.
//  Copyright © 2018年 qwer. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    fileprivate var functions:[String] = [
                                        "动态变量控制",
                                        "动态添加方法",
                                        "动态交换两个方法的实现",
                                        "动态拦截并替换方法(在方法上增加额外功能)",
                                        "实现字典转模型的自动转换"
                                    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "RunTime Functions"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController{
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellid = "cellid"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        cell?.textLabel?.text = self.functions[indexPath.row]
        
        return cell!
        
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.functions.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = RuntimeViewController()
        vc.functionStr = self.functions[indexPath.row]
        vc.funcIndex = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

