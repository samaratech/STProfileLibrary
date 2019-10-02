Pod::Spec.new do |s|
s.name             = 'STProfileLibrary'
s.version          = '1.1.0'
s.summary          = 'This is use for hanlding the profile'

s.description      = <<-DESC
We can use the tess app to handle the UI of profile section as well as all the profile would be automtically designed.
DESC

s.homepage         = 'https://github.com/samaratech/STProfileLibrary'

s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'samaratech' => 'md.farmood@hipl.co.in' }

s.source           = { :git => 'https://github.com/samaratech/STProfileLibrary.git', :tag => s.version.to_s }
s.swift_version = "4.2"

s.ios.deployment_target = '10.0'

s.source_files = 'STProfileLibrary/Classes/**/*'
s.resource_bundles = {
'STProfileLibrary' => ['STProfileLibrary/Assets/**/*.xcassets']
}

# s.public_header_files = 'Pod/Classes/**/*.h'

s.dependency 'MBProgressHUD'
s.dependency 'IQKeyboardManagerSwift', '~> 6.1.1'
s.dependency 'DropDown'
s.dependency 'CountryPickerSwift'
s.dependency 'GooglePlacesSearchController'
s.dependency 'MBProgressHUD'
s.dependency 'Alamofire'
s.dependency 'JTAppleCalendar', '~> 7.0'
s.dependency 'SDWebImage'
s.dependency 'OpalImagePicker'

end


