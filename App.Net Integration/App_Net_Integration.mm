#line 1 "/Users/myfreeweb/Code/open/App.Net Integration/App.Net Integration/App_Net_Integration.xm"
#import <UIKit/UIKit.h>
#import "ADNIntegrationActivity.h"



#include <logos/logos.h>
#include <substrate.h>
@class UIActivityViewController; 
static id (*_logos_orig$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$)(UIActivityViewController*, SEL, NSArray *, NSArray *); static id _logos_method$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$(UIActivityViewController*, SEL, NSArray *, NSArray *); 

#line 6 "/Users/myfreeweb/Code/open/App.Net Integration/App.Net Integration/App_Net_Integration.xm"


static id _logos_method$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$(UIActivityViewController* self, SEL _cmd, NSArray * activityItems, NSArray * applicationActivities) {
	NSArray *activities = applicationActivities;
    ADNIntegrationActivity *adnActivity = [ADNIntegrationActivity new];
	activities = [activities arrayByAddingObject:adnActivity];
	return _logos_orig$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$(self, _cmd, activityItems, activities);
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$UIActivityViewController = objc_getClass("UIActivityViewController"); MSHookMessageEx(_logos_class$_ungrouped$UIActivityViewController, @selector(initWithActivityItems:applicationActivities:), (IMP)&_logos_method$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$, (IMP*)&_logos_orig$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$);} }
#line 16 "/Users/myfreeweb/Code/open/App.Net Integration/App.Net Integration/App_Net_Integration.xm"
