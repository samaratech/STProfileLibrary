//
//  VacationResponseData.swift
//  Profile
//
//  Created by HIPL-GLOBYLOG on 7/25/19.
//  Copyright © 2019 learning. All rights reserved.
//

import UIKit

struct VacationData:Decodable {
    let success: Bool?
    var data:HistoryData?
}
struct HistoryData:Decodable {
    var HISTORY : [VacationList]?
    var USER : [UserList]?
    var DETAILS : [DetailList]?
}
struct VacationList:Decodable {
    var USER_ID: String?
    var USER_VAC_ID: String?
    var EMP_USER_ID: String?
    var EMP_NAME: String?
    var START_DATE: String?
    var END_DATE: String?
    var PURPOSE_COMMENT: String?
}

struct UserList:Decodable {
    var USER_ID : String?
    var FNAME : String?
    var MNAME : String?
    var LNAME : String?
    var DISPLAY_NAME : String?
    var inputText : String?
}

struct DetailList:Decodable {
    var USER_ID : String?
    var USER_VAC_ID : String?
    var EMP_USER_ID : String?
    var EMP_NAME : String?
    var START_DATE : String?
    var END_DATE : String?
    var PURPOSE_COMMENT : String?
}

class AddVacationDataModel:Decodable {
    var startDate: Date?
    var endDate: Date?
    var startDateStr: String?
    var endDateStr: String?
    var commentStr: String?
    var forwordedId: String?
    var forwordedStr: String?
    var USER_VAC_ID: String?
    
    
}
