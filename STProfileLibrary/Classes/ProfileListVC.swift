//
//  ProfileListVC.swift
//  Profile
//
//  Created by HIPL-GLOBYLOG on 7/31/19.
//  Copyright © 2019 learning. All rights reserved.

import UIKit
import Alamofire
import SDWebImage
class ProfileListVC: BaseProfileVC {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var footrView: UIView!
    var obj_lookUpType: ProfileLookupType?
    var arrValueArray = [String]()
    var attributArray = [AttributeForm]()
    var attributArrayClone = [AttributeFormClone]()
    var detailArray = [DetailListProfile]()
    var buttonRightItem: UIBarButtonItem!
    var heightOfFooter = 100.0
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = 300
        
        if #available(iOS 11.0, *) {
            tblView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        if let obj = obj_lookUpType {
            self.title = obj.LOOKUP_TYPE ?? ""
        }
        self.tblView.tableFooterView = footrView
        super.viewDidLoad()
        for _ in 0...62 {
            arrValueArray.append("")
        }
         DispatchQueue.main.async {
        self.headerViewP.setBasicHeight(height: 0)
        self.basicViewHeight.constant = 185
        self.headerViewP.plusBtb.isSelected = true
        }
        
        tblView.isHidden = true
        self.tblView.rowHeight = UITableView.automaticDimension;
        self.tblView.estimatedRowHeight = 200;
        let podBundle = Bundle(for: ProfileListVC.self)
    
