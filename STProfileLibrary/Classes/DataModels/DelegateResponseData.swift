//
//  DelegateResponseData.swift
//  Profile
//
//  Created by HIPL-GLOBYLOG on 7/24/19.
//  Copyright © 2019 learning. All rights reserved.
//

import UIKit

struct DelegateData:Decodable {
    let success: Bool?
    var data:HistoryDataDeleg?
}
struct HistoryDataDeleg:Decodable {
    var HISTORY : [DelegateList]?
    var USER : [UserList]?
    var DETAILS : [DetailListDeleg]?
}

struct DelegateList:Decodable {
    var USER_ID: String?
    var USER_DELEGATE_ID: String?
    var WEF_DATE: String?
    var DELEGATE_REQ_USER_ID: String?
    var REQ_USER_ID: String?
    var DELEGATE_EXP_USER_ID: String?
    var EXP_USER_ID: String?
    var DELEGATE_NTEXP_USER_ID: String?
    var NTEXP_USER_ID: String?
    var DELEGATE_CASH_USER_ID: String?
    var CASH_USER_ID: String?
}
struct DetailListDeleg:Decodable {
    var USER_ID : String?
    var USER_DELEGATE_ID : String?
    var WEF_DATE : String?
    var REQ_USER_ID : String?
    var REQ_USER_NAME : String?
    var EXP_USER_ID : String?
    var EXP_USER_NAME : String?
    
    var NTEXP_USER_ID : String?
    var NTEXP_USER_NAME : String?
    var CASH_USER_ID : String?
    var CASH_USER_NAME : String?
}

class AddDelegateDataModel:Decodable {
    var wefDate: Date?
    var wefDateStr: String?
    var travelRequestStr: String?
    var travelRequestID: String?
    
    var cashAdvanceStr: String?
    var cashAdvanceStrID: String?
    
    var expenseStr: String?
    var expenseID: String?
    
    var ntExpenseStr: String?
     var ntExpenseID: String?
    var USER_DELEGATE_ID: String?

    
    
}
