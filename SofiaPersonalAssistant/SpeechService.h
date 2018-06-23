//
//  SpeechService.h
//  SofiaPersonalAssistant
//
//  Created by murganandam on 20/06/18.
//  Copyright © 2018 Muruganandam C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "SpeechRecognitionService.h"
@interface SpeechService : NSObject
{
    id<SpeechRecognitionProtocol>SpeechRecoginitionDelegate;
    NSMutableString* textOnScreen;
    DataRecognitionClient* dataClient;
    MicrophoneRecognitionClient* micClient;
    
    
}

-(instancetype)key:(NSString*)keyvalue mode:(SpeechRecognitionMode)modeval  locale:(NSString*)locval delegate:(id <SpeechRecognitionProtocol>)protocol;

@property (nonatomic, readwrite) NSArray*                buttonGroup;
@property (nonatomic, readonly)  bool                    useMicrophone;
@property (nonatomic, readonly)  bool                    wantIntent;
@property (nonatomic, readonly)  SpeechRecognitionMode   mode;

NSString* ConvertSpeechRecoConfidenceEnumToString(Confidence confidence);
NSString* ConvertSpeechErrorToString(int errorCode);
//-(void)myfunction;
-(void)startspeechservice ;
@end
