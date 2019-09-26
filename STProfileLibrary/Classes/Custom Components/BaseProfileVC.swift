//
//  BaseProfileVC.swift
//  Profile
//
//  Created by HIPL-GLOBYLOG on 7/22/19.
//  Copyright © 2019 learning. All rights reserved.
//

import UIKit
import Alamofire

public class BaseProfileVC: UIViewController {
    @IBOutlet weak var basicViewHeight: NSLayoutConstraint!
    @IBOutlet weak var headerViewP: ProfileHeader!
     @IBOutlet weak var noDataFoundView: UIView!
     @IBOutlet weak var noDataFound_label: UILabel!
    override public func viewDidLoad() {
         super.viewDidLoad()
        if headerViewP == nil {
            
        }
        else {
       // headerViewP.setProfileImages(imageName: "farmood.jpg")
            headerViewP.vc = self
        headerViewP.plusBtb.addTarget(self, action: #selector(setBasicInfoOpenClose(btn:)), for: .touchUpInside)
//            let imageEdit = UIImage(named: "edit")
//            self.headerViewP.editBtn.setImage(imageEdit, for: .selected)
//            self.headerViewP.editBtn.setImage(imageEdit, for: .normal)
//             self.headerViewP.editBtn.setImage(imageEdit, for: .highlighted)
        }
        
        if noDataFound_label != nil {
            noDataFound_label.text = noDataTxt_account
            
        }
       
      //  headerViewP.setBasicHeight(height: 0)
       // basicViewHeight.constant = 185
        
    }
    @objc func setBasicInfoOpenClose(btn: UIButton) {
        if btn.isSelected == true {
             btn.isSelected = false
            headerViewP.setBasicHeight(height: 185)
            basicViewHeight.constant = 395
        }
        else {
             btn.isSelected = true
            headerViewP.setBasicHeight(height: 0)
            basicViewHeight.constant = 185
            
        }
    
       
    }
    
    func removePassportew(type: String,recordId: String,success: @escaping(String) -> Void) {
        
    }
    func removePassport(urlName: String,type: String,recordId: String,success: @escaping(Bool) -> Void) {
                var params: Parameters = [:]
             //   params["RECORD_TYPE"] = type
                params[type] = recordId
        
        let postParamHeaders = [String: String]()
        
        ServerCommunication.getDataWithGetWithDataResponse(url: urlName, parameter: params, HeaderParams: postParamHeaders, methodType:.post, viewController: self, success: { (successResponseData) in
            
            success(true)
            /*
                        if let dictFailure = successResponseData.result.value as? [String: AnyObject]{
                            
                            if let msg = dictFailure["message"] as? String
                            {
                                
                                DataUtil.alertMessage(msg , viewController: self)
                            }
                        }
                    */
            
                
            
            
        }) { (dictFailure) in
            if let msg = dictFailure.value(forKey: "message"){
                
                DataUtil.alertMessage(msg as! String, viewController: self)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
