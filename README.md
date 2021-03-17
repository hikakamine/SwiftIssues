# iOS Programming Challenge

## Running instructions
Run 'pod install'

Edit LocalConfig.xcconfig file with identifiers and development team variables when running in devices

## Objective
Develop an iOS application that uses GitHub Issues API ( https://developer.github.com/v3/issues/ ),
using the Swift repository ( https://github.com/apple/swift ).

## The application must
* Shows a screen with a list of issues from the repository
( https://api.github.com/repos/apple/swift/issues ). Each item must contain
the following elements:
    * Issue title
    * Issue status (OPEN, CLOSED)
* A screen presenting following details from the selected issue in the previous list:
    * Issue title
    * Issue description
    * User avatar of the issue creator
    * Creation date
    * A button which opens the browser with the issue URL on GitHub

## Details
* Target: iOS 12.3
* Swift 5

## Architecture
* MVVM
* View Code

## Frameworks 
* Alamofire 5.2/Moya 14.0
* Unit tests: Quick, Nimble, Cuckoo e OHHTTPStubs
