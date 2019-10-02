//
//  VacationListVC.swift
//  Profile
//
//  Created by HIPL-GLOBYLOG on 7/25/19.
//  Copyright © 2019 learning. All rights reserved.

import UIKit

import Alamofire

class VacationListVC: BaseProfileVC {
     var titleStr:String?
    @IBOutlet weak var tblView: UITableView!
    var listDataArr = [VacationList]()
    var buttonRightItem: UIBarButtonItem!
    var vacationObj = VacationData(success: false, data: HistoryData(HISTORY: [], USER: [], DETAILS: []))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleStr ?? "Vacation"
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
        let obj = story.instantiateViewController(withIdentifier: "AddVacationVC") as! AddVacationVC
          obj.titleStr = self.titleStr
         obj.updateDelegate = self
        if self.vacationObj.data?.USER != nil
        {
            obj.userData = self.vacationObj.data?.USER
        }
        
        self.present(obj, animated: true, completion: nil)
    }
    
    func getData() {
        let params:Parameters =  ["REQUEST_FOR":"VACATION"]
        
        let postParamHeaders = [String: String]()
        
        ServerCommunication.getDataWithGetWithDataResponse(url: "getDeligateData", parameter: params, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success: { (successResponseData) in
            if let cryptoData = successResponseData.data {
                do {
                    let decoder = JSONDecoder()
                    let serviceResponse = try decoder.decode(VacationData.self, from: cryptoData)
                    if serviceResponse.success == true {
                        self.vacationObj = serviceResponse
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
extension VacationListVC: UITableViewDataSource, UITableViewDelegate,UpdateVacationDelegation {
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
            let obj = story.instantiateViewController(withIdentifier: "AddVacationVC") as! AddVacationVC
              obj.titleStr = self.titleStr
            obj.updateDelegate = self
            if self.vacationObj.data?.USER != nil
            {
                obj.userData = self.vacationObj.data?.USER
            }
            let addVactionModelObj = AddVacationDataModel()
           
                if let text = Info.PURPOSE_COMMENT {
                    addVactionModelObj.commentStr = text
                }
                if let name = Info.EMP_NAME {
                     addVactionModelObj.forwordedStr = name
                }
            if let name = Info.EMP_USER_ID {
                addVactionModelObj.forwordedId = name
            }
                if let date = Info.START_DATE {
                    addVactionModelObj.startDateStr = DateUtil.convertDate(stringDate: date, stringDateFormat: DateUtil.TA_DATE_FORMAT, reqDateFormat: DateUtil.AMADEUS_DATE)
                    
                     let convertedDate = DateUtil.convertStringToDate(date, reqDateFormat: DateUtil.TA_DATE_FORMAT)
                     addVactionModelObj.startDate = convertedDate
                }
                if let date = Info.END_DATE {
                    addVactionModelObj.endDateStr = DateUtil.convertDate(stringDate: date, stringDateFormat: DateUtil.TA_DATE_FORMAT, reqDateFormat: DateUtil.AMADEUS_DATE)
                    let convertedDate = DateUtil.convertStringToDate(date, reqDateFormat: DateUtil.TA_DATE_FORMAT)
                    addVactionModelObj.endDate = convertedDate
                }
            if let id = Info.USER_VAC_ID {
                addVactionModelObj.USER_VAC_ID = id
            }
            
            obj.addVactionModelObj = addVactionModelObj
            
            self.present(obj, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title:"Delete", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            if let recordId = Info.USER_VAC_ID {
                self.removePassport(urlName:"deleteVacationData",type: "USER_VAC_ID", recordId: recordId, success: { (str) in
                    self.listDataArr.remove(at: btn.tag)
                    self.tblView.reloadData()
                    if self.listDataArr.count < 1 {
                        self.noDataFoundView.isHidden = false
                    }
                    else {
                        self.noDataFoundView.isHidden = true
                    }
                })
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
        return 200
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listDataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VacationCell") as! VacationCell
        cell.setInfoData(self.listDataArr[indexPath.row])
        cell.btnthreeDots.tag = indexPath.row
        cell.btnthreeDots.addTarget(self, action: #selector(openOptionsforCell(btn:)), for: .touchUpInside)
        
        
        return cell
    }
}

class VacationCell: UITableViewCell {
    @IBOutlet weak var btnthreeDots: UIButton!
    @IBOutlet weak var lblVacationDesc: UILabel!
    @IBOutlet weak var lblPurpose: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblForwardedTo: UILabel!
    
    var InfoList:VacationList?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "acount_threeDots")
        self.btnthreeDots.setImage(image, for: .selected)
        self.btnthreeDots.setImage(image, for: .normal)
        self.btnthreeDots.setImage(image, for: .highlighted)
    }
    func setInfoData(_ cellInfo: VacationList) {
        self.InfoList = cellInfo
        if let Info =  self.InfoList {
            if let text = Info.PURPOSE_COMMENT {
                self.lblVacationDesc.text = text
            }
            if let name = Info.EMP_NAME {
                self.lblForwardedTo.text = name
            }
            if let date = Info.START_DATE {
                self.lblStartDate.text = DateUtil.convertDate(stringDate: date, stringDateFormat: DateUtil.TA_DATE_FORMAT, reqDateFormat: DateUtil.UI_DATE_FORMAT)
            }
            if let date = Info.END_DATE {
                self.lblEndDate.text = DateUtil.convertDate(stringDate: date, stringDateFormat: DateUtil.TA_DATE_FORMAT, reqDateFormat: DateUtil.UI_DATE_FORMAT)
            }
            
            if Info.END_DATE != nil {
            let dateEnd = DateUtil.convertStringToDate(Info.END_DATE! , reqDateFormat:DateUtil.TA_DATE_FORMAT)
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
    }
}







