//
//  BaseDropDownView.swift
//  Profile
//
//  Created by Milan Katiyar on 24/07/19.
//  Copyright © 2019 learning. All rights reserved.
//
protocol UpdateCountryList: class {
    func updateCountrySelection(countryname: String)
}

public enum PlaceTypeaddress: String {
    case all = ""
    case geocode
    case address
    case establishment
    case regions = "(regions)"
    case cities = "(cities)"
}

import Foundation
import UIKit
import CoreLocation
//import CountryPicker
import GooglePlacesSearchController
protocol BaseAddressDelegate: class {
    
    func UpdateAddressText(view: BaseAddressView,index: Int,text: String)
}

public class BaseAddressView : UIView {
    var geoLabel: PlaceType = .all
    var profileGeoLabel = "0"
    var VC: UIViewController!
     @IBOutlet weak var sView: UIView!
    weak var Delegate:BaseAddressDelegate!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var dropDownLbl: UILabel!
    @IBOutlet weak var title_lbl: UILabel!
     @IBOutlet weak var plusBtn : UIButton!
    let GoogleMapsAPIServerKey = GOOGLE_KEY
    lazy var placesSearchController: GooglePlacesSearchController = {
        let controller = GooglePlacesSearchController(delegate: self, apiKey: GoogleMapsAPIServerKey, placeType: .all, coordinate: kCLLocationCoordinate2DInvalid, radius: 34, strictBounds: true, searchBarPlaceholder: ""
            
        )
        return controller
    }()
    
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
        
    }
    
    func initializeView() {
        
        //  let controller = GooglePlacesSearchController(delegate: self(), apiKey: GoogleMapsAPIServerKey, placeType: <#T##PlaceType#>, coordinate: <#T##CLLocationCoordinate2D#>, radius: <#T##CLLocationDistance#>, strictBounds: <#T##Bool#>, searchBarPlaceholder: <#T##String#>
        
        
        let podBundle = Bundle(for: BaseAddressView.self)
        let nib = UINib(nibName: "BaseAddressView", bundle: podBundle)
        mainView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        self.addSubview(mainView)
        mainView.frame = bounds
        mainView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        let image1 = UIImage(named: "acount_dropdown")
        // let image2 = UIImage(named: "up_arrow")
        
        self.plusBtn.setImage(image1, for: .selected)
        self.plusBtn.setImage(image1, for: .normal)
        self.plusBtn.setImage(image1, for: .highlighted)
        initializeAddress()
    }
    
    func initializeAddress(){
        
        
        
    }
    
    public func setAddressGeoLavel(PROFILE_ATTRIBUTE_GEO_LEVEL: String, viewController: UIViewController)  {
        profileGeoLabel = PROFILE_ATTRIBUTE_GEO_LEVEL
        if PROFILE_ATTRIBUTE_GEO_LEVEL == "3" {
            geoLabel = .cities
        }
        VC = viewController
        placesSearchController  = {
            let controller = GooglePlacesSearchController(delegate: self, apiKey: GoogleMapsAPIServerKey, placeType: geoLabel, coordinate: kCLLocationCoordinate2DInvalid, radius: 34, strictBounds: true, searchBarPlaceholder: ""
                
            )
            return controller
        }()
        
        
    }
    
    
    @IBAction func showaddressView(_ sender: Any) {
        if profileGeoLabel == "0" {
             let podBundle = Bundle(for: BaseAddressView.self)
            let storyboard = UIStoryboard(name: "Main", bundle: podBundle)
            let viewCon = storyboard.instantiateViewController(withIdentifier :"SelectCountryViewController") as! SelectCountryViewController
            viewCon.textCountry = self.dropDownLbl
            viewCon.DelegateSelect = self
            
            VC.present(viewCon, animated: true) {
                
            }
            return
            
        }
        VC.present(placesSearchController, animated: true, completion: nil)
    }
}

extension BaseAddressView: GooglePlacesAutocompleteViewControllerDelegate, UpdateCountryList{
    func updateCountrySelection(countryname: String) {
        self.dropDownLbl.text = countryname
        self.Delegate.UpdateAddressText(view: self, index: 0, text:countryname )
    }
    
    public func viewController(didAutocompleteWith place: PlaceDetails) {
        
        if let cntry = place.country {
            print("cntry ==",cntry)
        }
        
        var geocode = ""
        var locality = ""
        var sublocality = ""
        var administrativeArea = ""
        var country = ""
        var name = ""
        var address = ""
        var FROM_CITY_NAME = ""
         //GMSAutocompleteViewController
         let CITY_NAME = ""
         placesSearchController.isActive = false
         
        if profileGeoLabel == "1"
        {
            if let lc = place.administrativeArea {
                self.dropDownLbl.text = lc
                self.Delegate.UpdateAddressText(view: self, index: 0, text:lc )
               
                return
            }
            else if let lc = place.locality {
                self.dropDownLbl.text = lc
                self.Delegate.UpdateAddressText(view: self, index: 0, text:lc )
              
                return
            }
            else if let lc = place.subLocality {
                self.dropDownLbl.text = lc
                self.Delegate.UpdateAddressText(view: self, index: 0, text:lc )
                
                return
            }
        }
        else if profileGeoLabel == "2"{
            if let nm = place.name {
                name = nm
            }
            if let cntry = place.country {
                country = cntry
            }
            if let lc = place.administrativeArea {
                administrativeArea =  ", " + lc
            }
            var adress1Type = ""
            if let lc = place.locality{
                locality = lc
                FROM_CITY_NAME = locality
                print("place.locality ==",lc)
                
            }
            else if let lc = place.subLocality {
                locality = lc
                FROM_CITY_NAME = locality
                print("place.locality ==",lc)
                
            }
            
            
            
            if locality.contains(name) {
                adress1Type = locality + administrativeArea + ", " + country
            }
            else {
                
                adress1Type = name + ", " + locality + administrativeArea + ", " + country
            }
            
            self.dropDownLbl.text = adress1Type
            self.Delegate.UpdateAddressText(view: self, index: 0, text:adress1Type )
            
            return
            
        }
        else if profileGeoLabel == "3"{
            if let lc = place.locality{
                self.dropDownLbl.text = lc
                self.Delegate.UpdateAddressText(view: self, index: 0, text:lc )
             
                return
            }
            else if let lc = place.subLocality{
                self.dropDownLbl.text = lc
                self.Delegate.UpdateAddressText(view: self, index: 0, text:lc )
             
                return
            }
            
        }
        /*
        else if profileGeoLabel == "2"{
            if let lc = place.locality {
                self.dropDownLbl.text = lc
                self.Delegate.UpdateAddressText(view: self, index: 0, text:lc )
               
                return
            }
            else if let lc = place.subLocality {
                self.dropDownLbl.text = lc
                self.Delegate.UpdateAddressText(view: self, index: 0, text:lc )
                
                return
            }
            else if let lc = place.administrativeArea {
                self.dropDownLbl.text = lc
                self.Delegate.UpdateAddressText(view: self, index: 0, text:lc )
                
                return
            }
            
        }
         */
         else{
             let lc = place.formattedAddress
                self.dropDownLbl.text = lc
                self.Delegate.UpdateAddressText(view: self, index: 0, text:lc )
            
                return
            
        }
        
        
        if geoLabel == .cities {
            if let lc = place.locality{
                locality = lc
                
                self.dropDownLbl.text = locality
                self.Delegate.UpdateAddressText(view: self, index: 0, text:locality )
                
            }
        }
       
    }
}

