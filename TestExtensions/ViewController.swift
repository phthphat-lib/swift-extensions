//
//  ViewController.swift
//  TestExtensions
//
//  Created by Lucas Pham on 2/12/20.
//  Copyright © 2020 phthphat. All rights reserved.
//

import UIKit
import Extensions

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.vstack(
            CustomView()
        )
    }
}

class CustomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        vstack(
            hstack(
                UIImageView(backgroundColor: .red)
                    .with(width: 50)
                    .with(cornerRadius: 25),
                UILabel(text: "David XXX"),
                UIButton(title: "Press me", titleColor: .systemBlue, target: self, action: #selector(onTapBtn)),
                spacing: 10
            ).with(margins: .init(top: 5, left: 5, bottom: 5, right: 5)).with(height: 60),
            UIView(backgroundColor: .systemGray),
            hstack(
                UILabel(text: "The quick brown fox \n jump over the \n lazy dog", numberOfLines: 0),
                UILabel(text: "Hey, what're you gonna do today", numberOfLines: 0),
                spacing: 10
            ),
            hstack(
                UIButton(title: "Hello", titleColor: .green),
                UIButton(title: "World", titleColor: .red),
                UIButton(title: "!", titleColor: .brown),
                distribution: .fillEqually
            ),
            spacing: 10
        )
    }
    
    @objc func onTapBtn() {
        print("Press me")
    }
}
