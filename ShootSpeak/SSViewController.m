//
//  SSViewController.m
//  ShootSpeak
//
//  Created by Atsuto on 13/02/16.
//  Copyright (c) 2013年 Atsuto. All rights reserved.
//

#import "SSViewController.h"

@interface SSViewController ()

@end

@implementation SSViewController

@synthesize dataAry;
@synthesize playerAry;

- (IBAction)pushBtn:(id)sender {
    LOG_CURRENT_METHOD;

    for (int i=0; i<[playerAry count]; i++) {
        NSLog(@"hoge");
        //float scrollX = scrollView.contentOffset.x - 320*i;
        [((AVAudioPlayer*)[playerAry objectAtIndex:i]) play];
    }
    
//    AVAudioPlayer *player = [self genPlayer:myText.text];
//    [player play];
    
//    //入力テキストを取得
//    NSString *textInput = myText.text;
//    char *textInputSjis = (char*)[textInput cStringUsingEncoding:NSShiftJISStringEncoding];
//    
//    //テキストを音声記号へ変換
//    char strKoe2[1000];
//	AqKanji2Koe_Convert(m_pAqKanji2Koe, textInputSjis, strKoe2, 1000);
//	
//	//音声ライブラリ確認
//	if(m_pAqTk==0) return;
//	if(AquesTalk2Da_IsPlay(m_pAqTk)){
//		AquesTalk2Da_Stop(m_pAqTk);
//	}
//    
//	//WAV形式の音声データを生成
//    unsigned char *wav;
//    int wavesize;
//    int p_speed = 100;
//    wav = AquesTalk2_Synthe(strKoe2, p_speed, &wavesize, 0);
//    
//    //AVAudioPlayerの初期化と音再生
//    NSError *errPlayer;
//    AVAudioPlayer *player = [AVAudioPlayer alloc];
//    [player initWithData:[NSData dataWithBytes:wav length:wavesize] error:&errPlayer];
//    if (errPlayer) {
//        NSLog(@"AVAudioPlayer初期化失敗:%@\n", errPlayer);
//    }
//    [player prepareToPlay];
//    [player play];
//    
//    //開放
//    AquesTalk2_FreeWave(wav);
}

- (AVAudioPlayer*)genPlayer:(NSString*)text {
    LOG_CURRENT_METHOD;
    //入力テキストを取得
    //NSString *textInput = myText.text;
    char *textInputSjis = (char*)[text cStringUsingEncoding:NSShiftJISStringEncoding];
    
    //テキストを音声記号へ変換
    char strKoe2[1000];
	AqKanji2Koe_Convert(m_pAqKanji2Koe, textInputSjis, strKoe2, 1000);
	
	//音声ライブラリ確認
	if(m_pAqTk==0) return nil;
	if(AquesTalk2Da_IsPlay(m_pAqTk)){
		AquesTalk2Da_Stop(m_pAqTk);
	}
    
	//WAV形式の音声データを生成
    unsigned char *wav;
    int wavesize;
    int p_speed = 100;
    wav = AquesTalk2_Synthe(strKoe2, p_speed, &wavesize, 0);
    
    //AVAudioPlayerの初期化と音再生
    NSError *errPlayer;
    AVAudioPlayer *player = [AVAudioPlayer alloc];
    [player initWithData:[NSData dataWithBytes:wav length:wavesize] error:&errPlayer];
    if (errPlayer) {
        NSLog(@"AVAudioPlayer初期化失敗:%@\n", errPlayer);
    }
    [player prepareToPlay];
    
    //開放
    AquesTalk2_FreeWave(wav);
    return player;
}

- (void)viewDidLoad
{
    LOG_CURRENT_METHOD;
    [super viewDidLoad];
    m_pAqTk = AquesTalk2Da_Create(); // AquesTalk2インスタンス生成
    
    // 言語処理ライブラリのインスタンス生成
    // アプリ直下の/aq_dicフォルダを指定
	NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/aq_dic"];
	const char *dicDir = [path UTF8String];
	NSLog(@"%s", dicDir);
    int iErr;
	m_pAqKanji2Koe = AqKanji2Koe_Create(dicDir, &iErr);
    if (iErr) {
        NSLog(@"NG");
    } else {
        NSLog(@"OK");
    }
    
    //モックデータ
    dataAry = [NSArray arrayWithObjects:
               @"スラスラと問題が解ける子の脳の中は、いつまでたっても答えが出ない子とどう違うのか。「解ける子の脳」になるための秘訣を、脳のスペシャリストに聞いた。スラスラと問題が解ける子の脳の中は、いつまでたっても答えが出ない子とどう違うのか。「解ける子の脳」になるための秘訣を、脳のスペシャリストに聞いた。",
               @"隕石落下で約１２００人の負傷者を出したロシア中部チェリャビンスク州の州都チェリャビンスク市は、１５日深夜から１６日未明にかけて氷点下１５度に達する厳しい寒さに見舞われた。今後１週間の予報では最低気温が氷点下１０度を切る日が続く。隕石落下の衝撃波のため多くの建物で窓ガラスが割れており、市民が寒さで体調を崩すなどの「２次災害」も懸念されている。",
               nil];
    
    playerAry = [[NSMutableArray array] retain];
    for (int i=0; i<[dataAry count]; i++) {
        NSLog(@"foo");
        AVAudioPlayer *player = [self genPlayer:[dataAry objectAtIndex:i]];
        [playerAry addObject:player];
        player.volume = 0;
        [player play];
    }
    NSLog(@"count=%d",[playerAry count]);
    
    //スクロールエリアの作成
    UIScrollView *scrollview = [[[UIScrollView alloc] init] autorelease];
    scrollview.delegate = self;
    scrollview.frame = CGRectMake(0, 100, 320, 100);
    scrollview.contentSize = CGSizeMake(640, 100);
    scrollview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollview];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    LOG_CURRENT_METHOD;
    //[playerAry count];
    NSLog(@"%f, count=%d",scrollView.contentOffset.x,[playerAry count]);
    for (int i=0; i<[playerAry count]; i++) {
        NSLog(@"hoge");
        float scrollX = scrollView.contentOffset.x - 320*i;
        float dist = fabsf(scrollX);
        ((AVAudioPlayer*)[playerAry objectAtIndex:i]).volume = 1-dist/160;
    }
}

- (void)dealloc {
    LOG_CURRENT_METHOD;
	if(m_pAqTk) AquesTalk2Da_Release(m_pAqTk);
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
