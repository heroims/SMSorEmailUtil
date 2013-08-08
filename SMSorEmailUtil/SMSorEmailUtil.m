//
//  SMSorEmailUtil.m
//  EMeeting
//
//  Created by AppDev on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SMSorEmailUtil.h"

@implementation SMSorEmailUtil

@synthesize vc;

-(id)initWithVC:(UIViewController*)sendvc{
    if (self=[super init]) {
        vc=sendvc;
    }
    return self;
}

-(void)displaySMSComposerSheet:(NSString*)body numArr:(NSArray*)numArr{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = (id)vc;
    picker.recipients=numArr;
    picker.body=body;
    [picker.navigationBar setTintColor:[UIColor colorWithRed:250.0/255 green:85.0/255 blue:36.0/255 alpha:1]];;
    [vc presentModalViewController:picker animated:YES];
    [picker release];
}


-(void)showSMS:(NSString*)body numArr:(NSArray*)numArr{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController")); 
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet:body numArr:numArr];
        }
        else {
            [CustomTools msgbox:@"温馨提示" msg:@"设备没有短信功能!"];
        }
        }
    else {
        [CustomTools msgbox:@"温馨提示" msg:@"iOS版本过低,iOS4.0以上才支持程序内发送短信!"];
    } 
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result)
    {
        case MessageComposeResultCancelled:
            //LOG_EXPR(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
            [CustomTools msgbox:@"温馨提示" msg:@"短信发送成功"];
            break;
        case MessageComposeResultFailed:
            [CustomTools msgbox:@"温馨提示" msg:@"短信发送失败"];
            break;
        default:
            //LOG_EXPR(@"Result: SMS not sent");
            break;
    }
    [vc dismissModalViewControllerAnimated:YES];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{   
    //    message.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //message.text = @"Result: canceled";
            break;
        case MFMailComposeResultSaved:
            //message.text = @"Result: saved";
            break;
        case MFMailComposeResultSent:
            //message.text = @"Result: sent";
            break;
        case MFMailComposeResultFailed:
            //message.text = @"Result: failed";
            break;
        default:
            //    message.text = @"Result: not sent";
            break;
    }
    [vc dismissModalViewControllerAnimated:YES];
}

-(void)displayComposerSheet:(NSString*)body
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.title=@"新邮件";
    picker.mailComposeDelegate = (id)vc;
    //[picker setSubject:@"New Message"];
    //    NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
    //    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //    NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    //    [picker setToRecipients:toRecipients];
    //    [picker setCcRecipients:ccRecipients];   
    //    [picker setBccRecipients:bccRecipients];
    // Attach an image to the email
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
    //  NSData *myData = [NSData dataWithContentsOfFile:path];
    //    [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *date=[[NSDate alloc] init];
    NSString *content=[[NSString alloc]
                       initWithFormat:@"App:1.0.iOS:%@ Date:%@",
                       [[UIDevice currentDevice] systemVersion],[dateFormatter stringFromDate:date]];
    [date release];
    [dateFormatter release];
    [picker setMessageBody:body isHTML:NO];
    [content release];
    [vc presentModalViewController:picker animated:YES];
    [picker release];
}

-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
    NSString *body = @"&body=It is raining in sunny California!";
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

-(void)showEmail:(NSString*)body{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet:body];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}

-(void)dealloc{
    [vc release];
    [super dealloc];
}

@end
