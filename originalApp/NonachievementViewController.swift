//
//  NonachievementViewController.swift
//  originalApp
//
//  Created by Yamamoto Chisato on 2020/10/08.
//  Copyright © 2020 Yamamoto Chisato. All rights reserved.
//

import UIKit
import NCMB

class NonachievementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ListTableViewCellDelegate, NonachievementTableViewCellDelegate  {
    
    var memoArray = [NCMBObject]()
    
    var isCheckedArray = [Bool]()
    var isChecked = false
    var objIds = [String]()
    var users = [String]()
    var texts = [String]()
    
    
    
    
    
    @IBOutlet var nonachievementTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imageView = UIImageView(frame: CGRect (x: 0, y: 0, width: self.nonachievementTableView.frame.width, height: self.nonachievementTableView.frame.height))
            // read image
            let image = UIImage(named: "example6.jpg")
            // set image to ImageView
            imageView.image = image
            // set alpha value of imageView
            imageView.alpha = 0.5
            // set imageView to backgroundView of TableView
            self.nonachievementTableView.backgroundView = imageView

        nonachievementTableView.dataSource = self
        nonachievementTableView.delegate = self
        
        nonachievementTableView.tableFooterView = UIView()
        
        //カスタムセルの登録
        let nib = UINib(nibName: "NonachievementTableViewCell", bundle: Bundle.main)
        nonachievementTableView.register(nib, forCellReuseIdentifier: "NonachievementCell")
        
        print(isCheckedArray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NonachievementCell") as? NonachievementTableViewCell
        
        cell?.backgroundColor = .clear
                let cellBackgroundView = UIView()
                cellBackgroundView.backgroundColor = UIColor.init(red: 105/255, green: 192/255, blue: 248/255, alpha: 1)
        cell?.selectedBackgroundView = cellBackgroundView

        cell!.delegate = self
        cell!.tag = indexPath.row
        
        cell?.backgroundColor = UIColor.clear
        cell?.contentView.backgroundColor = UIColor.clear
      
        
//        let user = users[indexPath.row]
        let text = texts[indexPath.row]
        
        cell?.listTextLabel.text = text
        
        
        
        // Likeによってハートの表示を変える
        if isCheckedArray[indexPath.row] == true {
            cell!.checkBoxButton.setImage(UIImage(named: "checked2"), for: .normal)
               } else {
                cell!.checkBoxButton.setImage(UIImage(named: "unchecked2"), for: .normal)
               }
        return cell!
    }
    
    func didTapLikeButton(tableViewCell: UITableViewCell, button: UIButton) {
           print(isCheckedArray[tableViewCell.tag])
        if isCheckedArray[tableViewCell.tag] == false || isCheckedArray[tableViewCell.tag] == nil {
               let query = NCMBQuery(className: "List")
            query?.getObjectInBackground(withId: objIds[tableViewCell.tag], block: { (post, error) in
                if error != nil {
//                           SVProgressHUD.showError(withStatus: error!.localizedDescription)
                 print(error)
                } else {
                print(self.objIds[tableViewCell.tag])
                    print(post)
//                   post?.addUniqueObject(NCMBUser.current().objectId, forKey: "likeUser")
                post?.setObject(true, forKey: "isChecked")
                   post?.saveEventually({ (error) in
                       if error != nil {
//                           SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        print(error)
                       } else {
                           self.loadData()
                       }
                   })
                }
               })
           } else {
               let query = NCMBQuery(className: "List")
               query?.getObjectInBackground(withId: objIds[tableViewCell.tag], block: { (post, error) in
                   if error != nil {
//                       SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    print(error)
                   } else {
                    print(post)

                    post?.setObject(false, forKey: "isChecked")
                       post?.saveEventually({ (error) in
                           if error != nil {
                             print(error)
                           } else {
                               self.loadData()
                           }
                       })
                   }
               })
           }
       }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .white
//        print(indexPath.row)
//        self.performSegue(withIdentifier: "toListDetail", sender: nil)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //次の画面の取得(Detail)
//        if segue.identifier == "toListDetail" {
//            let detailListViewController = segue.destination as! DetailListViewController
//            
//            let selectedIndex = nonachievementTableView.indexPathForSelectedRow!
//            
//            detailListViewController.selectedMemo = memoArray[selectedIndex.row]
//        }
//        
//    }
//
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            // セルの選択が外れた時に文字色を変更（元の色に戻す）
            tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .black
        }
    
    func loadData() {
        let query = NCMBQuery(className: "List")
        query?.addAscendingOrder("createDate")
        query?.whereKey("userName", equalTo: UserDefaults.standard.object(forKey: "userName"))
        query?.whereKey("isChecked", equalTo: false)
               query?.findObjectsInBackground({ (result, error) in
                   if error != nil{
                       print(error)
                   } else {
                    
                    self.memoArray = result as! [NCMBObject]
                    let objects = result as! [NCMBObject]
                    
                    self.users = [String]()
                    self.texts = [String]()
                    self.objIds = [String]()
                    self.isCheckedArray = [Bool]()
                    
                    
                    for object in objects{
                        
                        let text = object.object(forKey: "list")
                        let user = object.object(forKey: "userName")
                        print(user)
                       
                        let objId = object.objectId
                        
                    
                    // likeの状況(自分が過去にLikeしているか？)によってデータを挿入
                    let checkObject = object.object(forKey: "isChecked") as? Bool
                        print(checkObject)
                        if checkObject == true {
                               self.isChecked = true
                   } else {
                                self.isChecked = false
                             }
                        
                        self.users.append(user as! String)
                        self.texts.append(text as! String)
                        self.objIds.append(objId!)
                        self.isCheckedArray.append(self.isChecked)
                        print(self.isChecked)

                    }
                    print(self.isCheckedArray)
                       self.nonachievementTableView.reloadData()
                    
                   }
               })
    }
}







