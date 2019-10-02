//
//  DelegateListVC.swift
//  Profile
//
//  Created by HIPL-GLOBYLOG on 7/24/19.
//  Copyright © 2019 learning. All rights reserved.
//

import UIKit
import Alamofire

class DelegateListVC: BaseProfileVC {
     var titleStr:String?
    @IBOutlet weak var tblView: UITableView!
     var buttonRightItem: UIBarButtonItem!
    var listDataArr = [DelegateList]()
       var delegateObj = DelegateData(success: false, data: HistoryDataDeleg(HISTORY: [], USER: [], DETAILS: []))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleStr ?? "Delegate"
        headerViewP.setBasicHeight(height: 0)
        basicViewHeight.constant = 185
        headerViewP.plusBtb.isSelected = true
        tblView.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: "AddressCell")
        self.tblView.rowHeight = UITableView.automaticDimension;
        self.tblView.estimatedRowHeight = 200;
        self.getData()
        let podBundle = Bundle(for: VacationListVC.self)
        let image = UIImage(named: "acount_plus_icon")?.withRenderingMode(.alwaysOriginal)
        buttonRightItem = UIBarButtonItem(image:image, style: .plain, target: self, action: #selector(addNewClicked))
        self.navigationItem.rightBarButtonItem  = buttonRightItem
        let imageback = UIImage(named: "acount_back_arrow")
        let button1 = UIBarButtonItem(image:imageback, style: .plain, target: self, action: #selector(backBtnClicked))
        self.navigationItem.leftBarButtonItem  = button1
        
    }
    @objc func backBtnClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func addNewClicked() {
        let podBundle = Bundle(for: VacationListVC.self)
        let story = UIStoryboard(name: "Main", bundle: podBundle)
        let obj = story.instantiateViewController(withIdentifier: "AddDelegateVC") as! AddDelegateVC
        obj.titleStr = self.titleStr
         obj.updateDelegate = self
        if self.delegateObj.data?.USER != nil
        {
            obj.userData = self.delegateObj.data?.USER
        }
        
        self.present(obj, animated: true, completion: nil)
    }
    
    func getData() {
        let params:Parameters =  ["REQUEST_FOR":""]
        let postParamHeaders = [String: String]()
        ServerCommunication.getDataWithGetWithDataResponse(url: "getDeligateData", parameter: params, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success: { (successResponseData) in
            if let cryptoData = successResponseData.data {
                do {
                    let decoder = JSONDecoder()
                    
                    let serviceResponse = try decoder.decode(DelegateData.self, from: cryptoData)
                    self.delegateObj = serviceResponse
                    if serviceResponse.success == true {
                        if let arr = serviceResponse.data?.HISTORY {
                            self.listDataArr = arr
                        }
                        
                        print("self.licenseListDataArr ==",self.listDataArr)
                        if self.listDataArr.count < 1 {
                            self.noDataFoundView.isHidden = false
                        }
                        else {
                            self.noDataFoundView.isHidden = true
                        }
                        self.tblView.reloadData()
                        
                    }
                    else {
                        
                        
                        if let dictFailure = successResponseData.result.value as? [String: AnyObject]{
                            
                            if let msg = dictFailure["message"] as? String
                            {
                                
                                DataUtil.alertMessage(msg , viewController: self)
                            }
                        }
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
extension DelegateListVC: UITableViewDataSource, UITableViewDelegate,UpdateVacationDelegation {
    func updatevacationRule(isUpdate: Bool) {
        if isUpdate == true {
            self.getData()
        }
    }
    @objc func openOptionsforCell(btn: UIButton) {
        let Info = self.listDataArr[btn.tag]
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title:"Edit", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            let podBundle = Bundle(for: VacationListVC.self)
            let story = UIStoryboard(name: "Main", bundle: podBundle)
            let obj = story.instantiateViewController(withIdentifier: "AddDelegateVC") as! AddDelegateVC
            obj.titleStr = self.titleStr
             obj.updateDelegate = self
            if self.delegateObj.data?.USER != nil
            {
                obj.userData = self.delegateObj.data?.USER
            }
            let addVactionModelObj = AddDelegateDataModel()
            if let text = Info.REQ_USER_ID {
                addVactionModelObj.travelRequestID = text
            }
            if let text = Info.DELEGATE_REQ_USER_ID {
                addVactionModelObj.travelRequestStr = text
            }
            
            if let text = Info.EXP_USER_ID {
                addVactionModelObj.expenseID = text
            }
            if let text = Info.DELEGATE_EXP_USER_ID {
                addVactionModelObj.expenseStr = text
            }
            if let text = Info.NTEXP_USER_ID {
                addVactionModelObj.ntExpenseID = text
            }
            if let text = Info.DELEGATE_NTEXP_USER_ID {
                addVactionModelObj.ntExpenseStr = text
            }
            if let text = Info.CASH_USER_ID {
                addVactionModelObj.cashAdvanceStrID = text
            }
            if let text = Info.DELEGATE_CASH_USER_ID {
                addVactionModelObj.cashAdvanceStr = text
            }
            
            if let date = Info.WEF_DATE {
                addVactionModelObj.wefDateStr = DateUtil.convertDate(stringDate: date, stringDateFormat: DateUtil.TA_DATE_FORMAT, reqDateFormat: DateUtil.AMADEUS_DATE)
                let convertedDate = DateUtil.convertStringToDate(date, reqDateFormat: DateUtil.TA_DATE_FORMAT)
                 addVactionModelObj.wefDate = convertedDate
            }
   
            if let id = Info.USER_DELEGATE_ID {
                addVactionModelObj.USER_DELEGATE_ID = id
            }
            
            obj.addDelegateModelObj = addVactionModelObj
            
            self.present(obj, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title:"Delete", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            if let recordId = Info.USER_DELEGATE_ID {
                
                self.removePassport(urlName:"deleteDelegateUser" ,type: "USER_DELEGATE_ID", recordId: recordId, success: { (str) in
                    
                    self.listDataArr.remove(at: btn.tag)
                    self.tblView.reloadData()
                    if self.listDataArr.count < 1 {
                        self.noDataFoundView.isHidden = false
                    }
                    else {
                        self.noDataFoundView.isHidden = true
                    }
                    
                })
                
                //self.removePassport(type: "PASSPORT", recordId: recordId)
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listDataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DelegateCell") as! DelegateCell
        cell.setInfoData(self.listDataArr[indexPath.row])
        cell.btnthreeDots.tag = indexPath.row
        cell.btnthreeDots.addTarget(self, action: #selector(openOptionsforCell(btn:)), for: .touchUpInside)
        return cell
    }
    
    
}

class DelegateCell: UITableViewCell {
    @IBOutlet weak var btnthreeDots: UIButton!
    @IBOutlet weak var lblWEFDate: UILabel!
    @IBOutlet weak var lblReqUser: UILabel!
    @IBOutlet weak var lblExpUser: UILabel!
    @IBOutlet weak var lblNonTravelExpUser: UILabel!
    @IBOutlet weak var lblCashUser: UILabel!
    
    var InfoList:DelegateList?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "acount_threeDots")
        self.btnthreeDots.setImage(image, for: .selected)
        self.btnthreeDots.setImage(image, for: .normal)
        self.btnthreeDots.setImage(image, for: .highlighted)
        // Initialization code
    }
    func setInfoData(_ cellInfo: DelegateList) {
        self.InfoList = cellInfo
        if let Info =  self.InfoList {
            
            if let name = Info.DELEGATE_REQ_USER_ID {
                self.lblReqUser.text = name
            }
            if let name = Info.DELEGATE_EXP_USER_ID {
                self.lblExpUser.text = name
            }
            if let name = Info.DELEGATE_NTEXP_USER_ID {
                self.lblNonTravelExpUser.text = name
            }
            if let name = Info.DELEGATE_CASH_USER_ID {
                self.lblCashUser.text = name
            }
            
            if let date = Info.WEF_DATE {
                self.lblWEFDate.text = DateUtil.convertDate(stringDate: date, stringDateFormat: DateUtil.TA_DATE_FORMAT, reqDateFormat: DateUtil.UI_DATE_FORMAT)
            }
            if Info.WEF_DATE != nil {
                let dateEnd = DateUtil.convertStringToDate(Info.WEF_DATE! , reqDateFormat:DateUtil.TA_DATE_FORMAT)
                let currentdate = Date()
                if dateEnd.isSameDate(currentdate) == true || dateEnd.isAfterDate(currentdate) {
                    
                    self.btnthreeDots.isHidden = false
                }
                else {
                    self.btnthreeDots.isHidden = true
                }
            }
            
            
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}






