//
//  ViewController.swift
//  TimeChange
//
//  Created by shenj on 16/2/23.
//  Copyright © 2016年 shenj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timeNow = NSDate.init()
    var timeLast = NSDate.init()
    
    var timeDif = Int()
    
    var countDownLabel = UILabel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载时间搓 转换成时间字符串
        self.loadTime()
        
        self.calculateAgeFromDate(timeNow, timeLast: timeLast)
        
        // 创建控件
        self.countDownUIconfig()
        
    }
    
    // 加载时间搓 转换成时间字符串
    func loadTime(){
        let timeStr = NSString(string: "1404610907")
        
        let timeSta:NSTimeInterval = timeStr.doubleValue
        
        let dfmatter = NSDateFormatter()
        
        // 2014年07月06日 09:41:47
        dfmatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        
        timeNow = NSDate(timeIntervalSince1970: timeSta)
        
        print(timeNow)
        //57 50
        
        
        
        let timeStrLast = NSString(string: "1404614517")
        
        let timeStaLast:NSTimeInterval = timeStrLast.doubleValue
        
        let dfmatterLast = NSDateFormatter()
        
        // 2014年07月06日 09:41:47
        dfmatterLast.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        
        timeLast = NSDate(timeIntervalSince1970: timeStaLast)
        
        print(timeLast)
        
    }

    // 倒计时控件展示
    func countDownUIconfig(){
        
        countDownLabel = UILabel.init(frame: CGRectMake(0, 0, 240, 44))
        
        self.view.addSubview(countDownLabel)
        
        countDownLabel.center = self.view.center
        
        countDownLabel.layer.borderWidth = 5
        
        countDownLabel.textAlignment = NSTextAlignment.Center
        
        countDownLabel.layer.cornerRadius = 10
        
        countDownLabel.font = UIFont.systemFontOfSize(21.0, weight: 100)
        
        
        let timeStr = timeNow
        
        print(timeStr)
        
        
        
        let secondsDif = timeDif % 60
        let minuteDif = timeDif / 60 % 60
        let hoursDif = timeDif / 60 / 60
        
        
        countDownLabel.text = String.init(stringInterpolationSegment:hoursDif) + ":" +
                                String.init(stringInterpolationSegment:minuteDif) + ":" +
                                String.init(stringInterpolationSegment:secondsDif)
        
        // 计时操作
        self.countDown(hoursDif, residualMinutes: minuteDif, residualSeconds: secondsDif)
        
    }
    
    // 倒计时函数
    func countDown(var residualHours:Int,var residualMinutes:Int,var residualSeconds:Int){
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        dispatch_source_set_timer(timer, dispatch_walltime( nil  , 0), 1 * NSEC_PER_SEC, 0)
        
        dispatch_source_set_event_handler(timer) { () -> Void in
            
            if residualSeconds <= 0{ // 秒为0
                
                dispatch_source_cancel(timer)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.showTime(residualHours, residualMinutes: residualMinutes, residualSeconds: residualSeconds)
                    
                })
                
                if residualMinutes <= 0{ // 分为0
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.showTime(residualHours, residualMinutes: residualMinutes, residualSeconds: residualSeconds)
                        
                    })
                    
                    if residualHours <= 0{ // 时为0
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.showTime(residualHours, residualMinutes: residualMinutes, residualSeconds: residualSeconds)
                            
                        })
                        
                    }else{
                        
                        let hoursOut = residualHours % 60
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.showTime(hoursOut, residualMinutes: residualMinutes, residualSeconds: residualSeconds)
                        })
                        
                        residualHours -= 1
                        residualMinutes = 59
                        residualSeconds = 59
                        
                        self.countDown(residualHours, residualMinutes: residualMinutes, residualSeconds: residualSeconds)
                    }
                    
                }else{
                    
                    let minuteOut = residualSeconds % 60
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.showTime(residualHours, residualMinutes: minuteOut, residualSeconds: residualSeconds)
                    })
                    
                    residualMinutes -= 1
                    residualSeconds = 59
                    
                    self.countDown(residualHours, residualMinutes: residualMinutes, residualSeconds: residualSeconds)
                }
                
                
            }else{
                
                let secondsOut = residualSeconds % 60
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.showTime(residualHours, residualMinutes: residualMinutes, residualSeconds: secondsOut)
                })
                
                residualSeconds -= 1
            }
        }
        
        dispatch_resume(timer);
        
    }
    
    
    // 计算时间搓的差值  秒为单位
    func calculateAgeFromDate (timeFir:NSDate , timeLast:NSDate){
        
        let userCalendar = NSCalendar.currentCalendar()
        
        let components = userCalendar.components(NSCalendarUnit.Second, fromDate: timeNow, toDate: timeLast, options: NSCalendarOptions.WrapComponents)
        
        let seconds = components.second
        
        timeDif = seconds
        
        print(seconds)
        
    }
    
    // 显示时间格式
    func showTime(residualHours:Int,residualMinutes:Int,residualSeconds:Int){
        
        let displayH = residualHours < 10 ?
            ("0" + String.init(stringInterpolationSegment:residualHours)) :
            String.init(stringInterpolationSegment:residualHours)
        
        let displayM = residualMinutes < 10 ?
            ("0" + String.init(stringInterpolationSegment:residualMinutes)) :
            String.init(stringInterpolationSegment:residualMinutes)
        
        let displayS = residualSeconds < 10 ?
            ("0" + String.init(stringInterpolationSegment:residualSeconds)) :
            String.init(stringInterpolationSegment:residualSeconds)
        
        let display = String.init(stringInterpolationSegment:displayH) + ":" +
            String.init(stringInterpolationSegment:displayM) + ":" +
            String.init(stringInterpolationSegment:displayS)
        
    // label 显示时间格式
        countDownLabel.text = display
        
        countDownLabel.textColor = UIColor.init(
            colorLiteralRed: float_t(CGFloat(random())/CGFloat(RAND_MAX)),
            green: float_t(CGFloat(random())/CGFloat(RAND_MAX)),
            blue: float_t(CGFloat(random())/CGFloat(RAND_MAX)),
            alpha: 1)
        
        countDownLabel.layer.borderColor = UIColor.init(
            colorLiteralRed: float_t(CGFloat(random())/CGFloat(RAND_MAX)),
            green: float_t(CGFloat(random())/CGFloat(RAND_MAX)),
            blue: float_t(CGFloat(random())/CGFloat(RAND_MAX)),
            alpha: 1).CGColor
    }
    
}