        let image = UIImage(named: "acount_plus_icon")?.withRenderingMode(.alwaysOriginal)
       //alwaysOriginal withRenderingMode(.alwaysOriginal)
         buttonRightItem = UIBarButtonItem(image:image, style: .plain, target: self, action: #selector(addNewClicked))
        
    //    self.navigationItem.rightBarButtonItem  = buttonRightItem
 
     
        self.perform(#selector(getData), with: nil)
    
        let imageback = UIImage(named: "acount_back_arrow")
        let button1 = UIBarButtonItem(image:imageback, style: .plain, target: self, action: #selector(backBtnClicked))
        // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.leftBarButtonItem  = button1
  
    }
    @objc func backBtnClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func addNewClicked() {
        let podBundle = Bundle(for: ListViewForAllVC.self)
        let story = UIStoryboard(name: "Main", bundle: podBundle)
        
        let obj = story.instantiateViewController(withIdentifier: "ListViewForAllVC") as! ListViewForAllVC
        
        obj.obj_lookUpType = self.obj_lookUpType
        obj.attributArrayClone = self.attributArrayClone
        obj.delegateUpdate = self
        self.present(obj, animated: true, completion: nil)
        // self.navigationController?.pushViewController(obj, animated: true)
 
        
    }
    
    func isValidate() -> Bool {
        for item in self.attributArray {
            if item.PROFILE_ATTRIBUTE_REQUIRED == "Y" {
                if let text = item.PROFILE_ATTRIBUTE_DEFAULT_VALUE, let desc = item.PROFILE_ATTRIBUTE_DESCRIPTION {
                    
                    if text.count < 1 {
                        DataUtil.alertMessage("Please enter \(desc)", viewController: self)
                        
                        return false
                        
                    }
                    
                }
                else {
                    DataUtil.alertMessage("Please enter \(item.PROFILE_ATTRIBUTE_DESCRIPTION!)", viewController: self)
                    return false
                }
                
                
            }
            
            
        }
        
        
        return true
    }
    @objc func getData(){
        
         attributArray = [AttributeForm]()
         attributArrayClone = [AttributeFormClone]()
         detailArray = [DetailListProfile]()
        if let obj = obj_lookUpType {
            
            // "LOOKUP_FLAG":"X", "SYSTEM_ID":"T", "SIGNIN_TYPE":"P"
            let params:Parameters =  ["LOOKUP_TYPE_ID": obj.LOOKUP_TYPE_ID ?? ""]
            
            let postParamHeaders = [String: String]()
            
            ServerCommunication.getDataWithGetWithDataResponse(url: "hrProfileAttributes", parameter: params, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success: { (successResponseData) in
                self.tblView.isHidden = false
                if let cryptoData = successResponseData.data {
                    
                    do {
                        let decoder = JSONDecoder()
                        
                        let serviceResponse = try decoder.decode(AttributProfileData.self, from: cryptoData)
                        if serviceResponse.success == true {
                        if var types = serviceResponse.data?.ATTRIBUTES {
                                self.attributArray = types
                self.attributArrayClone.removeAll()
            for item in self.attributArray {
                let objClone = AttributeFormClone()
                objClone.LOOKUP_TYPE_ID = item.LOOKUP_TYPE_ID
                objClone.PROFILE_ATTRIBUTE_ID = item.PROFILE_ATTRIBUTE_ID
                
                objClone.HR_PROFILE_ATTRIBUTE_ID = item.HR_PROFILE_ATTRIBUTE_ID
                objClone.PROFILE_ATTRIBUTE_DESCRIPTION = item.PROFILE_ATTRIBUTE_DESCRIPTION
                objClone.PROFILE_ATTRIBUTE_TYPE = item.PROFILE_ATTRIBUTE_TYPE
                objClone.PROFILE_ATTRIBUTE_SIZE = item.PROFILE_ATTRIBUTE_TYPE
                objClone.PROFILE_ATTRIBUTE_DEFAULT_VALUE = item.PROFILE_ATTRIBUTE_DEFAULT_VALUE
                objClone.PROFILE_ATTRIBUTE_REQUIRED = item.PROFILE_ATTRIBUTE_REQUIRED
                objClone.PROFILE_ATTRIBUTE_SEQUENCE = item.PROFILE_ATTRIBUTE_SEQUENCE
                objClone.PROFILE_ATT_LOOKUP_SOURCE = item.PROFILE_ATT_LOOKUP_SOURCE
                objClone.PROFILE_ATT_LOOKUP_FILTER_ID = item.PROFILE_ATT_LOOKUP_FILTER_ID
                objClone.PROFILE_ATTRIBUTE_DEFAULT_LOOKUP_ID = item.PROFILE_ATTRIBUTE_DEFAULT_LOOKUP_ID
                objClone.PROFILE_ATTRIBUTE_GEO_LEVEL = item.PROFILE_ATTRIBUTE_GEO_LEVEL
                objClone.PROFILE_ATTTRIBUTE_HELP_ID = item.PROFILE_ATTTRIBUTE_HELP_ID
                objClone.PROFILE_ATTRIBUTE_HIDE_VALUE = item.PROFILE_ATTRIBUTE_HIDE_VALUE
                objClone.PROFILE_ATTRIBUTE_HIDE_VALUE = item.PROFILE_ATTRIBUTE_HIDE_VALUE
                objClone.ADDITIONAL_ATTRIBUTES = item.ADDITIONAL_ATTRIBUTES
                self.attributArrayClone.append(objClone)
                                }
                                
                            }
                            if let detail = serviceResponse.data?.DETAIL {
                                self.detailArray = detail
                                self.tblView.reloadData()
             if let row = serviceResponse.data?.MULTIPLE_ROWS {
                if row == "N" && self.detailArray.count > 0 {
                    if self.buttonRightItem != nil {
                    self.buttonRightItem.isEnabled = false
                    self.navigationItem.rightBarButtonItem = nil
                        
                    }
                 }
                else {
                    self.buttonRightItem.isEnabled = true
                    self.navigationItem.rightBarButtonItem = self.buttonRightItem
                }
                }
             else {
                self.buttonRightItem.isEnabled = true
                 self.navigationItem.rightBarButtonItem = self.buttonRightItem
                }
                                
                }
               }
                        else {
                            
                            
                            if let dictFailure = successResponseData.result.value as? [String: AnyObject]{
                                
                                if let msg = dictFailure["message"] as? String
                                {
                                    
                                    DataUtil.alertMessage(msg , viewController: self)
                                }
                            }
                        }
 
                        if self.detailArray.count < 1 {
                            self.noDataFoundView.isHidden = false
                        }
                        else {
                            self.noDataFoundView.isHidden = true
                        }
                        
                    } catch let jsonError {
                        print("jsonError ===",jsonError)
                    }
                    
                    
                    
                    
                }
                else {
                    
                    
                    
                }
                
            }) { (dictFailure) in
                if let msg = dictFailure.value(forKey: "message"){
                    
                    DataUtil.alertMessage(msg as! String, viewController: self)
                }
            }
        }
    }
    @objc func openOptionsforCell(btn: UIButton) {
        let objDetailProfile = self.detailArray[btn.tag]
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title:"Edit", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
              let podBundle = Bundle(for: ListViewForAllVC.self)
            
            let story = UIStoryboard(name: "Main", bundle: podBundle)
            
            let obj = story.instantiateViewController(withIdentifier: "ListViewForAllVC") as! ListViewForAllVC
                var i = 0
            for item in self.attributArray {
                 item.imageUrlStr = [ImageValue]()
                 item.cellHeight = nil
                if objDetailProfile.LIST != nil && i <= objDetailProfile.LIST!.count {
                  let arr =  objDetailProfile.LIST?.filter({ $0.PROFILE_ATTRIBUTE_ID! == item.PROFILE_ATTRIBUTE_ID! })
                    
                    
                   
                    if arr != nil && arr!.count > 0 {
                        item.HR_PROFILE_ATTRIBUTE_ID = arr?[0].HR_PROFILE_ATTRIBUTE_ID
                        item.PROFILE_ATTRIBUTE_DEFAULT_VALUE = arr?[0].VALUE
                        item.LOOKUP_ID = arr?[0].LOOKUP_ID
                        item.imageUrlStr = arr?[0].IMAGE_VALUE
                        item.imageData = [Data]()
                        
                    }
                    
                }
               i = i + 1
            }
            
            obj.dataSetId = objDetailProfile.LIST_ID
            obj.obj_lookUpType = self.obj_lookUpType
            obj.attributArray = self.attributArray
            obj.delegateUpdate = self
            
            self.present(obj, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title:"Delete", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            if let recordId = objDetailProfile.LIST_ID {
                
                self.deleteProfileData(recordId: recordId, index: btn.tag)
                /*
                
                self.removePassport(type: "PASSPORT", recordId: recordId, success: { (str) in
                    
                    self.detailArray.remove(at: btn.tag)
                    self.tblView.reloadData()
                    if self.detailArray.count < 1 {
                        self.noDataFoundView.isHidden = false
                    }
                    else {
                        self.noDataFoundView.isHidden = true
                    }
                    
                })
                */
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action: UIAlertAction!) in
        }))
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY-60, width: 0, height: 0)
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.down;
            }
        }
        present(alert, animated: true, completion: nil)
        
    }
    func deleteProfileData(recordId: String, index: NSInteger) {
        if let obj = obj_lookUpType {
            let params:Parameters =  ["LOOKUP_TYPE_ID": obj.LOOKUP_TYPE_ID ?? "", "DATASET_ID": recordId]
            let postParamHeaders = [String: String]()
        ServerCommunication.getDataWithGetWithDataResponse(url: "deteleProfileData", parameter: params, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success: { (successResponseData) in
                self.tblView.isHidden = false
                if let cryptoData = successResponseData.data {
     
                    if let json = successResponseData.result.value as? NSDictionary {
                        
                        if let succ = json["success"] as? Bool {
                            
                            if succ == true {
                                self.detailArray.remove(at: index)
                                self.tblView.reloadData()
                                if self.detailArray.count < 1 {
                                    self.noDataFoundView.isHidden = false
                                    self.buttonRightItem.isEnabled = true
                            self.navigationItem.rightBarButtonItem = self.buttonRightItem
                                }
                                else {
                                    self.noDataFoundView.isHidden = true
                                }
                            }
                            else {
                                if let data = json["data"] as? NSDictionary {
                                    let msg = data["message"] as! String
                                    DataUtil.alertMessage(msg, viewController: self)
                                }
                           }
                        }
                    }
                    
                }
                else {
                }
            
            }) { (dictFailure) in
                if let msg = dictFailure.value(forKey: "message"){
                    
                    DataUtil.alertMessage(msg as! String, viewController: self)
                }
            }
        }
    }
}
extension ProfileListVC: UITableViewDataSource, UITableViewDelegate,updateProfileListData{
    func updateListData(attributArray: [AttributeForm],listId: String, isUpdate: Bool) {
        attributArrayClone.removeAll()
          self.perform(#selector(getData), with: nil)
          return
        if isUpdate == true {
            //let obj = DetailListProfile()
           // obj.LIST_ID = listId
           // let LIST = [ListData]()
          let arr = self.detailArray.filter({$0.LIST_ID! == listId})
            if arr.count > 0 {
                var i = 0
                let listarr = arr[0].LIST!
                for item in listarr {
                    let arrAttribute = self.attributArray.filter({$0.PROFILE_ATTRIBUTE_ID! == item.PROFILE_ATTRIBUTE_ID!})
                    if arrAttribute.count > 0 {
                       item.VALUE = arrAttribute[0].PROFILE_ATTRIBUTE_DEFAULT_VALUE
                        item.PROFILE_ATTRIBUTE_ID = arrAttribute[0].PROFILE_ATTRIBUTE_ID
                        
                    }
                    
                    i = i + 1
                }
            }
            /*
            for item in attributArray {
                let listData = ListData()
                listData.TITLE = item.PROFILE_ATTRIBUTE_DESCRIPTION
                listData.VALUE = item.PROFILE_ATTRIBUTE_DEFAULT_VALUE
                listData.TYPE = item.PROFILE_ATTRIBUTE_TYPE
                LIST.append(listData)
            }
            */
           // obj.LIST = LIST
           // self.detailArray.append(obj)
            self.tblView.reloadData()
            self.tblView.setContentOffset(.zero, animated: true)
        }
        else {
            let obj = DetailListProfile()
            obj.LIST_ID = listId
            var LIST = [ListData]()
            for item in attributArray {
                let listData = ListData()
                listData.TITLE = item.PROFILE_ATTRIBUTE_DESCRIPTION
                listData.VALUE = item.PROFILE_ATTRIBUTE_DEFAULT_VALUE
                listData.TYPE = item.PROFILE_ATTRIBUTE_TYPE
                 listData.HR_PROFILE_ATTRIBUTE_ID = item.HR_PROFILE_ATTRIBUTE_ID
                listData.PROFILE_ATTRIBUTE_ID = item.PROFILE_ATTRIBUTE_ID
                
                LIST.append(listData)
            }
            obj.LIST = LIST
            self.detailArray.append(obj)
            self.tblView.reloadData()
            self.tblView.setContentOffset(.zero, animated: true)
        }
        
        if self.detailArray.count < 1 {
            self.noDataFoundView.isHidden = false
        }
        else {
            self.noDataFoundView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return detailArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 1.0
        }
        else {
            return 18.0
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let obj = self.detailArray[section]
         let arr = obj.LIST?.filter({ $0.TYPE == "F" })
         if arr != nil && arr!.count > 0 {
        
                var arrProfileID = [String]()
                for item in arr! {
                    if arrProfileID.contains(item.PROFILE_ATTRIBUTE_ID!){
                        
                    }
                    else {
                        arrProfileID.append(item.PROFILE_ATTRIBUTE_ID!)
                    }
               
                }
            
                 return CGFloat(arrProfileID.count * Int(heightOfFooter))
             
            }
        
        return 1.0
    }
    

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         let obj = self.detailArray[section]
        let footerView = UIView()

        var imageListArray = [[ListData]]()
        
        if let arr = obj.LIST?.filter({ $0.TYPE == "F" }) {
            var arrProfileID = [String]()
            /*
            for item in arr {
                if arrProfileID.contains(item.PROFILE_ATTRIBUTE_ID!){
                    
                }
                else {
                arrProfileID.append(item.PROFILE_ATTRIBUTE_ID!)
                }
            }
            */
            /*
            for item in arrProfileID {
                
              let arr = arr.filter({ $0.PROFILE_ATTRIBUTE_ID == item })
                imageListArray.append(arr)
            }
            */

            footerView.frame = CGRect(x: 0, y: 0, width: Int(DataUtil.screenWidth), height: imageListArray.count * Int(heightOfFooter))
              var index = 0.0
        
        for item in arr {
            let dovView = DocumentListView()
            var frame:CGRect = dovView.frame
            frame.origin.y = CGFloat(index * heightOfFooter)
            dovView.frame = frame
            dovView.frame = CGRect(x: 0, y: Int(index * heightOfFooter), width: Int(DataUtil.screenWidth), height: Int(heightOfFooter))
            if item.IMAGE_VALUE != nil && item.IMAGE_VALUE!.count > 0 {
                dovView.imageArr = item.IMAGE_VALUE!
                dovView.titleDoc = item.TITLE ?? ""
            }
               

            
            dovView.initializeView()
               footerView.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 240.0/255.0, alpha: 1)
            footerView.addSubview(dovView)
            index = index + 1
            
        }
             return footerView
        }
        
        
      return UIView()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileListCell") as! ProfileListCell
            let obj = self.detailArray[indexPath.section]
             cell.setPassportInfoData(obj)
         cell.btnthreeDots.tag = indexPath.section
         let image = UIImage(named: "acount_threeDots")
        cell.btnthreeDots.addTarget(self, action: #selector(openOptionsforCell(btn:)), for: .touchUpInside)
        cell.btnthreeDots.setImage(image, for: .selected)
        cell.btnthreeDots.setImage(image, for: .normal)
        cell.btnthreeDots.setImage(image, for: .highlighted)

        return cell
      
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = 40 + 20
        if let list = self.detailArray[indexPath.section].LIST{
            for item in list {
                if item.TYPE! != "F" {
                height = height + 29
                }
                else {
                    
                }
            }
            
        }
        else {
            height = height + 29
        }
        return height
    }
 
}


class ProfileListCell: UITableViewCell {
    @IBOutlet weak var bottomLineViewProfile: UIView!
    
