//
//  ADNTokenStore.h
//  App.Net Integration
//
//  Created by Greg V on 4/17/13.
//
//

#import <Foundation/Foundation.h>

@interface ADNTokenStore : NSObject

+ (void)setToken:(NSString *)value;
+ (NSString *)getToken;
+ (void)deleteToken;

@end
