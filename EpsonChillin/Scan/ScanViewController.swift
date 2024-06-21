//
//  PrintViewController.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/21/24.
//

import UIKit

class PrintViewController: BaseViewController {
    
    
    var printView = PrintView()
    
    override func loadView() {
        self.view = printView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view?.backgroundColor = UIColor(named: "MainBackGroundColor")
    }
    
    override func configureView() {
        
    }
    
    @objc func printButtonTapped() {
        
    }
    
}
