//
//  ViewController.swift
//  SRDrawerMenu
//
//  Created by CEPL on 19/07/17.
//  Copyright © 2017 OFTL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func openMenuAction(_ sender: Any) {
        SRDrawerMenu.menu.openMenu(withSelectedIndex: 0, position: .right) { (selectedIndex, selectedString) in
            print("Selected : \(selectedString ?? "") \n Index : \(selectedIndex ?? 1)")
        }
    }
    
}

