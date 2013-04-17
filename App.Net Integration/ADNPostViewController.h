//
//  ADNPostViewController.h
//  App.Net Integration
//
//  Created by Greg V on 4/13/13.
//
//

#import <UIKit/UIKit.h>

@interface ADNPostViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) UITextView *bodyField;

@end
