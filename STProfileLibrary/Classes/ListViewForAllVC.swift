//
//  ListViewForAllVC.swift
//  Profile
//fgfdggd
//  Created by HIPL-GLOBYLOG on 7/25/19.
//  Copyright © 2019 learning. All rights reserved.
import UIKit
import Alamofire

class ListViewForAllVC: UIViewController {
    
@IBOutlet weak var tblView: UITableView!
    weak var delegateUpdate:updateProfileListData!
    var dataSetId: String?
    @IBOutlet weak var footrView: UIView!
    var obj_lookUpType: ProfileLookupType?
    var attributArray: [AttributeForm]!
    var attributArrayClone: [AttributeFormClone]!
   // var imageDatArr = [Data]()
    var imageDatArr = [(Data , String)]()
//    ("Gabriel", "Kirkpatrick")
    @IBOutlet weak var lblTitle: UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  attributArrayClone = attributArray.copy()
 
        self.perform(#selector(setData), with: nil)
    }
    @objc func setData(){
        
        
        if dataSetId == nil {
            attributArray = [AttributeForm]()
            for item in self.attributArrayClone {
                let objClone = AttributeForm()
                objClone.LOOKUP_TYPE_ID = item.LOOKUP_TYPE_ID
                objClone.PROFILE_ATTRIBUTE_ID = item.PROFILE_ATTRIBUTE_ID
                
                objClone.HR_PROFILE_ATTRIBUTE_ID = item.HR_PROFILE_ATTRIBUTE_ID
                objClone.PROFILE_ATTRIBUTE_DESCRIPTION = item.PROFILE_ATTRIBUTE_DESCRIPTION
                objClone.PROFILE_ATTRIBUTE_TYPE = item.PROFILE_ATTRIBUTE_TYPE
                objClone.PROFILE_ATTRIBUTE_SIZE = item.PROFILE_ATTRIBUTE_TYPE
                objClone.PROFILE_ATTRIBUTE_DEFAULT_VALUE = ""
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
                attributArray.append(objClone)
            }
        }
        else {
            for item in self.attributArray {
            }
        }
        
        
        if let obj = obj_lookUpType {
            self.lblTitle.text = obj.LOOKUP_TYPE ?? ""
        }
        let podBundle = Bundle(for: ListViewForAllVC.self)
        self.tblView.tableFooterView = footrView
        tblView.register(UINib(nibName: "TextFieldCell", bundle: podBundle), forCellReuseIdentifier: "TextFieldCell")
        
        tblView.register(UINib(nibName: "DateTextFieldCell", bundle: podBundle), forCellReuseIdentifier: "DateTextFieldCell")
        
        tblView.register(UINib(nibName: "DatePeriodTextFCell", bundle: podBundle), forCellReuseIdentifier: "DatePeriodTextFCell")
        tblView.register(UINib(nibName: "DropDownCell", bundle: podBundle), forCellReuseIdentifier: "DropDownCell")
        
        let podBundleAddress = Bundle(for: AddressGeoCell.self)
        tblView.register(UINib(nibName: "AddressGeoCell", bundle: podBundleAddress), forCellReuseIdentifier: "AddressGeoCell")
        
        
         tblView.register(UINib(nibName: "DocumentAttachCell", bundle: podBundleAddress), forCellReuseIdentifier: "DocumentAttachCell")
        
        if attributArray.count < 1 {
            tblView.isHidden = true
        }
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
    @IBAction func backClicked() {
       self.dismiss(animated: true, completion: nil)
    
    }
    @IBAction func SaveClicked() {
        self.view.endEditing(true)
        if isValidate() == true {
            if let obj = obj_lookUpType {
                var params:Parameters = [String:String]()
                var array = [Parameters]()
                var lookId  = ""
                for item in self.attributArray {
                    if lookId.isEmpty {
                    lookId = item.LOOKUP_TYPE_ID ?? ""
                    }
                    params["PROFILE_ATTRIBUTE_ID"] = item.PROFILE_ATTRIBUTE_ID ?? ""
                    params["PROFILE_ATTRIBUTE_TYPE"] = item.PROFILE_ATTRIBUTE_TYPE ?? ""
                    if item.PROFILE_ATTRIBUTE_TYPE != nil && item.PROFILE_ATTRIBUTE_TYPE! == "F" {
                        if item.imageData != nil && item.imageData!.count > 0{
                         
                            for img in item.imageData! {
                            imageDatArr.append((img, item.PROFILE_ATTRIBUTE_ID ?? ""))
                            }
                          
                        }
                        
                    }
                    
                    if item.LOOKUP_ID != nil && item.PROFILE_ATTRIBUTE_TYPE! == "L" {
                        
                         params["PROFILE_ATTRIBUTE_DEFAULT_VALUE"] = item.LOOKUP_ID!
                    }
                    else {
                    params["PROFILE_ATTRIBUTE_DEFAULT_VALUE"] = item.PROFILE_ATTRIBUTE_DEFAULT_VALUE ?? ""
                    }
                
                    params["PROFILE_ATTRIBUTE_SEQUENCE"] = item.PROFILE_ATTRIBUTE_SEQUENCE ?? ""
                    params["PROFILE_ATT_LOOKUP_FILTER_ID"] = item.PROFILE_ATT_LOOKUP_FILTER_ID ?? ""
                    params["PROFILE_ATTRIBUTE_GEO_LEVEL"] = item.PROFILE_ATTRIBUTE_GEO_LEVEL ?? ""
                     params["HR_PROFILE_ATTRIBUTE_ID"] = item.HR_PROFILE_ATTRIBUTE_ID ?? ""
                    array.append(params)
                    
                }
                 var params2:Parameters = [String:Any]()
                var paramsimg:Parameters = [String:Any]()
                paramsimg["ATTRIBUTES"] = array
                params2["ATTRIBUTES"] = paramsimg
                //params2["ATTRIBUTES"] = array
                params2["LOOKUP_TYPE_ID"] = lookId
                params2["DATASET_ID"] = dataSetId ?? ""
                let postParamHeaders = [String: String]()
                
                if imageDatArr.count > 0 {
                    
            ServerCommunication.postPictureAuthorizationHandler(url: "profileImageDataAddUpdate", postParam: params2, imageArr: imageDatArr, viewController: self, success: { (successResponseData) in
                        if successResponseData.data != nil {
                            if let json = successResponseData.result.value as? NSDictionary {
                                if let succ = json["success"] as? Bool {
                                    
                                    if succ == true {
                                        
                                        var setId = ""
                                        if let data = json["data"] as? NSDictionary {
                                            if  let sid = data["DATASET_ID"] as? String {
                                            setId = sid
                                        }
                                        }
                                        
                                        
                                        if succ == true {
                                            if let set_id = self.dataSetId {
                                                setId = set_id
                                                self.delegateUpdate.updateListData(attributArray: self.attributArray ,listId: setId,isUpdate: true)
                                            }
                                            else {
                                                self.delegateUpdate.updateListData(attributArray: self.attributArray ,listId: setId,isUpdate: false)
                                                
                                            }
                                          //  self.dismiss(animated: true, completion: nil)
                                            
                                            
                                            
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
                        
                    }, failure: { (successResponseDataerr) in
                        
                    })
                    return
                }
 
                
        ServerCommunication.getDataWithGetWithDataResponse(url: "profileDataAddUpdate", parameter: params2, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success: { (successResponseData) in
                if successResponseData.data != nil {
                        if let json = successResponseData.result.value as? NSDictionary {
            if let succ = json["success"] as? Bool {
                
                if succ == true {
                
                                var setId = ""
                                if let data = json["data"] as? NSDictionary {
                                    setId = data["DATASET_ID"] as! String
                                }
                                
                                    
                                    
                if succ == true {
                    if let set_id = self.dataSetId {
                        setId = set_id
             self.delegateUpdate.updateListData(attributArray: self.attributArray ,listId: setId,isUpdate: true)
                    }
                    else {
             self.delegateUpdate.updateListData(attributArray: self.attributArray ,listId: setId,isUpdate: false)
                        
                    }
                self.dismiss(animated: true, completion: nil)
                
                                
    
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
    func getData(){
       
        
        if let obj = obj_lookUpType {
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
                            // types.remove(at: 0)
                        self.attributArray = types
                            for data in self.attributArray {
                                if data.PROFILE_ATTRIBUTE_TYPE! == "F" {
                                data.cellHeight = 85.0
                                }
                                else {
                                   data.cellHeight = 80.0
                                }
                                
                            }
                            self.tblView.reloadData()
                            
                        }
                        /*
                        if let userInfo = serviceResponse.data?.USER_INFO {
                            basicInfoG = userInfo
                            self.headerViewP.basicInfo = userInfo
                            self.headerViewP.setValues(userData: userInfo)
                            
                        }
                        */
                        
                        
                        
                        
                    }
                    else {
                        
                        
                        if let dictFailure = successResponseData.result.value as? [String: AnyObject]{
                            
                            if let msg = dictFailure["message"] as? String
                            {
                                
                                DataUtil.alertMessage(msg , viewController: self)
                            }
                        }
                    }
                    // self.crytoResponse = serviceResponse
                    // cryptoResponseG = serviceResponse
                    
                    
                    
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
}
extension ListViewForAllVC: UITableViewDataSource, UITableViewDelegate,BaseTextViewDelegate,BaseDateViewDelegate,BasePeriodDateDelegate,BaseDropDownDelegate, BaseAddressDelegate,BaseDocPickerDelegate{
    func removeDocPickerImage(view: BaseDocumentPickerView, index: Int) {
        if index == 0 {
           // let obj = attributArray[view.tag]
           // obj.cellHeight = 150.0
            
        }
    }
    func UpdateDocPickerImage(view: BaseDocumentPickerView, index: Int, image: [UIImage]) {
        
        let obj = attributArray[view.tag]
        obj.imageData = [Data]()
        if image.count < 1 {
            obj.cellHeight = 85.0
        }
        else {
         obj.cellHeight = 150.0
        }
        for img in image {
            obj.imageData?.append(img.jpegData(compressionQuality: 0.75)!)
           // imageDatArr.append((img.jpegData(compressionQuality: 0.75)!, obj.PROFILE_ATTRIBUTE_ID ?? ""))
        }
      //  imageDatArr = obj.imageData!
         obj.PROFILE_ATTRIBUTE_DEFAULT_VALUE = view.document_nameTF.text
        self.tblView.reloadData()
    }
    func UpdateAddressText(view: BaseAddressView, index: Int, text: String) {
            print("selected dropdown == \(view.tag)value and value",text)
        
        let obj = attributArray[view.tag]
        obj.PROFILE_ATTRIBUTE_DEFAULT_VALUE = text
        
    }
    
    func UpdateDropDownText(view: BaseDropDownView,index:Int, text: String) {
         print("selected dropdown == \(view.tag)value and value",text)
        let obj = attributArray[view.tag]
        if let obj_additional = obj.ADDITIONAL_ATTRIBUTES?[index] {
            obj.PROFILE_ATTRIBUTE_DEFAULT_VALUE = text
            obj.LOOKUP_ID =  obj_additional.LOOKUP_ID
             print("selected LOOKUP_ID == \(obj_additional.LOOKUP_ID)")
        }
        //print("selected dropdown ==",text)
    }
    
    func UpdatePeriodDateText(view: PeriodDatesView, text: String, IndexDate: Int) {
        print("selected Date ==",text)
    }
    
    func UpdateDateBaseText(view: BaseTextViewWithDate, text: String) {
        
        var obj = attributArray[view.tag]
        obj.PROFILE_ATTRIBUTE_DEFAULT_VALUE = text
        print("selected Date ==",text)
    }

    
    func UpdateBaseText(view: BaseTextView, text: String) {
        var obj = attributArray[view.tag]
        obj.PROFILE_ATTRIBUTE_DEFAULT_VALUE = text
        print("text for tag == \(view.tag)alue and value",text)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributArray.count
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 140
    //    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let obj = attributArray[indexPath.row]
        print("obj.PROFILE_ATTRIBUTE_TYPE ==",obj.PROFILE_ATTRIBUTE_TYPE!)
        if obj.PROFILE_ATTRIBUTE_TYPE! == "A" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.BaseTFView.Delegate = self
            cell.BaseTFView.tag = indexPath.row
            cell.BaseTFView.title_lbl.text = obj.PROFILE_ATTRIBUTE_DESCRIPTION!
            if let txt = obj.PROFILE_ATTRIBUTE_DEFAULT_VALUE {
            cell.BaseTFView.generic_textField.text = txt
            }
            else {
                cell.BaseTFView.generic_textField.text = ""
            }
            return cell
             }
        if obj.PROFILE_ATTRIBUTE_TYPE! == "N" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.BaseTFView.Delegate = self
            cell.BaseTFView.tag = indexPath.row
            cell.BaseTFView.title_lbl.text = obj.PROFILE_ATTRIBUTE_DESCRIPTION!
            
            if let txt = obj.PROFILE_ATTRIBUTE_DEFAULT_VALUE {
                cell.BaseTFView.generic_textField.text = txt
            }
            else {
                cell.BaseTFView.generic_textField.text = ""
            }
            cell.BaseTFView.generic_textField.keyboardType = .phonePad
            return cell
        }
            
        else if obj.PROFILE_ATTRIBUTE_TYPE! == "G" {
            var geoLabel  = "0"
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressGeoCell") as! AddressGeoCell
            cell.addressView.Delegate = self
            cell.addressView.tag = indexPath.row
            cell.addressView.title_lbl.text = obj.PROFILE_ATTRIBUTE_DESCRIPTION!
            cell.addressView.dropDownLbl.text = obj.PROFILE_ATTRIBUTE_DEFAULT_VALUE ?? ""
            if let geoValue = obj.PROFILE_ATTRIBUTE_GEO_LEVEL {
                geoLabel = geoValue
            }
            if let geoValue = obj.PROFILE_ATTRIBUTE_GEO_LEVEL {
                geoLabel = geoValue
            }
           cell.addressView.setAddressGeoLavel(PROFILE_ATTRIBUTE_GEO_LEVEL: geoLabel, viewController: self)
            //cell.setAddressInfoData(self.addressListDataArr[indexPath.row])
            return cell
        }
        else if obj.PROFILE_ATTRIBUTE_TYPE! == "L"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell") as! DropDownCell
            cell.dropDownBView.Delegate = self
            cell.dropDownBView.tag = indexPath.row
            
            cell.dropDownBView.title_lbl.text = obj.PROFILE_ATTRIBUTE_DESCRIPTION!
            if let addiList = obj.ADDITIONAL_ATTRIBUTES {
                var nameArray = [String]()
                for item in addiList {
                    nameArray.append(item.LOOKUP_MEANING!)
                }
                // let nameArray = ["Milan", "Ajendra", "Farmood","Satish","Ranjeet","MFD"]
                cell.dropDownBView.setArrayForDropDown(listArray: nameArray)
                
                cell.dropDownBView.dropDownLbl.text = obj.PROFILE_ATTRIBUTE_DEFAULT_VALUE ?? ""
                
            }
            return cell
        }
        else if obj.PROFILE_ATTRIBUTE_TYPE! == "D"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateTextFieldCell") as! DateTextFieldCell
            cell.View_date.Delegate = self
            cell.View_date.tag = indexPath.row
            cell.View_date.title_lbl.text = obj.PROFILE_ATTRIBUTE_DESCRIPTION!
            if let txt = obj.PROFILE_ATTRIBUTE_DEFAULT_VALUE {
                cell.View_date.generic_textField.text = txt
            }
            else {
                cell.View_date.generic_textField.text = ""
            }
            cell.View_date.updateVC(vc: self)
            return cell
        }
        else if obj.PROFILE_ATTRIBUTE_TYPE! == "L"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell") as! DropDownCell
            cell.dropDownBView.Delegate = self
            cell.dropDownBView.tag = indexPath.row
            
            cell.dropDownBView.title_lbl.text = obj.PROFILE_ATTRIBUTE_DESCRIPTION!
            if let addiList = obj.ADDITIONAL_ATTRIBUTES {
                var nameArray = [String]()
                for item in addiList {
                    nameArray.append(item.LOOKUP_MEANING!)
                }
        cell.dropDownBView.setArrayForDropDown(listArray: nameArray)
                
        cell.dropDownBView.dropDownLbl.text = obj.PROFILE_ATTRIBUTE_DEFAULT_VALUE ?? ""
                
            }
            return cell
        }
        else if obj.PROFILE_ATTRIBUTE_TYPE! == "F"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentAttachCell") as! DocumentAttachCell
            cell.doc_view.setController(vc: self)
            cell.doc_view.Delegate = self
            cell.doc_view.tag = indexPath.row
            
            cell.doc_view.title_lbl.text = obj.PROFILE_ATTRIBUTE_DESCRIPTION!
            if let addiList = obj.ADDITIONAL_ATTRIBUTES {
                var nameArray = [String]()
                for item in addiList {
                    nameArray.append(item.LOOKUP_MEANING!)
                }
   
                
               // cell.doc_view.dropDownLbl.text = obj.PROFILE_ATTRIBUTE_DEFAULT_VALUE ?? ""
                
            }
            return cell
        }
  
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
        cell.BaseTFView.Delegate = self
        cell.BaseTFView.tag = indexPath.row
        cell.BaseTFView.title_lbl.text = obj.PROFILE_ATTRIBUTE_DESCRIPTION!
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let obj = attributArray[indexPath.row]
        return obj.cellHeight ?? 80.00
    }

}



