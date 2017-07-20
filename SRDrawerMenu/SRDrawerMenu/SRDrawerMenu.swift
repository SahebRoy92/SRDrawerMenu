//
//  SRDrawerMenu.swift
//  SRDrawerMenu
//
//  Created by CEPL on 19/07/17.
//  Copyright © 2017 OFTL. All rights reserved.
//

import Foundation
import UIKit


enum SRDrawerMenuPosition {
    case top
    case bottom
    case left
    case right

}

typealias SRDrawerMenuCompletion = (Int?,String?) -> Void

class SRDrawerMenu {
    static let menu = SRDrawerMenu()
    var menuView : SRDrawerMenuView!
    var completionBlock : SRDrawerMenuCompletion!
    

    func openMenu(withSelectedIndex index : Int , position p : SRDrawerMenuPosition,andCompletion completion:@escaping SRDrawerMenuCompletion){
        self.completionBlock = completion
        self.showMenu()
    }
    
    
    private func showMenu(){
        if(menuView == nil){
            let window = UIApplication.shared.keyWindow
            menuView = SRDrawerMenuView.init(frame: (window?.bounds)!)
            menuView.delegate = self
            window?.addSubview(menuView)
            menuView.configure(withItems: ["Settings","About us","Contact us","Logout"], andPosition: .right)
            menuView.animateOpen()
        }
        
    }
    
    func hideMenu(){
        menuView.animateClose()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.menuView = nil
        }
    }
    
}


extension SRDrawerMenu : SRDrawerViewDelegate{
    func didSelectOnOption(withString s: String?, indexPath i: Int?) {
        self.hideMenu()
        self.completionBlock(i,s)
    }
}



protocol  SRDrawerViewDelegate {
    func didSelectOnOption(withString s : String?, indexPath i : Int?)
}

class SRDrawerMenuView : UIView {
    
    var delegate : SRDrawerViewDelegate!
    var tableSuper : UIView!
    var allitems : Array<String>!
    var position : SRDrawerMenuPosition!
    let tableView = UITableView(frame: .zero)
    var frameTableview : CGRect!
    
    func configure(withItems a : Array<String>,andPosition p : SRDrawerMenuPosition){
        position = p
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)
        self.tableSuper = UIView.init(frame: .zero)
        self.tableSuper.backgroundColor = UIColor.white
        self.tableSuper.addSubview(tableView)
        self.addSubview(tableSuper)
        self.allitems = a
        self.tableView.tableFooterView = UIView.init(frame: .zero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 35
        self.calculateMaxheight()
        
    }
    
    
    func animateClose(){
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveLinear, animations: { 
           
            let bounds = UIApplication.shared.keyWindow?.bounds
            var frame = self.tableSuper.frame
            frame.origin.x = (bounds?.size.width)! + 20
            self.tableSuper.frame = frame
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                 self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)
            }, completion: { (_) in
                self.removeFromSuperview()
                self.cleanup()
            })
        }

    }
    
    
    func cleanup(){
        self.allitems = nil
        //self.tableView = nil
    }
    
    func animateOpen(){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveLinear, animations: {
            
            self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
            self.tableSuper.frame = self.frameTableview
        }) { (finished) in
            
        }
    }
    
    func calculateMaxheight(){
        let bounds = UIApplication.shared.keyWindow?.bounds
        let maxHeight = (bounds?.size.height)! * 0.7
            
        let totalHeight = CGFloat(allitems.count) * 35.0
        var frame = tableView.frame
        if(totalHeight > maxHeight){
            tableView.isScrollEnabled = true
        }
        else {
            tableView.isScrollEnabled = false
        }
        frame.size.width            = (bounds?.size.width)! * 0.45
        frame.size.height           = (bounds?.size.height)!
        frame.origin.x              = (bounds?.size.width)! + 10
        frame.origin.y              = 0
        self.tableSuper.frame       = frame
        self.tableView.frame        = CGRect.init(x: 0, y: 20, width: self.tableSuper.bounds.size.width, height: self.tableSuper.bounds.size.height)
        frame.origin.x              = (bounds?.size.width)! - frame.size.width + 10
        frameTableview              = frame
            
    }
        

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if(touch?.view != self.tableView){
            self.delegate.didSelectOnOption(withString: nil, indexPath: nil)
            print("Close menu!----")
        }
    }
    
    deinit {
        print("This view is going off---->>>")
    }
    
    
}

extension SRDrawerMenuView : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allitems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuse = "reuse"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuse)
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: reuse)
            cell?.selectionStyle = .none
        }
        cell?.textLabel?.text = allitems[indexPath.row]
        return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stringSelected = allitems[indexPath.row]
        let selectedIndex = indexPath.row
        self.delegate.didSelectOnOption(withString: stringSelected, indexPath: selectedIndex)
    }
    
    
}

