//
//  AddDelegateVC.swift
//  Alamofire
//
//  Created by HIPL-GLOBYLOG on 9/24/19.
// [(Data , String)]

protocol UpdateVacationDelegation: class{
    func updatevacationRule(isUpdate:Bool)
}

import UIKit
import Alamofire

class AddDelegateVC: BaseProfileVC {
      @IBOutlet weak var lblTitle: UILabel!
     var titleStr:String?
    var params:Parameters = [String:String]()
    var delegateTitleArray = [(String,String)]()
    var addDelegateModelObj:AddDelegateDataModel?
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
        if addDelegateModelObj == nil {
            addDelegateModelObj = AddDelegateDataModel()
        }
        delegateTitleArray.append(("With Effect From:", addDelegateModelObj?.wefDateStr ?? ""))
        delegateTitleArray.append(("Travel Request:" ,addDelegateModelObj?.travelRequestStr ?? ""))
        if allowCashAdvance_profile == "Y" {
            delegateTitleArray.append(("Cash Advance:",addDelegateModelObj?.cashAdvanceStr ?? ""))
        }
        if ALLOW_EXPENSES_profile == "Y" {
            delegateTitleArray.append(("Expense Request:",addDelegateModelObj?.expenseStr ?? ""))
        }
        if ALLOW_NT_EXPENSES_profile == "Y" {
            delegateTitleArray.append(("Non Travel Expense:" ,addDelegateModelObj?.ntExpenseStr ?? ""))
        }
       
    }
    
    @IBAction func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SaveClicked() {
        if self.validation() == true{
            self.view.endEditing(true)
            let postParamHeaders = [String: String]()
            
            if let id = addDelegateModelObj?.wefDateStr {
                params["WEF_DATE"] = id
            }
            if let id = addDelegateModelObj?.travelRequestID {
                 params["DELEGATE_REQ_USER_ID"] = id
            }
            if let id = addDelegateModelObj?.expenseID {
                params["DELEGATE_EXP_USER_ID"] = id
            }
            if let id = addDelegateModelObj?.cashAdvanceStrID {
                params["DELEGATE_CASH_USER_ID"] = id
            }
            if let id = addDelegateModelObj?.ntExpenseID {
                params["DELEGATE_NTEXP_USER_ID"] = id
            }
            if let id = addDelegateModelObj?.USER_DELEGATE_ID {
                params["USER_DELEGATE_ID"] = id
            }
 ServerCommunication.getDataWithGetWithDataResponse(url: "saveDelegateUser", parameter: params, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success:{ (successResponseData) in
                if successResponseData.data != nil {
                    if let json = successResponseData.result.value as? NSDictionary {
                        if let dic = json["data"] as? NSDictionary {
                            if let vId = dic.value(forKey: "DELEGATE_ID") as? String {
                                if vId.contains("ALREADY") {
                                DataUtil.alertMessage("Delegation rule for define dates already exist!!", viewController: self)
                                    
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
                        else {
                            self.updateDelegate.updatevacationRule(isUpdate: true)
                            self.dismiss(animated: true, completion: nil)
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
        if (self.addDelegateModelObj?.wefDateStr == nil || (self.addDelegateModelObj?.wefDateStr!.count)! < 1){
            DataUtil.alertMessage("Please select effect date", viewController: self)
            return false
        }
        if self.addDelegateModelObj?.travelRequestStr == nil && self.addDelegateModelObj?.cashAdvanceStr == nil && self.addDelegateModelObj?.expenseStr == nil && self.addDelegateModelObj?.ntExpenseStr == nil {
            
            DataUtil.alertMessage("Please select one option", viewController: self)
            return false
        }

        
        return true
    }
}

extension AddDelegateVC : UITableViewDataSource, UITableViewDelegate, BaseDateViewDelegate, BaseDropDownDelegate {
    func UpdateDateBaseText(view: BaseTextViewWithDate, text: String, select_date: Date) {
        self.view.endEditing(true)
            self.addDelegateModelObj?.wefDate = select_date
            self.addDelegateModelObj?.wefDateStr = text
        delegateTitleArray[view.tag].1 = text
    }
    
    func UpdateDropDownText(view: BaseDropDownView, index: Int, text: String, title: String){
        self.view.endEditing(true)
        let obj = userData![index]
        if title == "Travel Request:" {
            self.addDelegateModelObj?.travelRequestStr = text
             self.addDelegateModelObj?.travelRequestID = obj.USER_ID ?? ""
        }
        else if title == "Cash Advance:" {
            self.addDelegateModelObj?.cashAdvanceStr = text
            self.addDelegateModelObj?.cashAdvanceStrID = obj.USER_ID ?? ""
        }
        else if title == "Expense Request:" {
            self.addDelegateModelObj?.expenseStr = text
            self.addDelegateModelObj?.expenseID = obj.USER_ID ?? ""
        }
        else if title == "Non Travel Expense:" {
            self.addDelegateModelObj?.ntExpenseStr = text
            self.addDelegateModelObj?.ntExpenseID = obj.USER_ID ?? ""
        }
        delegateTitleArray[view.tag].1 = text
        
        print("delegateTitleArray == ",delegateTitleArray)
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.00
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegateTitleArray.count//attributArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let obj = userData![indexPath.row]
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateTextFieldCell") as! DateTextFieldCell
            cell.View_date.Delegate = self
            cell.View_date.tag = indexPath.row
            cell.View_date.requestDate_start = Date()
            cell.View_date.title_lbl.text = delegateTitleArray[indexPath.row].0
            cell.View_date.generic_textField.text = delegateTitleArray[indexPath.row].1
            cell.View_date.updateVC(vc: self)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell") as! DropDownCell
            cell.dropDownBView.Delegate = self
            cell.dropDownBView.tag = indexPath.row
            cell.dropDownBView.title_lbl.text = delegateTitleArray[indexPath.row].0
            cell.dropDownBView.dropDownLbl.text = delegateTitleArray[indexPath.row].1
            if let addiList = self.userData {
                var nameArray = [String]()
                for item in addiList {
                    nameArray.append(item.DISPLAY_NAME!)
                }
        cell.dropDownBView.setArrayForDropDown(listArray: nameArray)
              //  cell.dropDownBView.dropDownLbl.text = userData![0].DISPLAY_NAME
            }
            return cell
        }
        
    }
}

