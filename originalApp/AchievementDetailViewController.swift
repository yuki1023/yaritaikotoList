//
//  AchievementDetailViewController.swift
//  originalApp
//
//  Created by Yamamoto Chisato on 2020/10/07.
//  Copyright © 2020 Yamamoto Chisato. All rights reserved.
//

import UIKit
import NYXImagesKit
import NCMB
import UITextView_Placeholder
import SVProgressHUD
import Kingfisher
import KRProgressHUD

class AchievementDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedMemo: NCMBObject!
    
    var memory = [NCMBObject]()
    
    let placeholderImage = UIImage(named: "photoPlaceholder")
    
    var resizedImage: UIImage!
    
    @IBOutlet var postImageView: UIImageView!
    
    @IBOutlet var postButton: UIBarButtonItem!
    
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
        
        
        loadData()
        
        memoTextView.text = selectedMemo.object(forKey: "list") as! String
        
        postImageView.image = placeholderImage
        
        self.postImageView.layer.borderColor = UIColor.blue.cgColor
        self.postImageView.layer.borderWidth = 5
        
        
        
        
        //              postButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print(memory)
        
        //        if memory != [] {
        //
        //        let object = memory[0]
        //
        //
        //        self.memoTextView.text = object.object(forKey: "list") as! String
        //
        //      let imageUrl = object.object(forKey: "imageUrl") as! String
        //
        //        postImageView.kf.setImage(with: URL(string: imageUrl))
        //
        //        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        resizedImage = selectedImage.scale(byFactor:0.3)
        
        postImageView.image = resizedImage
        
        picker.dismiss(animated: true, completion: nil)
        
        //            confirmContent()
        
    }
    
    @IBAction func selectImage() {
        let alertController = UIAlertController(title: "画像選択", message: "シェアする画像を選択して下さい。", preferredStyle: .actionSheet)
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            alertController.popoverPresentationController?.sourceView = self.view
                    let screenSize = UIScreen.main.bounds
            alertController.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { (action) in
            // カメラ起動
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("この機種ではカメラが使用出来ません。")
            }
        }
        
        let photoLibraryAction = UIAlertAction(title: "フォトライブラリから選択", style: .default) { (action) in
            // アルバム起動
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("この機種ではフォトライブラリが使用出来ません。")
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.popoverPresentationController?.sourceView = self.view
                
                let screenSize = UIScreen.main.bounds
                // ここで表示位置を調整
                // xは画面中央、yは画面下部になる様に指定
                alertController.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func sharePhoto() {
        //           SVProgressHUD.show()
        
        if resizedImage != nil {
            KRProgressHUD.show()
            // 撮影した画像をデータ化したときに右に90度回転してしまう問題の解消
            UIGraphicsBeginImageContext(resizedImage.size)
            let rect = CGRect(x: 0, y: 0, width: resizedImage.size.width, height: resizedImage.size.height)
            resizedImage.draw(in: rect)
            resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let data = resizedImage.pngData()
            
            print(data)
            // ここを変更（ファイル名無いので）
            let file = NCMBFile.file(with: data) as! NCMBFile
            file.saveInBackground({ (error) in
                if error != nil {
                    //                   SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "画像アップロードエラー", message: error!.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        
                    })
                    alert.addAction(okAction)
                    alert.popoverPresentationController?.sourceView = self.view
                            
                            let screenSize = UIScreen.main.bounds
                            // ここで表示位置を調整
                            // xは画面中央、yは画面下部になる様に指定
                            alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    
                    let query = NCMBQuery(className: "List")
                    query?.whereKey("objectId", equalTo: self.selectedMemo.object(forKey: "objectId"))
                    query?.findObjectsInBackground({ (result, error) in
                        if error != nil{
                            print(error)
                        } else {
                            print(result)
                            
                            let postObjects = result as! [NCMBObject]
                            
                            
                            let postObject = postObjects[0]
                            
                            
                            let url = "https://mbaas.api.nifcloud.com/2013-09-01/applications/Pb2hYwHLRCmAF0EX/publicFiles/" + file.name
                            postObject.setObject(url, forKey: "imageUrl")
                            postObject.saveInBackground({ _ in (error)
                                if error != nil {
                                    print(error)
                                    //                           SVProgressHUD.showError(withStatus: error!.localizedDescription)
                                } else {
                                    KRProgressHUD.dismiss()
                                    
                                    self.postImageView.image = nil
                                    self.postImageView.image = UIImage(named: "photo-placeholder")
                                    //                           self.postTextView.text = nil
                                    
                                    let alertController = UIAlertController(title: "保存完了", message: "詳細の保存が完了しました。達成リスト一覧に戻ります。", preferredStyle: .alert)
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
                    })
                    
                    
                    
                }
            })
        }
    }
    
    
    func loadData() {
        KRProgressHUD.show()
        let query = NCMBQuery(className: "List")
        query?.whereKey("objectId", equalTo: self.selectedMemo.object(forKey: "objectId"))
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                print(error)
            } else {
                print(result)
                
                let object = result as! [NCMBObject]
                
           
                    self.memory = object
                    if self.memory != [] {
                        
                        let object = self.memory[0]
                        
                        
                        self.memoTextView.text = object.object(forKey: "list") as! String
                        
                        
                        
                        let imageUrl = object.object(forKey: "imageUrl") as! String
                        
                        print(imageUrl)
                        
                        self.postImageView.kf.setImage(with: URL(string: imageUrl))
                        KRProgressHUD.dismiss()
                        
                        
                    }
                
                
                //                    self.memory = object
                
                print(self.memory)
            }
        })
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
    
    
    
    
    @IBAction func cancel() {
        
        
        let alert = UIAlertController(title: "投稿内容の破棄", message: "入力中の投稿内容を破棄しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.postImageView.image = UIImage(named: "photo-placeholder")
            //               self.confirmContent()
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