  //  @IBOutlet weak var bottomConstProfile: NSLayoutConstraint!
    @IBOutlet weak var sViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnthreeDots: UIButton!
  //  @IBOutlet weak var lblTitleValue: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var lbl6: UILabel!
    @IBOutlet weak var lbl7: UILabel!
    @IBOutlet weak var lbl8: UILabel!
    @IBOutlet weak var lbl9: UILabel!
    @IBOutlet weak var lbl10: UILabel!
    @IBOutlet weak var lbl11: UILabel!
    @IBOutlet weak var lbl12: UILabel!
    @IBOutlet weak var lbl13: UILabel!
    @IBOutlet weak var lbl14: UILabel!
    @IBOutlet weak var lbl15: UILabel!
    
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    @IBOutlet weak var lblTitle3: UILabel!
    @IBOutlet weak var lblTitle4: UILabel!
    @IBOutlet weak var lblTitle5: UILabel!
    @IBOutlet weak var lblTitle6: UILabel!
    @IBOutlet weak var lblTitle7: UILabel!
    @IBOutlet weak var lblTitle8: UILabel!
    @IBOutlet weak var lblTitle9: UILabel!
    @IBOutlet weak var lblTitle10: UILabel!
    @IBOutlet weak var lblTitle11: UILabel!
    @IBOutlet weak var lblTitle12: UILabel!
    @IBOutlet weak var lblTitle13: UILabel!
    @IBOutlet weak var lblTitle14: UILabel!
    @IBOutlet weak var lblTitle15: UILabel!
    
    
    @IBOutlet weak var lblConst1: NSLayoutConstraint!
    @IBOutlet weak var lblConst2: NSLayoutConstraint!
    @IBOutlet weak var lblConst3: NSLayoutConstraint!
    @IBOutlet weak var lblConst4: NSLayoutConstraint!
    @IBOutlet weak var lblConst5: NSLayoutConstraint!
    @IBOutlet weak var lblConst6: NSLayoutConstraint!
    @IBOutlet weak var lblConst7: NSLayoutConstraint!
    @IBOutlet weak var lblConst8: NSLayoutConstraint!
    @IBOutlet weak var lblConst9: NSLayoutConstraint!
    @IBOutlet weak var lblConst10: NSLayoutConstraint!
    @IBOutlet weak var lblConst11: NSLayoutConstraint!
    @IBOutlet weak var lblConst12: NSLayoutConstraint!
    @IBOutlet weak var lblConst13: NSLayoutConstraint!
    @IBOutlet weak var lblConst14: NSLayoutConstraint!
    @IBOutlet weak var lblConst15: NSLayoutConstraint!
    
