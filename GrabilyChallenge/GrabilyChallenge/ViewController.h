//
//  ViewController.h
//  GrabilyChallenge
//
//  Created by Davit on 11/26/15.
//  Copyright (c) 2015 ZipDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property(strong,nonatomic)NSMutableData *MyData;
@property(strong,nonatomic)NSMutableArray *arrayData;
@property(strong,nonatomic)NSURLConnection *connection;
-(void)getAllData;
@end

