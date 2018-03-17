[![Build Status](https://travis-ci.org/bmkor/gason.svg?branch=master)](https://travis-ci.org/bmkor/gason) ![Pod](https://cocoapod-badges.herokuapp.com/v/gasonframework/badge.png)
# What is gasonframework?
A Swift wrapper of a light and fast C++ JSON parser named [gason](https://github.com/vivkin/gason). 

# How fast is this gason wrapper?
We tested all the JSONs found [here](https://github.com/Newbilius/big_json_import_demo/tree/master/test_data) for comparing the parsing speed of this gason wrapper and JSONSerialization and obtained the results below:

| JSON name | size    | JSONSerialization | gason wrapper |
|:-----------:|:---------:|:-------------------:|:---------------:|
| small     | 6.27 KB | 0.001 sec         | 0.000 sec     |
| big       | 5.79 MB | 0.276 sec         | 0.046 sec     |
| very_big  | 13.4 MB | 0.619 sec         | 0.110 sec     |

The testing environment is 
* MacBook Pro (15-inch, 2017)
* Processor 2.9 GHz Intel Core i7
* Memory 16 GB 2133 MHz LPDDR3
* Simulator iPhone 8 Plus

The above test case is implemented as performance XCTest [gasonframework_performanceTests](https://github.com/bmkor/gason/blob/master/gasonframeworkTests/gasonframework_performanceTests.swift).

# How accurate is this gason wrapper?
We tested all the JSONs found [here](https://github.com/nst/JSONTestSuite/tree/master/test_parsing) for judging the accuracy of this gason wrapper and the accuracy is compared with JSONSerialization. The test JSONs are in three categories:

|Category|Explanation|Meaning|
|:-------:|:-------:|:-------:|
|Pass|A valid JSON|Parser should parse this JSON without error|
|Fail|An invalid JSON|Parser should fail to parse this JSON with error|
|Indeterminate|Not an invalid JSON|Parser may or may not fail to parse this JSON|

The parsing results are summarised below:

|Category|Count|JSONSerialization|gason wrapper|
|:-------:|:-------:|:-------:|:-------:|
|Pass|95|94 parsed successfully|93 parsed successfully|
|Fail|188|187 failed in parsing with error|153 failed in parsing with error|
|Indeterminate|34|8 parsed successfully and 26 failed|10 parsed successfully and 24 failed|


Notes:
* As [mentioned](https://github.com/vivkin/gason), gason is **not** a strict parser which indeed showed a high tolerance in parsing an invalid JSON. 
* The faster parsing speed of gason wrapper doesn't come without trade-off. There are 2 valid JSONs missed for gason wrapper; whereas JSONSerialization only gets one. However, their failing reasons are different.
* The above test case was implemented as XCTest [gasonframework_parsingTests](https://github.com/bmkor/gason/blob/master/gasonframeworkTests/gasonframework_parsingTests.swift). Please be noted that only gason wrapper was implemented. 

# How to use?
You may use [cocoapods](https://cocoapods.org) by creating a Podfile with content as below:
```
# Uncomment the next line to define a global platform for your project
#platform :ios, '9.0'

target 'YOUR AWESOME APPNAME' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for gasonTest
  pod 'gasonframework', :git => 'https://github.com/bmkor/gason.git'
end
```
Just change `'YOUR AWESOME APPNAME'` to your app name and then type `pod install` in the command line. Please remember to open the `.xcworkspace` instead of `.xcodeproj` after installation.

Alternatively, you may just clone this repo, build the framework yourself and import the framework to your project.

# Documentation?
This gason wrapper is intended to be simple and straightforward. I would like to give a sample usage as below. In case, you need more, just open an issue.

A sample usage demo:
```
import UIKit
import gasonframework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let url = URL(string:"https://raw.githubusercontent.com/Newbilius/big_json_import_demo/master/test_data/small.json"), let data = try? Data(contentsOf: url){
            let config = try? JSON(data)
            print(config)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

```


