//
//  ViewController.swift
//  HttpDemo
//
//  Created by angcyo on 16/08/26.
//  Copyright © 2016年 angcyo. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController {

	@IBOutlet weak var labelOutlet: UILabel!
	let baidu = "http://www.baidu.com"
	let url = "http://httpbin.org/ip"
	var bdUrl: NSURL {
		return NSURL(string: baidu)!
	}

	@IBOutlet weak var imageView: UIImageView!

	var application: UIApplication {
		return UIApplication.sharedApplication()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func openBaidu() {
		let can = application.canOpenURL(bdUrl)
		print("\(NSThread.isMainThread()) \(can)")
		if can {
			NSOperationQueue().addOperationWithBlock {
				let result = self.application.openURL(self.bdUrl)
				print("\(NSThread.isMainThread()) \(result)")
			}
		}
	}

	@IBAction func openWidthSession() {
//		NSURLSession.sharedSession().dataTaskWithURL(bdUrl).resume()
		NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { data, response, error in
			print("\(NSThread.isMainThread()) \(String(data: data!, encoding:NSUTF8StringEncoding))")
			print("\(response)")
			print("\(error)")
		}.resume()
	}

	@IBAction func openWidthAlamofire() {

		// 1:
		Alamofire.request(.GET, url)
			.validate()
			.response { request, response, data, error in
				print("\(request?.URLString)")
				print("\(response)")
				print("\(NSThread.isMainThread()) \(data) \n \(String(data: data!, encoding: NSUTF8StringEncoding))")
				print("\(error)")
		}

		// 2:
		Alamofire.request(.GET, bdUrl).responseString { response in
			print("\(NSThread.isMainThread()) \(response.result.value)")
			self.labelOutlet.text = response.result.value
			self.labelOutlet.sizeToFit()
		}
	}

	@IBAction func pngImage() {
		let url = "http://img.bbs.cnhubei.com/forum/201604/18/153142rtj9q89tapbkqppw.gif"
		let url2 = "https://httpbin.org/image/png"
		// 1:
//		Alamofire.request(.GET, url)
//			.responseImage { response in
//				print(response.request)
//				print(response.response)
//
////				print("data:\(response.data) timeline:\(response.timeline)")
//
//				if let image = response.result.value {
//					print("image downloaded: \(image)")
//					self.imageView.image = image
//				}
//		}
		// 2:
		imageView.af_setImageWithURL(NSURL(string: url)!)
	}
}

