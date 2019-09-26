//
//  AddVacationVC.swift
//  Alamofire
//  Created by iOSteam on 9/23/19.
//fdfdsfsd

import UIKit
import Alamofire

class AddVacationVC: BaseProfileVC {
      @IBOutlet weak var lblTitle: UILabel!
    var titleStr:String?
    var addVactionModelObj:AddVacationDataModel?
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var crossBtn:UIButton!
    @IBOutlet weak var footrView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    weak var updateDelegate:UpdateVacationDelegation!
    var userData : [UserList]?
    var detailsData : [DetailList]?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let txt = titleStr {
            self.lblTitle.text = txt
        }
        let image1 = UIImage(named: "acount_cross_error")
        self.crossBtn.setImage(image1, for: .selected)
        self.crossBtn.setImage(image1, for: .normal)
        self.crossBtn.setImage(image1, for: .highlighted)
        let podBundle = Bundle(for: AddVacationVC.self)
        self.tblView.tableFooterView = footrView
        tblView.register(UINib(nibName: "TextFieldCell", bundle: podBundle), forCellReuseIdentifier: "TextFieldCell")
        tblView.register(UINib(nibName: "DateTextFieldCell", bundle: podBundle), forCellReuseIdentifier: "DateTextFieldCell")
        tblView.register(UINib(nibName: "DatePeriodTextFCell", bundle: podBundle), forCellReuseIdentifier: "DatePeriodTextFCell")
        tblView.register(UINib(nibName: "DropDownCell", bundle: podBundle), forCellReuseIdentifier: "DropDownCell")
        if addVactionModelObj == nil {
            addVactionModelObj = AddVacationDataModel()
        }
    }
    
    @IBAction func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
       @IBAction func SaveClicked() {
        if self.validation() == true{
        self.view.endEditing(true)
         let postParamHeaders = [String: String]()
        var params:Parameters = [String:String]()
        params["START_DATE"] = self.addVactionModelObj?.startDateStr!
        params["END_DATE"] = self.addVactionModelObj?.endDateStr
        params["PURPOSE_COMMENT"] = self.addVactionModelObj?.commentStr
        params["FORWARD_USER_ID"] = self.addVactionModelObj?.forwordedId
            if let id = self.addVactionModelObj?.USER_VAC_ID {
                 params["USER_VAC_ID"] = id
            }
        ServerCommunication.getDataWithGetWithDataResponse(url: "saveVacationData", parameter: params, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success:{ (successResponseData) in
            if successResponseData.data != nil {
                if let json = successResponseData.result.value as? NSDictionary {
                    if let dic = json["data"] as? NSDictionary {
                        if let vId = dic.value(forKey: "VACATION_ID") as? String {
                            if vId.contains("ALREADY") {
                                DataUtil.alertMessage("Vacation rule for define dates already exist!!", viewController: self)
                              
                            }
                            else {
                                self.updateDelegate.updatevacationRule(isUpdate: true)
                                 self.dismiss(animated: true, completion: nil)
                               // DataUtil.alertMessage("Data saved successfully", viewController: self)
                            }
                        }
                        else {
                            self.updateDelegate.updatevacationRule(isUpdate: true)
                            self.dismiss(animated: true, completion: nil)
                        }
                       
                    }
                    
                }
            }
            else {
                
                
                
            }
            
        }, failure: { (successResponseDataerr) in
            
        })
    }
    }

    func validation() -> Bool {
        if self.addVactionModelObj?.startDateStr == nil || (self.addVactionModelObj?.startDateStr!.count)! < 1 {
            DataUtil.alertMessage("Please select from date", viewController: self)
            return false
        }
        if self.addVactionModelObj?.endDateStr == nil || (self.addVactionModelObj?.endDateStr!.count)! < 1 {
            DataUtil.alertMessage("Please select end date", viewController: self)
             return false
        }
if self.addVactionModelObj!.endDate!.isBeforeDate(self.addVactionModelObj!.startDate!){
            DataUtil.alertMessage("End date should be greater than start date", viewController: self)
            
            return false
        }
        if self.addVactionModelObj?.commentStr == nil || (self.addVactionModelObj?.commentStr!.count)! < 1 {
            DataUtil.alertMessage("Please enter comment", viewController: self)
             return false
        }
        if self.addVactionModelObj?.forwordedId == nil || (self.addVactionModelObj?.forwordedId!.count)! < 1 {
            DataUtil.alertMessage("Please select user", viewController: self)
             return false
        }
        
        return true
    }
}

