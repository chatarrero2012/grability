//
//  ViewController.m
//  GrabilyChallenge
//
//  Created by Davit on 11/26/15.
//  Copyright (c) 2015 ZipDev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self getAllData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",error.description);
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //appending received data
    [self.MyData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //getting json string from NSData
    NSString *strJsonString=[[NSString alloc]initWithData:self.MyData encoding:NSUTF8StringEncoding];
    //Finally parsing is done here with SBJsonParser
    NSError *error;
    NSDictionary *allDict = [NSJSONSerialization JSONObjectWithData:self.MyData
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:&error];
    NSArray *allAppsArray=[[allDict objectForKey:@"feed"] objectForKey:@"entry"];
    //NSLog(@"llega %@",[[allDict objectForKey:@"feed"] objectForKey:@"entry"]);
    NSLog(@"json=%@", strJsonString);
    for (NSDictionary *thisDict in allAppsArray) {
        NSDictionary *catData=[thisDict objectForKey:@"category"];
        NSLog(@"cat: %@",[[catData objectForKey:@"attributes"] objectForKey:@"label"]);
    }
}
-(void)getAllData{
    self.MyData=[[NSMutableData alloc]init];
    self.arrayData=[[NSMutableArray alloc]init];
    NSURL *url=[NSURL URLWithString:@"https://itunes.apple.com/us/rss/toppaidapplications/limit=25/genre=6012/json"];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]init];
    //header properties
    //settting http method its define the behaviour of GetData
    [request setHTTPMethod:@"GET"];
    //setting Content-Type that define the message formate
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setURL:url];
    self.connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
-(BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0){
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0){
    UIInterfaceOrientationMask mask=UIInterfaceOrientationMaskPortrait;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mask=UIInterfaceOrientationMaskLandscape;
    }
    
    return mask;
}
- (UIImage *) getImageFromUserIMagesFolderInDocsWithName:(NSString *)nameOfFile
{
    UIImage *image = [UIImage imageNamed:nameOfFile];
    if (!image) // image doesn't exist in bundle...
    {
        // Get Image
        NSString *cleanNameOfFile = [[[nameOfFile stringByReplacingOccurrencesOfString:@"." withString:@""]
                                      stringByReplacingOccurrencesOfString:@":" withString:@""]
                                     stringByReplacingOccurrencesOfString:@"/" withString:@""];
        
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.png", cleanNameOfFile]];
        image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
        if (!image)
        {
            // image isn't cached
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:nameOfFile]]];
            [self saveImageToUserImagesFolderInDocsWithName:cleanNameOfFile andImage:image];
        }
        else
        {
            // if we have a internet connection, update the cached image
            /*if (isConnectedToInternet) {
             image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:nameOfFile]]];
             [self saveImageToUserImagesFolderInDocsWithName:cleanNameOfFile andImage:image];
             }*/
            // otherwise just return it
        }
    }
    return image;
}
- (void) saveImageToUserImagesFolderInDocsWithName:(NSString *)nameOfFile andImage:(UIImage *)image
{
    NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.png", nameOfFile]];
    [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
    
    
    NSLog(@"directory: %@", [[UIImage alloc] initWithContentsOfFile:pngPath]);
}
@end
