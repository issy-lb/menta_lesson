//
//  ViewController.swift
//  sideMenuTest
//
//  Created by 石田洋輔 on 2021/02/27.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var shadowView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 影の方向（width=右方向、height=下方向、CGSize.zero=方向指定なし）
        shadowView.layer.shadowOffset = CGSize(width: -5.0, height: 2.0)
        // 影の色
        shadowView.layer.shadowColor = UIColor.black.cgColor
        // 影の濃さ
        shadowView.layer.shadowOpacity = 0.6
        // 影をぼかし
        shadowView.layer.shadowRadius = 4
    }


}

