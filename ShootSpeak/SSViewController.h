//
//  SSViewController.h
//  ShootSpeak
//
//  Created by Atsuto on 13/02/16.
//  Copyright (c) 2013年 Atsuto. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AquesTalk2_iPhone.h"
#import <AVFoundation/AVFoundation.h>

#import "AqKanji2Koe.h"

#pragma mark macro
#ifdef DEBUG
#  define LOG(...) NSLog(__VA_ARGS__)
#  define LOG_CURRENT_METHOD NSLog(@"%@/%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#else
#  define LOG(...) ;
#  define LOG_CURRENT_METHOD ;
#endif

@interface SSViewController : UIViewController <UIScrollViewDelegate> {
    H_AQTKDA m_pAqTk;	//AquesTalk2エンジンのインスタンス
    void *m_pAqKanji2Koe;
    IBOutlet UITextField *myText;
    NSArray *dataAry;
    NSMutableArray *playerAry;
}

@property (nonatomic, retain) NSArray *dataAry;
@property (nonatomic, retain) NSMutableArray *playerAry;

- (IBAction)pushBtn:(id)sender;

@end
