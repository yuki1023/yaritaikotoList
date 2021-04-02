//
//  AddListViewController.swift
//  originalApp
//
//  Created by Yamamoto Chisato on 2020/09/16.
//  Copyright © 2020 Yamamoto Chisato. All rights reserved.
//

import UIKit
import NCMB

class AddListViewController: UIViewController {
    
    @IBOutlet var memoTextView : UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        memoTextView.becomeFirstResponder()
    }
    
    @IBAction func save() {
        let object = NCMBObject(className: "List")
        object?.setObject(memoTextView.text, forKey: "list")
        object?.setObject("", forKey: "imageUrl")
        object?.setObject(UserDefaults.standard.object(forKey: "userName"), forKey:"userName")
        object?.setObject(false, forKey: "isChecked")
        object?.saveInBackground({ (error) in
            if error != nil {
                print(error)
            } else {
                let alertController = UIAlertController(title: "保存完了", message: "リストの保存が完了しました。リスト一覧に戻ります。", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler:{ (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(action)
                alertController.popoverPresentationController?.sourceView = self.view
                        
                        let screenSize = UIScreen.main.bounds
                        // ここで表示位置を調整
                        // xは画面中央、yは画面下部になる様に指定
                        alertController.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
}

