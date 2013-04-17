//
//  ADNIntegrationActivity.m
//  App.Net Integration
//
//  Created by Greg V on 4/11/13.
//
//

#import "ADNIntegrationActivity.h"
#import "ADNPostViewController.h"
#import "ADNLoginViewController.h"
#import "ADNTokenStore.h"
#import "Config.h"

#import "MBHUDView.h"
#import "ADNKit.h"

@implementation ADNIntegrationActivity

+ (NSString *)activityTypeString {
    return @"com.floatboth.ADNIntegrationActivity";
}

- (NSString *)activityType {
    return [ADNIntegrationActivity activityTypeString];
}

- (NSString *)activityTitle {
    return @"App.net";
}

- (UIImage *)activityImage {
    return [UIImage imageWithContentsOfFile:@"/Library/MobileSubstrate/DynamicLibraries/App_Net_Integration/ADNIntegrationActivityIcon.png"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (id object in activityItems) {
        if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSURL class]]) {
            return YES;
        }
    }
    return NO;
};

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (id object in activityItems) {
        NSString *url;
        if ([object isKindOfClass:[NSString class]]) {
            url = object;
        } else if ([object isKindOfClass:[NSURL class]]) {
            NSURL *o = object;
            url = [o absoluteString];
        }
        self.url = url;
    }
}

- (UIViewController *)activityViewController {
    UINavigationController *nav = [[[UINavigationController alloc] init] autorelease];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    NSString *token = [ADNTokenStore getToken];
    if (!token) {
        ADNLoginViewController *vc = [[[ADNLoginViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
        [nav pushViewController:vc animated:NO];
    } else {
        [ANKClient sharedClient].accessToken = token;
        ADNPostViewController *vc = [[[ADNPostViewController alloc] init] autorelease];
        vc.url = self.url;
        [nav pushViewController:vc animated:NO];
    }

    return nav;
}

@end
