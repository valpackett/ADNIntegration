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

#define PHOTO_URL @"photos.app.net/{post_id}/1"

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
        if ([object isKindOfClass:[UIImage class]] || [object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSURL class]]) {
            return YES;
        }
    }
    return NO;
};

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (id object in activityItems) {
        if ([object isKindOfClass:[UIImage class]]) {
            self.image = object;
            self.url = PHOTO_URL;
            return;
        } else if ([object isKindOfClass:[NSString class]]) {
            self.url = object;
        } else if ([object isKindOfClass:[NSURL class]]) {
            NSURL *o = object;
            if ([o.scheme isEqual: @"file"]) { // from cross-app document sharing
                self.image = [UIImage imageWithContentsOfFile:o.path];
                self.url = PHOTO_URL;
            } else if ([o.scheme isEqual:@"assets-library"]) { // from Photos.app
                dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    ALAssetsLibrary *assetsl = [[[ALAssetsLibrary alloc] init] autorelease];
                    [assetsl assetForURL:o resultBlock:^(ALAsset *asset) {
                        CGImageRef iref = [[asset defaultRepresentation] fullResolutionImage];
                        if (iref) {
                            self.image = [UIImage imageWithCGImage:iref];
                            self.url = PHOTO_URL;
                        }
                        dispatch_semaphore_signal(sema);
                    } failureBlock:^(NSError *error) {
                        dispatch_semaphore_signal(sema);
                    }];
                });
                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                dispatch_release(sema);
            } else {
                self.url = [o absoluteString];
            }
        }
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
        vc.image = self.image;
        [nav pushViewController:vc animated:NO];
    }

    return nav;
}

@end
