//
//  ADNIntegrationActivity.h
//  App.Net Integration
//
//  Created by Greg V on 4/11/13.
//
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ADNIntegrationActivity : UIActivity

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) UIImage *image;
+ (NSString *)activityTypeString;

@end
