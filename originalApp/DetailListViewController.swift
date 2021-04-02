//
//  DetailListViewController.swift
//  originalApp
//
//  Created by Yamamoto Chisato on 2020/09/16.
//  Copyright © 2020 Yamamoto Chisato. All rights reserved.
//

import UIKit
import NCMB


class DetailListViewController: UIViewController {
    
    var selectedMemo: NCMBObject!
    
    @IBOutlet var memoTextView: UITextView!
    
    @IBOutlet var shadowButton: UIButton!
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.角丸設定
        // UIButtonの変数名.layer.cornerRadius = 角丸の大きさ
        shadowButton.layer.cornerRadius = 10

        // 2.影の設定
        // 影の濃さ
        shadowButton.layer.shadowOpacity = 0.7
        // 影のぼかしの大きさ
        shadowButton.layer.shadowRadius = 3
        // 影の色
        shadowButton.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        shadowButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        

        memoTextView.text = selectedMemo.object(forKey: "list") as! String
    }
    
    @IBAction func update() {
        selectedMemo.setObject(memoTextView.text, forKey: "list")
        selectedMemo.saveInBackground { (error) in
            if error != nil {
                print(error)
                
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    
    @IBAction func delete() {
        selectedMemo.deleteInBackground{ (error) in
            if error != nil {
                print(error)
                
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
