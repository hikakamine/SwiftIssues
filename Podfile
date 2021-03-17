platform :ios, '12.3'

use_frameworks!

def application_pods
  pod 'Alamofire', '~> 5.2'
  pod 'Moya', '~> 14.0'
end

def testing_pods
  pod 'Quick', '~> 3.1'
  pod 'Nimble', '~> 9.0'
  pod 'OHHTTPStubs/Swift', '~> 9.1'
end

target 'Swift Issues' do
  application_pods
end

target 'Swift IssuesTests' do
  application_pods
  testing_pods
end

target 'Swift IssuesUITests' do
  application_pods
  testing_pods
end
