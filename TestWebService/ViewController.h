//
//  ViewController.h
//  TestWebService
//
//  Created by ali raza on 3/22/13.
//  Copyright (c) 2013 ali raza. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController<NSXMLParserDelegate,NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txt1;
@property (weak, nonatomic) IBOutlet UITextField *output;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *output;
@property (retain, nonatomic) NSMutableData *webData;
@property (retain, nonatomic) NSXMLParser *xmlParser;
@property (retain, nonatomic) NSMutableString *nodeContent;
@property (retain, nonatomic) NSString *finaldata;

- (IBAction)invokeService:(id)sender;
@end
