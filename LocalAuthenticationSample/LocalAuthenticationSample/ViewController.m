//
//  ViewController.m
//  LocalAuthenticationSample
//
//  Created by a on 2/14/19.
//  Copyright © 2019 HTG. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface ViewController () {
    // The identifier and service name together will uniquely identify the keychain entry.
    NSString *keychainItemIdentifier;
    NSString *keychainItemServiceName;
    LAContext *context;
}
- (IBAction)authenicateBtnPress:(id)sender;
- (IBAction)validatedBtnPress:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    keychainItemIdentifier = @"fingerprintKeychainEntry";
    keychainItemServiceName = @"com.secsign.secsign";
    //    [self authenicateButtonTapped];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



- (void) deviceOwnerAuthenticationWithBiometrics {
    context = [[LAContext alloc] init];
   
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"Touch ID Test to show Touch ID working in a custom app";
    
     // Test if fingerprint authentication is available on the device and a fingerprint has been enrolled.
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        NSLog(@"Fingerprint authentication available.");
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError *error) {
            if (success) {
                NSLog(@"Switch to fall back authentication - ie, display a keypad or password entry box");
                [self showAlertView:@"success" MSG:@"success"];
            } else {
                 [self getErrorDescription:error];
            }
        }];
    } else {
        [self getErrorDescription:authError];
    }
}


- (IBAction)authenicateBtnPress:(id)sender {
    [self deviceOwnerAuthenticationWithBiometrics];
}

- (IBAction)validatedBtnPress:(id)sender {
     [self deviceOwnerAuthenticationWithPinCode];
}



- (void) showAlertView : (NSString *) title MSG:(NSString *) message   {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

-(void) getErrorDescription : (NSError *) error {
    
    NSString *errorMsgStr = @"";
    switch (error.code) {
        case LAErrorAuthenticationFailed:
            errorMsgStr = @"Authentication Failed";
            NSLog(@"LAErrorAuthenticationFailed");
            break;
            
        case LAErrorUserCancel:
            errorMsgStr = @"User pressed Cancel button";
            NSLog(@"LAErrorUserCancel");
            break;
            
        case LAErrorUserFallback:
            errorMsgStr = @"User pressed Enter Password";
            NSLog(@"LAErrorUserFallback");
            break;
            
        case LAErrorSystemCancel:
            errorMsgStr = @"System Cancel";
            NSLog(@"LAErrorSystemCancel");
            break;
            
        case LAErrorPasscodeNotSet:
            errorMsgStr = @"Error Passcode Not Set";
            NSLog(@"LAErrorPasscodeNotSet");
            break;
            
        case LAErrorBiometryNotAvailable:
            errorMsgStr = @"Biometry Not Available";
            NSLog(@"LAErrorTouchIDNotAvailable");
            break;
            
        case LAErrorBiometryNotEnrolled:
            errorMsgStr = @"Biometry Not Enrolled";
            NSLog(@"LAErrorBiometryNotEnrolled");
            break;
            
        case LAErrorBiometryLockout:
            errorMsgStr = @"Biometry Lockout";
            NSLog(@"LAErrorBiometryLockout");
            break;
            
        case LAErrorAppCancel:
            errorMsgStr = @"AppCancel";
            NSLog(@"LAErrorAppCancel");
            break;
            
        case LAErrorInvalidContext:
            errorMsgStr = @"Invalid Context";
            NSLog(@"LAErrorInvalidContext");
            break;
            
        case LAErrorNotInteractive:
            errorMsgStr = @"LAErrorNotInteractive";
            NSLog(@"LAErrorNotInteractive");
            break;
            
        default:
            errorMsgStr = @"Touch ID is not configured";
            NSLog(@"Touch ID is not configured");
            break;
    }
    
    if (error.code == LAErrorUserFallback || error.code == LAErrorBiometryLockout) {
        [self deviceOwnerAuthenticationWithPinCode];
    } else {
         [self showAlertView:@"Error" MSG:errorMsgStr];
    }
    
}

- (void) deviceOwnerAuthenticationWithPinCode {

    [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:NSLocalizedString(@"Unlock APP With PassCode", nil) reply: ^(BOOL success, NSError *authenticationError) {
        if(success){
            NSLog(@"PassCode Login successful");
        }else{
            NSLog(@"%@",authenticationError);
            [self getErrorDescription:authenticationError];
        }
    }];
    
}


@end
