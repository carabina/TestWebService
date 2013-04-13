//
//  ViewController.m
//  TestWebService
//
//  Created by ali raza on 3/22/13.
//  Copyright (c) 2013 ali raza. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize webData;
@synthesize nodeContent;
@synthesize finaldata;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nodeContent = [[NSMutableString alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)invokeService:(id)sender {

        if ([_txt1.text length]==0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"WebService" message:@"Enter some integer value in text field" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok",nil];
            [alert show];
          //  [alert release];
        }
        else {
            [_txt1 resignFirstResponder];
     
            
            NSString *soapFormat = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                    "<soap:Body>\n"
                                    "<CelsiusToFahrenheit xmlns=\"http://tempuri.org/\">\n"
                                    "<Celsius>%@</Celsius>\n"
                                    "</CelsiusToFahrenheit>\n"
                                    "</soap:Body>\n"
                                    "</soap:Envelope>\n",_txt1.text];
            NSURL *locationOfWebService = [NSURL URLWithString:@"http://www.w3schools.com/webservices/tempconvert.asmx"];
            NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc]initWithURL:locationOfWebService];
            NSString *msgLength = [NSString stringWithFormat:@"%d",[soapFormat length]];
            [theRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
            [theRequest addValue:@"http://tempuri.org/CelsiusToFahrenheit" forHTTPHeaderField:@"SOAPAction"];
            [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
            [theRequest setHTTPMethod:@"POST"];
            //the below encoding is used to send data over the net
            [theRequest setHTTPBody:[soapFormat dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
            if (connect) {
                webData = [[NSMutableData alloc]init];
                NSLog(@"Connection Establish");
            }
            else {
                NSLog(@"No Connection established");
            }
        }
    }

#pragma - NSURLConnection delegate method
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR with theConenction");
    //[connection release];
    //[webData release];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"DONE. Received Bytes: %d", [webData length]);
    self.xmlParser = [[NSXMLParser alloc]initWithData:webData];
    [self.xmlParser setDelegate: self];
    //    [self.xmlParser setShouldProcessNamespaces:NO];
    //    [self.xmlParser setShouldReportNamespacePrefixes:NO];
    //    [self.xmlParser setShouldResolveExternalEntities:NO];
    [self.xmlParser parse];
    
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"found character %@",string);
    [nodeContent appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    self.finaldata = nodeContent;
    _output.text = finaldata;
    NSLog(@"node %@",nodeContent);
    NSLog(@"final %@",finaldata);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:@"CelsiusToFahrenheitResult"]) {
        self.finaldata = nodeContent;
        _output.text = finaldata;
        NSLog(@"did End Element");
    }
    _output.text = finaldata;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"ERROR WITH PARSER");
    
}
@end
