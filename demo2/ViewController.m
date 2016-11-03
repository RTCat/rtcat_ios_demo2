//
//  ViewController.m
//  demo2
//
//  Created by spacetime on 10/26/16.
//  Copyright © 2016 spacetime. All rights reserved.
//

#import "ViewController.h"
#import "WhiteBoardView.h"
#import <RTCatSDK/RTCat.h>

@interface ViewController(SessionDelegate)<RTCatSessionDelegate>

@end

@interface ViewController () <WhiteBoardDelegate>{
    RTCat *cat;
    RTCatSession *session;
    NSString *tokenId;
}


@property (weak, nonatomic) IBOutlet WhiteBoardView *whiteBoard;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_whiteBoard addDelegate:self];
    
    cat = [RTCat shareInstance];
    
    //todo add
    NSString *sessionId = @"";
    NSString *apiKey = @"";
    NSString *apiSecret = @"";
    
    NSString *url = [NSString stringWithFormat:@"https://api.realtimecat.com/v0.3/sessions/%@/tokens",sessionId];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    [request setValue:apiKey forHTTPHeaderField:@"X-RTCAT-APIKEY"];
    [request setValue:apiSecret forHTTPHeaderField:@"X-RTCAT-SECRET"];
    
    NSString *dataString = [NSString stringWithFormat:@"session_id=%@&type=%@",sessionId,@"pub"];
    NSData *data = [dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[data length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)messageHandler:(NSString *)type X:(float)x Y:(float)y{
    
    NSDictionary *dict = @{
        @"point"   :type,
        @"x"       :[NSNumber numberWithFloat:x],
        @"y"       :[NSNumber numberWithFloat:y],
        @"pointNum":@0,
        @"lineNum" :@0
        };
    
    NSError *error;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:(NSJSONWritingPrettyPrinted) error:&error];
    
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [session broadcastMessage:message];
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:data
                 options:0
                 error:&error];
    
    if([object isKindOfClass:[NSDictionary class]]){
    
        NSDictionary *results = object;
        tokenId = [results objectForKey:@"uuid"];
        NSLog(@"my token is %@",tokenId);
        
        
        session = [cat createSessionWithToken:tokenId];
        [session addDelegate:self];
        [session connect];
    }
    else{
    }
    
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error %@",[error localizedDescription]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
}
@end



#pragma mark  session delegate

@implementation ViewController(SessionDelegate)

-(void)sessionIn:(NSString *)token{
    NSLog(@"%@ is in",token);
}

-(void) sessionOut:(NSString *)token{
    NSLog(@"%@ is out",token);
}

-(void)sessionConnected:(NSArray *)tokens{
    NSLog(@"connected");
}

-(void)sessionClose{
    
}

-(void)sessionError:(NSError *)error{
    NSLog(@"session error -> %@",error);
}

-(void)sessionLocal:(RTCatSender *)sender{
    
}

-(void)sessionRemote:(RTCatReceiver *)receiver{
    
}

-(void)sessionMessage:(NSString *)message from:(NSString *)tokenId{
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:data
                 options:0
                 error:&error];
    
    if([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *results = object;
        NSString *type = [results objectForKey:@"point"];
        float x = [[results objectForKey:@"x"] floatValue];
        float y = [[results objectForKey:@"y"] floatValue];

        [_whiteBoard drawOtherHandle:type X:x Y:y];
    }
    
    
}


@end