  //  var passportInfoList:PassportList?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setPassportInfoData(_ detilListInfo: DetailListProfile) {
        
        if let list = detilListInfo.LIST {
            
            self.lblTitle1.text = ""
            self.lbl1.text = ""
            self.lblTitle2.text = ""
            self.lbl2.text = ""
            self.lblTitle3.text = ""
            self.lbl3.text = ""
            self.lblTitle4.text = ""
            self.lbl4.text = ""
            self.lblTitle5.text = ""
            self.lbl5.text = ""
            self.lblTitle6.text = ""
            self.lbl6.text = ""
            self.lblTitle7.text = ""
            self.lbl7.text = ""
            self.lblTitle8.text = ""
            self.lbl8.text = ""
            self.lblTitle9.text = ""
            self.lbl9.text = ""
            self.lblTitle10.text = ""
            self.lbl10.text = ""
            self.lblTitle11.text = ""
            self.lbl11.text = ""
            self.lblTitle12.text = ""
            self.lbl12.text = ""
            self.lblTitle13.text = ""
            self.lbl13.text = ""
            self.lblTitle14.text = ""
            self.lbl14.text = ""
            self.lblTitle15.text = ""
            self.lbl15.text = ""
            
            var i = 0
            let finalText = NSMutableAttributedString()
          
            let myAttributeBold = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12) ]
            let myAttributeNormal = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12) ]
          
        for item in list {
            if item.TYPE! == "F" {
              //  self.bottomConstProfile.constant = 0.0
               self.bottomLineViewProfile.isHidden = true
            }
            else {
                // self.bottomConstProfile.constant = 0.0
                self.bottomLineViewProfile.isHidden = false
            }
            if item.TYPE! != "F" {
                /*

                 var titleText = ""
                if i == 0 {
                     titleText = item.TITLE ?? ""
                  
                }
                else {
                      titleText =  "\n" + (item.TITLE ?? "")
                }
              let titleAttrString = NSAttributedString(string:titleText  , attributes: myAttributeBold)
                
             let descText = item.VALUE ?? ""
             let descAttrString = NSAttributedString(string:descText  , attributes: myAttributeNormal)
                finalText.append(titleAttrString)
                 finalText.append(descAttrString)
                lblTitleValue.attributedText = finalText
                
                */
                
                
            if i == 0 {
             
                 self.lblTitle1.text = item.TITLE ?? ""
                  self.lbl1.text = item.VALUE ?? ""
                
            }
            if i == 1 {
               
                    self.lblTitle2.text = item.TITLE ?? ""
                    self.lbl2.text = item.VALUE ?? ""
                
            }
            if i == 2 {
                
                    self.lblTitle3.text = item.TITLE ?? ""
                    self.lbl3.text = item.VALUE ?? ""
                
            }
            if i == 3 {
             
                    self.lblTitle4.text = item.TITLE ?? ""
                    self.lbl4.text = item.VALUE ?? ""
                
            }
            if i == 4 {
              
                    self.lblTitle5.text = item.TITLE ?? ""
                    self.lbl5.text = item.VALUE ?? ""
                
            }
            if i == 5 {
               
                    self.lblTitle6.text = item.TITLE ?? ""
                    self.lbl6.text = item.VALUE ?? ""
                
            }
            if i == 6 {
                    self.lblTitle7.text = item.TITLE ?? ""
                    self.lbl7.text = item.VALUE ?? ""
                
            }
            if i == 7 {
            
                    self.lblTitle8.text = item.TITLE ?? ""
                    self.lbl8.text = item.VALUE ?? ""
                
            }
            if i == 8 {
              
                    self.lblTitle9.text = item.TITLE ?? ""
                    self.lbl9.text = item.VALUE ?? ""
                
            }
            if i == 9 {
               
                    self.lblTitle10.text = item.TITLE ?? ""
                    self.lbl10.text = item.VALUE ?? ""
                
            }
            if i == 10 {
                
                    self.lblTitle11.text = item.TITLE ?? ""
                    self.lbl11.text = item.VALUE ?? ""
                
            }
            if i == 11 {
               
                    self.lblTitle12.text = item.TITLE ?? ""
                    self.lbl12.text = item.VALUE ?? ""
                
            }
            if i == 12 {
             
                    self.lblTitle11.text = item.TITLE ?? ""
                    self.lbl11.text = item.VALUE ?? ""
                
            }
            if i == 13 {
                
                    self.lblTitle14.text = item.TITLE ?? ""
                    self.lbl14.text = item.VALUE ?? ""
                
            }
            if i == 14 {
                
                    self.lblTitle15.text = item.TITLE ?? ""
                    self.lbl15.text = item.VALUE ?? ""
                
            }
 
          }
         else {
                if i == 0 {
                    
              
                    self.lblConst1.constant = 0
                    
                }
                if i == 1 {
                    
                    self.lblConst2.constant = 0
                    
                }
                if i == 2 {
                    
                  self.lblConst3.constant = 0
                    
                }
                if i == 3 {
                    
                     self.lblConst4.constant = 0
                    
                }
                if i == 4 {
                    
                     self.lblConst5.constant = 0
                    
                }
                if i == 5 {
                    
                     self.lblConst6.constant = 0
                    
                }
                if i == 6 {
                   self.lblConst7.constant = 0
                    
                }
                if i == 7 {
                    self.lblConst8.constant = 0
                    
                }
                if i == 8 {
                    
                     self.lblConst9.constant = 0
                    
                }
                if i == 9 {
                    
                  self.lblConst10.constant = 0
                    
                }
                if i == 10 {
                    
                  self.lblConst11.constant = 0
                    
                }
                if i == 11 {
                    
                   self.lblConst12.constant = 0
                    
                }
                if i == 12 {
                    
                   self.lblConst13.constant = 0
                    
                }
                if i == 13 {
                    
                    self.lblConst14.constant = 0
                    
                }
                if i == 14 {
                    
                    self.lblConst15.constant = 0
                    
                }
            }
            
            i = i + 1
        }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
