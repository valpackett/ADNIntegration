#import <UIKit/UIKit.h>
#import "ADNIntegrationActivity.h"

// thanks: https://github.com/jridgewell/InstapaperActivity/blob/master/InstapaperActivity/InstapaperActivity.xm

%hook UIActivityViewController

- (id)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities {
	NSArray *activities = applicationActivities;
    ADNIntegrationActivity *adnActivity = [ADNIntegrationActivity new];
	activities = [activities arrayByAddingObject:adnActivity];
	return %orig(activityItems, activities);
}

%end