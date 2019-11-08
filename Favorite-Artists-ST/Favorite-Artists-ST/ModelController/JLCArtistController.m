//
//  JLCArtistController.m
//  Favorite-Artists-ST
//
//  Created by Jake Connerly on 11/8/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

#import "JLCArtistController.h"
#import "JLCArtist.h"

@implementation JLCArtistController

static NSString *const baseURLString = @"theaudiodb.com/api/v1/json/1/search.php";

- (void)searchForArtistWithArtistName:(NSString *)artistName
                           completion:(void (^)(JLCArtist *artist, NSError *error))completion {
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSURLComponents *components = [NSURLComponents componentsWithURL:baseURL resolvingAgainstBaseURL:YES];
    
    NSURLQueryItem *artistToSearch = [NSURLQueryItem queryItemWithName:@"s" value:artistName];
    [components setQueryItems:@[artistToSearch]];
    
    NSURL *url = [components URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithRequest:request
        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if (!data) {
            completion(nil, [[NSError alloc] init]);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            completion(nil, error);
            return;
        }
        
        if(![json isKindOfClass:[NSDictionary class]]) {
            NSLog(@"JSON was not a top lvel dictionary as expected");
            completion(nil, [[NSError alloc] init]);
        }
        
        NSArray *artistsResults = json[@"artists"];
        NSDictionary *artistDictionary = artistsResults[0];
        JLCArtist *artist = [[JLCArtist alloc] InitWithDictionary:artistDictionary];
        
        completion(artist, nil);
    }];
    [task resume];
    
}

@end