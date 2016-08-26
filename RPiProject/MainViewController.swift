//
//  MainViewController.swift
//  RPiProject
//
//  Created by wonderworld on 16/8/24.
//  Copyright © 2016年 haozhang. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var port: UITextField!
    @IBOutlet weak var name: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func updateContent() {
        if let address = NSUserDefaults.standardUserDefaults().objectForKey("com.rpiproject.hostaddress") as? String {
            self.address.text = address
        }
        
        let port = NSUserDefaults.standardUserDefaults().integerForKey("com.rpiproject.hostport")
        self.port.text = port <= 0 ? "" : "\(port)"
        
        if let name = NSUserDefaults.standardUserDefaults().objectForKey("com.rpiproject.hostname") as? String {
            self.name.text = name
        }
    }

    @IBAction func connect(sender: AnyObject) {
        
        var errorMessage = ""
        
        defer {
            if !errorMessage.isEmpty {
                showAlert(errorMessage)
            }
        }
        
        guard let address = address.text where !address.isEmpty else {
            errorMessage = "地址能为空"
            self.address.becomeFirstResponder()
            return
        }
        
        guard let portStr = port.text, port = Int(portStr) where !portStr.isEmpty else {
            errorMessage = "端口能为空"
            self.port.becomeFirstResponder()
            return
        }
        
        NSUserDefaults.standardUserDefaults().setObject(address, forKey: "com.rpiproject.hostaddress")
        NSUserDefaults.standardUserDefaults().setInteger(port, forKey: "com.rpiproject.hostport")
        if let name = name.text where !name.isEmpty {
            NSUserDefaults.standardUserDefaults().setObject(name, forKey: "com.rpiproject.hostname")
        }
        
        if Client.shared.inputIsReady && Client.shared.outputIsReady {
            performSegueWithIdentifier("ShowModulesViewController", sender: nil)
        } else {
            Client.shared.connect(address, port: UInt32(port))
            Client.shared.handleConnected = { [unowned self] in
                self.performSegueWithIdentifier("ShowModulesViewController", sender: nil)
            }
        }
    }
}

// MARK: - UITableViewDatasource, UITableViewDelegate
extension MainViewController {
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
