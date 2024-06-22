//
//  BaseViewController.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/15/24.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
    }
    
    func configureView() {}
    
    
    func setConstraints() {}
    
}
