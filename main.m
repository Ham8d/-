#import <UIKit/UIKit.h>

static NSString * const kAlertTitle      = @"اســتـمـتـع";
static NSString * const kAlertMessage    = @"التراث ستور عالم خيالي من تطبيقات";
static NSString * const kButtonJoinTitle = @"انضم هنا للحصول ع المميزات";
static NSString * const kButtonOKTitle   = @"حسناً";
static NSString * const kChannelURL      = @"tg://resolve?domain=turath_st";

__attribute__((constructor))
static void initTweak(void) {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow *keyWindow = nil;
            for (UIWindow *window in [UIApplication sharedApplication].windows) {
                if (window.isKeyWindow) {
                    keyWindow = window;
                    break;
                }
            }
            
            UIViewController *topController = keyWindow.rootViewController;
            while (topController.presentedViewController) {
                topController = topController.presentedViewController;
            }

            if (!topController || [topController isKindOfClass:[UIAlertController class]]) {
                return;
            }

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:kAlertTitle
                                                                           message:kAlertMessage
                                                                    preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *joinAction = [UIAlertAction actionWithTitle:kButtonJoinTitle
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:kChannelURL];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }];

            UIAlertAction *okAction = [UIAlertAction actionWithTitle:kButtonOKTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];

            [alert addAction:joinAction];
            [alert addAction:okAction];

            [topController presentViewController:alert animated:YES completion:nil];
        });
    }];
}
