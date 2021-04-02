//
//  CheckBoxButton.swift
//  originalApp
//
//  Created by Yamamoto Chisato on 2020/09/28.
//  Copyright © 2020 Yamamoto Chisato. All rights reserved.
//

import UIKit
import NCMB

class CheckBoxButton: UIButton {

 let checkedImage = UIImage(named: "checked2")! as UIImage
   let uncheckedImage = UIImage(named: "unchecked2")! as UIImage
   // Bool property
   var isChecked: Bool = false {
     didSet{
       if isChecked == true {
         self.setImage(checkedImage, for: UIControl.State.normal)
        
        
        
       } else {
         self.setImage(uncheckedImage, for: UIControl.State.normal)
       }
     }
   }
   override func awakeFromNib() {
     self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
   self.isChecked = false
 }
   @objc func buttonClicked(sender: UIButton) {
     if sender == self {
       isChecked = !isChecked
     }
    }

    
    
}
