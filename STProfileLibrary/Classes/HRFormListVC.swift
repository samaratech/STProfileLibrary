//
//  HRFormListVC.swift
//  Alamofire
//
//  Created by HIPL-GLOBYLOG on 10/2/19.
//

import UIKit
import UIKit
import Alamofire

public class HRFormListVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var crossBtn:UIButton!
    weak var delegateUpdate:updateProfileListData!
    var dataSetId: String?
    @IBOutlet weak var footrView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    var obj_lookUpType: ProfileLookupType?
    var attributArray = [AttributeForm]()
    var attributArrayClone: [AttributeFormClone]!
    
    // var imageDatArr = [Data]()
    var imageDatArr = [(Data , String)]()
    var image_deleteArr = [String]()
    var cell_height:CGFloat = 166.0
    var hrDataArray = [HRForData]()
    var currentIndex = 0
    var lastIndex = 0
   
    //    ("Gabriel", "Kirkpatrick")
    @IBOutlet weak var lblTitle: UILabel!
    
    //.......
    public var baseUrl_home: String?
    public var LOCATION_ID_home: String?
    public var ORG_ID_home: String?
    public var SIGNIN_TYPE_home: String?
    public var TOKEN_home: String?
    public var allowCashAdvance_home: String?
    public var ALLOW_EXPENSES_home: String?
    public var ALLOW_NT_EXPENSES_home: String?
    public var googleKey: String?
    public var system_id = "T"
    public  var dashVC: UIViewController?
    
    //.......
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let image1 = UIImage(named: "acount_cross_error")
        self.crossBtn.setImage(image1, for: .selected)
        self.crossBtn.setImage(image1, for: .normal)
        self.crossBtn.setImage(image1, for: .highlighted)
        //      //  attributArrayClone = attributArray.copy()
        
        self.perform(#selector(setData), with: nil)
        self.getData()
    }
    @objc func setData(){
        if let baseUrl = baseUrl_home {
            baseUrl_profile = baseUrl
        }
        if let LOCATION_ID = LOCATION_ID_home {
            LOCATION_ID_profile = LOCATION_ID
        }
        if let ORG_ID_home = ORG_ID_home {
            ORG_ID_profile = ORG_ID_home
        }
        if let SIGNIN_TYPE = SIGNIN_TYPE_home {
            SIGNIN_TYPE_profile = SIGNIN_TYPE
        }
        if let TOKEN = TOKEN_home {
            TOKEN_profile = TOKEN
        }
        if let key = googleKey{
            GOOGLE_KEY = key
        }
        if let allowCashAdvance = allowCashAdvance_home {
            allowCashAdvance_profile = allowCashAdvance
        }
        if let ALLOW_EXPENSES = ALLOW_EXPENSES_home {
            ALLOW_EXPENSES_profile = ALLOW_EXPENSES
        }
        if let ALLOW_NT_EXPENSES = ALLOW_NT_EXPENSES_home {
            ALLOW_NT_EXPENSES_profile = ALLOW_NT_EXPENSES
        }
        //        if self.system_id != nil {
        //        SYSTEM_ID = self.system_id
        //        }
        
        self.submitBtn.setTitle("Save and Next", for: .normal)
        self.submitBtn.setTitle("SAVE", for: .selected)
        self.submitBtn.setTitle("SAVE", for: .highlighted)
        
        let podBundle = Bundle(for:   HRFormListVC.self)
        self.tblView.tableFooterView = footrView
        tblView.register(UINib(nibName: "TextFieldCell", bundle: podBundle), forCellReuseIdentifier: "TextFieldCell")
        
        tblView.register(UINib(nibName: "DateTextFieldCell", bundle: podBundle), forCellReuseIdentifier: "DateTextFieldCell")
        
        tblView.register(UINib(nibName: "DatePeriodTextFCell", bundle: podBundle), forCellReuseIdentifier: "DatePeriodTextFCell")
        tblView.register(UINib(nibName: "DropDownCell", bundle: podBundle), forCellReuseIdentifier: "DropDownCell")
        
        let podBundleAddress = Bundle(for: AddressGeoCell.self)
        tblView.register(UINib(nibName: "AddressGeoCell", bundle: podBundleAddress), forCellReuseIdentifier: "AddressGeoCell")
        
        
        tblView.register(UINib(nibName: "DocumentAttachCell", bundle: podBundleAddress), forCellReuseIdentifier: "DocumentAttachCell")
        
     
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
//        if let vc = self.dashVC { self.navigationController?.pushViewController(vc, animated: true)
//            return
//        }
        if isValidate() == true {
            
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
                if self.image_deleteArr.count > 0 {
                    let joined = self.image_deleteArr.joined(separator: ",")
                    params2["IMAGE_ID"] = joined
                }
                let postParamHeaders = [String: String]()
                
                ServerCommunication.postPictureAuthorizationHandler(url: "profileImageDataAddUpdate", postParam: params2, imageArr: imageDatArr, viewController: self, success: { (successResponseData) in
                    if successResponseData.data != nil {
                        if let json = successResponseData.result.value as? NSDictionary {
                            if let succ = json["success"] as? Bool {
                                
                                if succ == true{
                                    if self.hrDataArray.count > 0 && self.currentIndex < self.lastIndex{
                                        self.currentIndex = self.currentIndex + 1
                                        self.attributArray  = self.hrDataArray[self.currentIndex].ATTRIBUTES!
                                         self.title = self.hrDataArray[self.currentIndex].LOOKUP_NAME ?? ""
                                      
                                        self.tblView.reloadData()
                                    }
                                    else if self.currentIndex == self.lastIndex{
                                        if let vc = self.dashVC { self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                    }
                                }
                                else {
                                    
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
        
    }
    func getData(){
        self.currentIndex = 0
        self.lastIndex = 0
        
        let params:Parameters =  [:]
        
        let postParamHeaders = [String: String]()
        ServerCommunication.getDataWithGetWithDataResponse(url: "getUserOnboardingList", parameter: params, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success: { (successResponseData) in
            
            if let cryptoData = successResponseData.data {
                do {
                    let decoder = JSONDecoder()
                    let serviceResponse = try decoder.decode(HRForDataRes.self, from: cryptoData)
                    if serviceResponse.success == true {
                        if let data = serviceResponse.data {
                            self.hrDataArray = data
                            self.lastIndex = self.hrDataArray.count - 1
                            
                            if self.hrDataArray.count > 0 {
                                self.attributArray  = self.hrDataArray[0].ATTRIBUTES!
                               // self.lblTitle.text = self.hrDataArray[0].LOOKUP_NAME ?? ""
                                self.title = self.hrDataArray[0].LOOKUP_NAME ?? ""
                              //  self.currentIndex = self.currentIndex + 1
                                self.tblView.reloadData()
                            }
                            
                        }
                    }
                    else {
                        
                        DataUtil.alertMessage("No Data Found", viewController: self)
                        
                    }
                    
                } catch let jsonError {
                    print("jsonError ===",jsonError)
                }
                
                
                
            }
            
            
        }) { (dictFailure) in
            if let msg = dictFailure.value(forKey: "message"){
                
                DataUtil.alertMessage(msg as! String, viewController: self)
            }
        }
        
    }
    
    
    /*
     {
     
     
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
     */
}
extension HRFormListVC: UITableViewDataSource, UITableViewDelegate,BaseTextViewDelegate,BaseDateViewDelegate,BasePeriodDateDelegate,BaseDropDownDelegate, BaseAddressDelegate,BaseDocPickerDelegate{
    
    
    func RemoveDocPickerImage(view: BaseDocumentPickerView, index: Int, image: [Any], type: ImageValue) {
        let obj = attributArray[view.tag]
        image_deleteArr.append(type.HR_PROFILE_ATTRIBUTE_ID ?? "")
        if image.count < 1 {
            obj.cellHeight = nil
            obj.imageUrlStr?.removeAll()
        }
        else {
            obj.cellHeight = cell_height
        }
        
        if obj.imageUrlStr != nil &&  obj.imageUrlStr!.count >= index + 1 {
            
            
            obj.imageUrlStr?.remove(at: index)
            
        }
        
    }
    
    func UpdateDocPickerImage(view: BaseDocumentPickerView, index: Int, image: [Any]) {
        
        let obj = attributArray[view.tag]
        obj.imageData = [Data]()
        if image.count < 1 {
            obj.cellHeight = nil
            obj.imageUrlStr?.removeAll()
        }
        else {
            obj.cellHeight = cell_height
        }
        for img in image {
            if img is UIImage {
                obj.imageData?.append((img as! UIImage).jpegData(compressionQuality: 0.75)!)
            }
            
            
            
            // imageDatArr.append((img.jpegData(compressionQuality: 0.75)!, obj.PROFILE_ATTRIBUTE_ID ?? ""))
        }
        
        obj.PROFILE_ATTRIBUTE_DEFAULT_VALUE = view.document_nameTF.text
        //  obj.imageUrlStr?.append(view.document_nameTF.text!)
        
        self.tblView.reloadData()
    }
    func UpdateAddressText(view: BaseAddressView, index: Int, text: String) {
        print("selected dropdown == \(view.tag)value and value",text)
        
        let obj = attributArray[view.tag]
        obj.PROFILE_ATTRIBUTE_DEFAULT_VALUE = text
        
    }
    
    func UpdateDropDownText(view: BaseDropDownView, index: Int, text: String, title: String) {
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
    /*
     func UpdateDateBaseText(view: BaseTextViewWithDate, text: String) {
     
     
     }
     */
    func UpdateDateBaseText(view: BaseTextViewWithDate, text: String, select_date: Date) {
        var obj = attributArray[view.tag]
        obj.PROFILE_ATTRIBUTE_DEFAULT_VALUE = text
        print("selected Date ==",text)
    }
    
    
    func UpdateBaseText(view: BaseTextView, text: String) {
        var obj = attributArray[view.tag]
        obj.PROFILE_ATTRIBUTE_DEFAULT_VALUE = text
        print("text for tag == \(view.tag)alue and value",text)
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributArray.count
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 140
    //    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = attributArray[indexPath.row]
        print("obj.PROFILE_ATTRIBUTE_TYPE ==",obj.PROFILE_ATTRIBUTE_TYPE!)
        if obj.PROFILE_ATTRIBUTE_TYPE! == "A" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.BaseTFView.Delegate = self
            
            if (obj.PROFILE_ATTRIBUTE_REQUIRED != nil) && obj.PROFILE_ATTRIBUTE_REQUIRED! == "Y" {
                
                cell.BaseTFView.sView.backgroundColor = UIColor(red: 227.0/255.0, green: 254.0/255.0, blue: 233.0/255.0, alpha: 1)
            }
            else {
                cell.BaseTFView.sView.backgroundColor = .white
            }
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
            if (obj.PROFILE_ATTRIBUTE_REQUIRED != nil) && obj.PROFILE_ATTRIBUTE_REQUIRED! == "Y" {
                
                cell.BaseTFView.sView.backgroundColor = UIColor(red: 227.0/255.0, green: 254.0/255.0, blue: 233.0/255.0, alpha: 1)
            }
            else {
                cell.BaseTFView.sView.backgroundColor = .white
            }
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
            if (obj.PROFILE_ATTRIBUTE_REQUIRED != nil) && obj.PROFILE_ATTRIBUTE_REQUIRED! == "Y" {
                
                cell.addressView.sView.backgroundColor = UIColor(red: 227.0/255.0, green: 254.0/255.0, blue: 233.0/255.0, alpha: 1)
            }
            else {
                cell.addressView.sView.backgroundColor = .white
            }
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
            if (obj.PROFILE_ATTRIBUTE_REQUIRED != nil) && obj.PROFILE_ATTRIBUTE_REQUIRED! == "Y" {
                
                cell.dropDownBView.dropDownView.backgroundColor = UIColor(red: 227.0/255.0, green: 254.0/255.0, blue: 233.0/255.0, alpha: 1)
            }
            else {
                cell.dropDownBView.dropDownView.backgroundColor = .white
            }
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
            if (obj.PROFILE_ATTRIBUTE_REQUIRED != nil) && obj.PROFILE_ATTRIBUTE_REQUIRED! == "Y" {
                
                cell.View_date.sView.backgroundColor = UIColor(red: 227.0/255.0, green: 254.0/255.0, blue: 233.0/255.0, alpha: 1)
            }
            else {
                cell.View_date.sView.backgroundColor = .white
            }
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
            if (obj.PROFILE_ATTRIBUTE_REQUIRED != nil) && obj.PROFILE_ATTRIBUTE_REQUIRED! == "Y" {
                
                cell.dropDownBView.sView.backgroundColor = UIColor(red: 227.0/255.0, green: 254.0/255.0, blue: 233.0/255.0, alpha: 1)
            }
            else {
                cell.dropDownBView.sView.backgroundColor = .white
            }
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
            if (obj.PROFILE_ATTRIBUTE_REQUIRED != nil) && obj.PROFILE_ATTRIBUTE_REQUIRED! == "Y" {
                
                cell.doc_view.sView.backgroundColor = UIColor(red: 227.0/255.0, green: 254.0/255.0, blue: 233.0/255.0, alpha: 1)
            }
            else {
                cell.doc_view.sView.backgroundColor = .white
            }
            cell.doc_view.tag = indexPath.row
            
            cell.doc_view.title_lbl.text = obj.PROFILE_ATTRIBUTE_DESCRIPTION!
            if let addiList = obj.ADDITIONAL_ATTRIBUTES {
                var nameArray = [String]()
                for item in addiList {
                    nameArray.append(item.LOOKUP_MEANING!)
                }
                obj.cellHeight = nil
                cell.doc_view.imageArr = [Any]()
                if obj.imageUrlStr != nil && obj.imageUrlStr!.count > 0 {
                    for imgItem in obj.imageUrlStr! {
                        cell.doc_view.imageArr.append(imgItem)
                        
                    }
                    obj.cellHeight = cell_height
                }
                if obj.imageData != nil && obj.imageData!.count > 0 {
                    for imgItem in obj.imageData! {
                        if let image = UIImage.sd_image(with: imgItem) {
                            cell.doc_view.imageArr.append(image)
                        }
                        
                    }
                    obj.cellHeight = cell_height
                }
                
                
                // cell.doc_view.dropDownLbl.text = obj.PROFILE_ATTRIBUTE_DEFAULT_VALUE ?? ""
                
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
        cell.BaseTFView.Delegate = self
        cell.BaseTFView.tag = indexPath.row
        if (obj.PROFILE_ATTRIBUTE_REQUIRED != nil) && obj.PROFILE_ATTRIBUTE_REQUIRED! == "Y" {
            
            cell.BaseTFView.sView.backgroundColor = UIColor(red: 227.0/255.0, green: 254.0/255.0, blue: 233.0/255.0, alpha: 1)
        }
        else {
            cell.BaseTFView.sView.backgroundColor = .white
        }
        cell.BaseTFView.title_lbl.text = obj.PROFILE_ATTRIBUTE_DESCRIPTION!
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let obj = attributArray[indexPath.row]
        return obj.cellHeight ?? 80.00
    }
    
}




