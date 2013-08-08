//
//  SMSorEmailUtil.h
//  EMeeting
//
//  Created by AppDev on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "CustomTools.h"

@interface SMSorEmailUtil : NSObject<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>

@property(nonatomic,retain)UIViewController *vc;

-(id)initWithVC:(UIViewController*)sendvc;
-(void)showSMS:(NSString*)body numArr:(NSArray*)numArr;
-(void)showEmail:(NSString*)body;

@end
