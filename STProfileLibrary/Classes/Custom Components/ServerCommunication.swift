//
//  ServerCommunication.swift
//  Profile
//
//  Created by HIPL-GLOBYLOG on 7/23/19.
//  Copyright © 2019 learning. All rights reserved.
// https://stackoverflow.com/questions/29625133/convert-dictionary-to-json-in-swift

import UIKit
import Alamofire

class ServerCommunication: NSObject {
    
    
    class func getDataWithGetWithDataResponse(url: String,parameter postParam: Parameters,HeaderParams: [String: String],methodType:HTTPMethod,viewController: UIViewController,success: @escaping(DataResponse<Any>) -> Void,failure: @escaping (NSDictionary) -> Void){
        var param = postParam
        param["LOCATION_ID"] = LOCATION_ID_profile
        param["ORG_ID"] = ORG_ID_profile
        param["SIGNIN_TYPE"] = SIGNIN_TYPE_profile
        param["TOKEN"] = TOKEN_profile
        let urlFinal = baseUrl_profile + url
        print("urlFinal: \(urlFinal) ")
        print("Post Parameter: \(param) ")
//        print("Post HeaderParams: \(HeaderParams) ")
        DataUtil.ShowIndictorView(IndicatoreTitle: "")
        
        Alamofire.request(urlFinal, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            if let data = response.data{
               // print("******************Json Data Start************************************")
                if let strJson = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                    print(strJson)
                    
                    
                }
              //  print("******************Json Data End ************************************")
            }
            switch (response.result){
            case .success(_):
              //  print("******************success******************")
                guard let json = response.result.value as? NSDictionary else
                {
                  //  print("Error: \(String(describing: response.result.error))")
                    DataUtil.HideIndictorView()
                    DispatchQueue.main.async {
                        failure(response.result as Any as! NSDictionary )
                    }
                    return
                }
                
                if let httpStatusCode = response.response?.statusCode {
                    
                    if httpStatusCode ==  400 {
                        
                        // let dic = json
                       
                        
                        DataUtil.HideIndictorView()
                        return
                    }
                }
                
                
                //  print(json)
                DispatchQueue.main.async {
                    //  if response.value
                    
                    success(response)
                    
                }
                 DataUtil.HideIndictorView()
            case .failure(_):
                print("******************failure******************")
                DataUtil.alertMessage(response.result.error!.localizedDescription, viewController: viewController)
                print(response.result.error!.localizedDescription)
                
                var str_error_msg = response.result.error!.localizedDescription
                if (str_error_msg .contains("JSON could not be serialized")) {
                  //  str_error_msg = ConstantFiles.technical_issue
                }
                
                DispatchQueue.main.async {
                    if ((response.result.error) as NSError?)?.code == -1009{
                        DataUtil.alertMessage(str_error_msg, viewController: viewController)
                        DispatchQueue.main.async {
                            let dictFail = NSMutableDictionary()
                            dictFail.setValue(-1009, forKey: "errorCode")
                         //   print("dictFail ==",dictFail) ;
                            
                            failure(dictFail)
                        }
                        return
                    }
                    DataUtil.alertMessage(str_error_msg, viewController: viewController)
                    return
                }
                DataUtil.HideIndictorView()
            }
        }
    }
    class func postPictureAuthorizationHandler(url: String, postParam:Parameters,imageArr:[(Data , String)],viewController: UIViewController,success:@escaping(DataResponse<Any>) -> Void,failure:@escaping (NSDictionary)->() ) {
        DataUtil.ShowIndictorView(IndicatoreTitle: "")
        var params = postParam
        params["LOCATION_ID"] = LOCATION_ID_profile
        params["ORG_ID"] = ORG_ID_profile
        params["SIGNIN_TYPE"] = SIGNIN_TYPE_profile
        params["TOKEN"] = TOKEN_profile
        let urlFinal = baseUrl_profile + url
        print("urlFinal: \(urlFinal) ")
        print("Post Parameter: \(params) ")
        let modifiedURLString = baseUrl_profile + url
        if params is Dictionary<String, String> {
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var index = 0
            for imageData in imageArr {
                let aa = "PROFILE_ATTRIBUTE_DEFAULT_VALUE"
              let keyy =   "\(aa)[]"
                let file_name = imageData.1 + ".png"
                multipartFormData.append(imageData.0, withName: keyy, fileName: file_name, mimeType: "image/jpeg")
                index = index + 1
            }
            for (key, value) in params {
              //  print("value ==",value)
               //  print("key == ",key)
                if value is String{
                 //   print("value == ",value)
                    
                    let valueStr = value as! String
                     multipartFormData.append(valueStr.data(using: String.Encoding.utf8)!, withName: key)
                  
                    
                }
                else if value is [String: [[String: String]]]{
                    
                    let stringsData = NSMutableData()
                    let jsonData = try? JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions())
                    let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)
                    if let stringData = jsonString?.data(using: String.Encoding.utf8.rawValue) {
                        stringsData.append(stringData)
                    }
                    
                    multipartFormData.append(stringsData as Data, withName: key)
                }
            }
        }, to:modifiedURLString)
        {
            (result) in
            switch result
            {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                })
                
                upload.responseJSON
                    {
                        response in
                        
                        switch response.result{
                        case .success( let value) :
                           
                            success(response)
                            break
                            
                        case .failure( let error) :
                           DataUtil.HideIndictorView()
                            DispatchQueue.main.async {
                    print("response ==",response); DataUtil.alertMessage(response.result.error!.localizedDescription, viewController: viewController)
                                print(response.result.error!.localizedDescription)
                            }
                            break
                            
                        }
                        if let data = response.result.value{
                            print(response.result.value)
                            
                            success(response)
                             DataUtil.HideIndictorView()
                        }
                }
                break
                
                
            case .failure(let encodingError):
                
                DataUtil.HideIndictorView()
                
                if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                } else {
                    
                }
            }
            
        }
        
        
        
        
    }
    class func postProfilePictureHandler(url: String, postParam:Parameters,imgData:Data,viewController: UIViewController,success:@escaping(DataResponse<Any>) -> Void,failure:@escaping (NSDictionary)->() ) {
        DataUtil.ShowIndictorView(IndicatoreTitle: "")
        var params = postParam
        params["LOCATION_ID"] = LOCATION_ID_profile
        params["ORG_ID"] = ORG_ID_profile
        params["SIGNIN_TYPE"] = SIGNIN_TYPE_profile
        params["TOKEN"] = TOKEN_profile
        let urlFinal = baseUrl_profile + url
        print("urlFinal: \(urlFinal) ")
        print("Post Parameter: \(params) ")
        let modifiedURLString = baseUrl_profile + url
        if params is Dictionary<String, String> {
        }
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "PROFILE_IMAGE",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to:modifiedURLString)
        {
            (result) in
            switch result
            {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                })
                
                upload.responseJSON
                    {
                        response in
                        
                        switch response.result{
                        case .success( let value) :
                            
                            success(response)
                            break
                            
                        case .failure( let error) :
                            DataUtil.HideIndictorView()
                            DispatchQueue.main.async {
                                print("response ==",response); DataUtil.alertMessage(response.result.error!.localizedDescription, viewController: viewController)
                                print(response.result.error!.localizedDescription)
                            }
                            break
                            
                        }
                        if let data = response.result.value{
                            print(response.result.value)
                            
                            success(response)
                            DataUtil.HideIndictorView()
                        }
                }
                break
                
                
            case .failure(let encodingError):
                
                DataUtil.HideIndictorView()
                
                if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                } else {
                    
                }
            }
            
        }
        
        
        
        
    }
}