extension AddVacationVC : UITableViewDataSource, UITableViewDelegate, BaseDateViewDelegate, BaseTextViewDelegate, BaseDropDownDelegate {
    
    func UpdateDateBaseText(view: BaseTextViewWithDate, text: String, select_date: Date) {
        self.view.endEditing(true)
        if view.tag == 0 {
            self.addVactionModelObj?.startDate = select_date
            self.addVactionModelObj?.startDateStr = text
        }
        else if view.tag == 1 {
             self.addVactionModelObj?.endDate = select_date
            self.addVactionModelObj?.endDateStr = text
        }
        
    }
    
    func UpdateDropDownText(view: BaseDropDownView, index: Int, text: String, title: String){
        self.view.endEditing(true)
        let obj = userData![index]
        if let id =  obj.USER_ID {
        self.addVactionModelObj?.forwordedId = id
        }
        self.addVactionModelObj?.forwordedStr = text
    }
    
    func UpdateBaseText(view: BaseTextView, text: String) {
        self.addVactionModelObj?.commentStr = text
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.00
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4//attributArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if (indexPath.row == 0) || (indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateTextFieldCell") as! DateTextFieldCell
            cell.View_date.Delegate = self
            cell.View_date.tag = indexPath.row
            cell.View_date.requestDate_start = Date()
            if indexPath.row == 0{
                cell.View_date.title_lbl.text = "From Date :"
                if let txt = self.addVactionModelObj?.startDateStr {
                cell.View_date.generic_textField.text = txt
                }
                else {
                    cell.View_date.generic_textField.text = ""
                }
            } else {
                cell.View_date.title_lbl.text = "To Date :"
                if let txt = self.addVactionModelObj?.endDateStr {
                    cell.View_date.generic_textField.text = txt
                }
                else {
                    cell.View_date.generic_textField.text = ""
                }
            }

            cell.View_date.updateVC(vc: self)
            return cell
         }
        
         else if (indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.BaseTFView.Delegate = self
            cell.BaseTFView.tag = indexPath.row
            cell.BaseTFView.title_lbl.text = "Comment"
            if let txt = self.addVactionModelObj?.commentStr {
                cell.BaseTFView.generic_textField.text = txt
            }
            else {
                cell.BaseTFView.generic_textField.text = ""
            }
            return cell
        }
        
         else if (indexPath.row == 3){
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell") as! DropDownCell
            cell.dropDownBView.Delegate = self
            cell.dropDownBView.tag = indexPath.row
            cell.dropDownBView.title_lbl.text = "Forward"
            if let txt = self.addVactionModelObj?.forwordedStr {
                cell.dropDownBView.dropDownLbl.text = txt
            }
            else {
                cell.dropDownBView.dropDownLbl.text = ""
            }
            if let addiList = self.userData {
                var nameArray = [String]()
                for item in addiList {
                    nameArray.append(item.DISPLAY_NAME!)
                }
                cell.dropDownBView.setArrayForDropDown(listArray: nameArray)
             //   cell.dropDownBView.dropDownLbl.text = userData![0].DISPLAY_NAME
            }
            return cell
         } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.BaseTFView.Delegate = self
            cell.BaseTFView.tag = indexPath.row
            cell.BaseTFView.title_lbl.text = "Comment"
            return cell
        }
        
        
    }
}
