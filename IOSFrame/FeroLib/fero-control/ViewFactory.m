//
//  ViewFactory.m
//  p2p
//
//  Created by zhangxiuquan on 15/4/22.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "ViewFactory.h"
#import "HelpApi.h"
#import <QuartzCore/QuartzCore.h>
/**
 *单个View的LinearLayoutCell
 */
@interface LCFrame ()
{
    LinearLayout* back;
    LinearLayoutCell *contentCell;
}
@end
@implementation LCFrame



+(LCFrame*)newWithView:(UIView*)v
{
    LCFrame* cell =[LCFrame new];
    [cell setContentView:v];
    return cell;
    
}
-(instancetype)init{
    self = [super init];
    back = [LinearLayout newVertical];
    [self setView:back];
    return self;
}
-(LCFrame*)setContentView:(UIView*)v
{
    
    //back.gravity = GravityMiddleH_MiddleV;
    contentCell =[LinearLayoutCell newWithView:v ];
    [contentCell setUse:true Weight:1];
    [contentCell setWidth:MatchPatrent];
    //[contentCell setHeight:MatchPatrent];
    [back addView:contentCell];
    
    
    return self;
}
-(LinearLayoutCell*)getContentCell
{
    return contentCell;
}
-(UIView*)getContentView
{
    return [contentCell getView];
}
-(UIView*)getBackView
{
    return back;
}
-(LCFrame*)setPLeft:(float)l
{
    [contentCell setMLeft:l];
    return self;
}
-(LCFrame*)setPTop:(float)t
{
    [contentCell setMTop:t];
    return self;
}
-(LCFrame*)setPBottom:(float)b
{
    [contentCell setMBottom:b];
    return self;
}
-(LCFrame*)setPRight:(float)r
{
    [contentCell setMRight:r];
    return self;
}
-(LCFrame*)setPading:(float)p
{
    [self setPLeft:p];
    [self setPTop:p];
    [self setPRight:p];
    [self setPBottom:p];
    return self;
}
-(LCFrame*)setContentGtavity:(int)g{
    [contentCell setGravity:g];
    return self;
}
-(LCFrame*)setLayoutGtavity:(int)g{
    [self setGravity:g];
    return self;
}
-(LinearLayout*)getLinearLayout{
    return (LinearLayout*)[self getView];
}
-(LCFrame*)setLineColor:(int)c Width:(int)w Radius:(CGFloat)r
{
    
    //设置圆角边框
    //    if (l>0||t>0||r>0||b>0) {
    //        if (l==t==r==b) {
    //
    //        }else{
    //            //UIBezierPath *maskPath =
    //            back.layer.cornerRadius = 1;
    //            back.layer.mask.
    //        }
    //    }
    
    if (r>0) {
        back.layer.cornerRadius = r;
        back.layer.masksToBounds = YES;
    }
    //设置边框及边框颜色
    back.layer.borderWidth = w;
    back.layer.borderColor = COLOR(c).CGColor;
    
    return self;
}
@end
@implementation LCLinearLayout
-(instancetype)init{
    self = [super init];
    LinearLayout*lay = [LinearLayout newVertical];
    [self setView:lay];
    return self;
}
+(LCLinearLayout*)newHorizontal{
    LCLinearLayout*lay = [LCLinearLayout new];
    [[lay getLinearLayout] setOrientation:LinearLayoutHorizontal];
    return lay;
}
+(LCLinearLayout*)newVertical{
    LCLinearLayout*lay = [LCLinearLayout new];
    [[lay getLinearLayout] setOrientation:LinearLayoutVertical];
    return lay;
}
-(LCLinearLayout*)addView:(LinearLayoutCell*)v{
    [[self getLinearLayout] addView:v];
    return self;
}
-(LCLinearLayout*)setContentGtavity:(int)g{
    [[self getLinearLayout] setGravity:g];
    return self;
}
-(LCLinearLayout*)setLayoutGtavity:(int)g{
    [self setGravity:g];
    return self;
}
-(LinearLayout*)getLinearLayout{
    return (LinearLayout*)[self getView];
}

@end
@implementation LFLinearLayout

-(id)init{
    self = [super init ];
    LinearLayout * linearLayout = [LinearLayout newVertical];
    [self setContentView:linearLayout];
    return self;
}
-(LinearLayout*)getLinearLayout
{
    return [self getContentView];
}
-(LinearLayout*)addView:(LinearLayoutCell*)v
{
    [[self getLinearLayout] addView:v];
    return self;
}
+(LFLinearLayout*)newHorizontal
{
    LFLinearLayout* lf = [LFLinearLayout new];
    [lf getLinearLayout].orientation = LinearLayoutHorizontal;
    return lf;
}
+(LFLinearLayout*)newVertical
{
    LFLinearLayout* lf = [LFLinearLayout new];
    [lf getLinearLayout].orientation = LinearLayoutVertical;
    return lf;
}

@end
@implementation LCLabel
-(id)init{
    self = [super init ];
    UILabel * label = [UILabel new];
    label.lineBreakMode = UILineBreakModeTailTruncation;
    //[label sizeToFit];
    //
    //[label setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    //[label setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
    
    //压缩时，压缩的约束Priority必须大于1000才能生效，就是说你丫不了。
    [label setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
    
    [label setNumberOfLines:0];
    [self setView:label];
    return self;
}
//
-(LCLabel*)setWeightPriority1
{
    [[self getLabel] setContentCompressionResistancePriority:1 forAxis:UILayoutConstraintAxisHorizontal];
    [[self getLabel] setContentCompressionResistancePriority:1 forAxis:UILayoutConstraintAxisVertical];
    return self;
}
-(LCLabel*)setHorizontalWeightPriority1
{
    [[self getLabel] setContentCompressionResistancePriority:1 forAxis:UILayoutConstraintAxisHorizontal];
    return self;
}
+(LCLabel*)newWithText:(NSString*)text
              FontSize:(float)size
             FontColor:(int)c{
    return [LCLabel newWithText:text FontSize:size FontColor:c BackColor:0 Width:WrapContent Height:WrapContent MarginLeft:0 MarginTop:0 MarginRight:0 MarginBottom:0];
}
+(LCLabel*)newWithText:(NSString*)text
              FontSize:(float)size
             FontColor:(int)c
             BackColor:(int)bc
                 Width:(int)w
                Height:(int)h
            MarginLeft:(float) ml
             MarginTop:(float) mt
           MarginRight:(float) mr
          MarginBottom:(float) mb{
    
    LCLabel*label = [LCLabel new];
    [label setText:text];
    [label setFontSize:size];
    [label setFontColor:c];
    
    [label setWidth:w];
    [label setHeight:h];
    [label setMLeft:ml];
    [label setMTop:mt];
    [label setMBottom:mb];
    [label setMRight:mr];
    return label;
}
-(void)setLineSpacing:(float)lineSpacing{
    _lineSpacing =lineSpacing;
    [self setText:[self getLabel].text];
}
-(LCLabel*)setText:(NSString*)text{
    if(self.lineSpacing==0){
        
        if (useAttributedText) {
             [self getLabel].attributedText=nil;
             useAttributedText=false;
        }
       
        [[self getLabel] setText:text];
    }else{
        [[self getLabel] setText:nil];

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text?text:@""];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:_lineSpacing];//调整行间距
        
        if([self getLabel].textAlignment != NSTextAlignmentLeft){
            [paragraphStyle setAlignment:[self getLabel].textAlignment];
        }
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
        
        [self getLabel].attributedText=attributedString;
        useAttributedText=true;
    }
    return self;
}
-(LCLabel*)setFontSize:(float)size{
    [[self getLabel] setFont:[[self getLabel].font fontWithSize:size]];
    return self;
}
-(LCLabel*)setFontColor:(int)color{
    [[self getLabel] setTextColor:COLOR(color)];
    return self;
}
-(LCLabel*)setLineNum:(int)n{
    [[self getLabel] setNumberOfLines:n];
    return self;
}
-(LCLabel*)setTextAlignment:(NSTextAlignment)ali{
    [[self getLabel] setTextAlignment:ali];
    return self;
}
-(UILabel*)getLabel{
    return  (UILabel*)[self getView];
}
-(LCLabel*)setCanClickWithNormalColor:(int)color PressColor:(int)sColor TextColor:(int)tc{
    [self setNormalColor:color PressColor:sColor];
    [[self getLabel] setTextColor:COLOR(tc)];
    [[self getLabel]setUserInteractionEnabled:YES];
    return self;
}
-(LCLabel*)setCanNotClick:(int)uc TextColor:(int)tc{
    [self setBackColor:uc];
    [[self getLabel] setTextColor:COLOR(tc)];
    [[self getLabel]setUserInteractionEnabled:NO];
    return self;
}


@end

//带外边距的双文本，用于金钱等标签
@implementation LCLabelH2
-(id)init{
    self = [super init ];
    LabelH2 * label = [LabelH2 new];
    label.lineBreakMode = UILineBreakModeTailTruncation;
    //[label sizeToFit];
    //
    //[label setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    //[label setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
    
    //压缩时，压缩的约束Priority必须大于1000才能生效，就是说你丫不了。
    [label setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
    
    [label setNumberOfLines:0];
    [self setView:label];
    return self;
}
-(void)setLineSpace:(float)lineSpace{

     [((LabelH2*)[self getView]) setLineSpace:lineSpace];
   
}
+(LCLabelH2*)newWithLeftSize:(float)ls Color:(int)lc RightSize:(float)rs Color:(int)rc{
    LCLabelH2 *l2 = [LCLabelH2 new];
    [l2 setLeftSize:ls Color:lc RightSize:rs Color:rc];
    return l2;
}
-(LCLabelH2*)setLeftSize:(float)ls Color:(int)lc RightSize:(float)rs Color:(int)rc{
    [((LabelH2*)[self getView]) setLeftSize:ls Color:lc RightSize:rs Color:rc];
    return self;
}
-(LCLabelH2*)setLeftText:(NSString*)ltext Right:(NSString*)rtext{
    [((LabelH2*)[self getView]) setLeftText:ltext Right:rtext];
    return self;
}
-(UILabel*)getLabel{
    return  ((UILabel*)[self getView]);
}
-(LCLabelH2*)setLeftFont:(UIFont *)leftFont Right:(UIFont *)rightFont{
    [((LabelH2*)[self getView]) setLeftFont:leftFont Right:rightFont];
    return self;
}
-(LCLabelH2*)setMoney:(double)money Unit:(NSString*)unit{
    [((LabelH2*)[self getView]) setMoney:money Unit:unit];
    return self;
}
@end

//
@implementation LCLabelH3
-(id)init{
    self = [super init ];
    LabelH3 * label = [LabelH3 new];
    label.lineBreakMode = UILineBreakModeTailTruncation;
    //[label sizeToFit];
    //
    //[label setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    //[label setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
    
    //压缩时，压缩的约束Priority必须大于1000才能生效，就是说你丫不了。
    [label setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
    
    [label setNumberOfLines:0];
    [self setView:label];
    return self;
}
+(LCLabelH3*)newWithSize1:(float)ls1 Color1:(int)lc1 Size2:(float)ls2 Color2:(int)lc2 Size3:(float)ls3 Color3:(int)lc3{
    LCLabelH3*h3 = [LCLabelH3 new];
    [h3 setSize1:ls1 Color1:lc1 Size2:ls2 Color2:lc2 Size3:ls3 Color3:lc3];
    return h3;
}
-(void)setSize1:(float)ls1 Color1:(int)lc1 Size2:(float)ls2 Color2:(int)lc2 Size3:(float)ls3 Color3:(int)lc3{
    [((LabelH3*)[self getView]) setSize1:ls1 Color1:lc1 Size2:ls2 Color2:lc2 Size3:ls3 Color3:lc3];
}
-(void)setText1:(NSString*)t1 Text2:(NSString*)t2 Text3:(NSString*)t3
{
    [((LabelH3*)[self getView]) setText1:t1 Text2:t2 Text3:t3];
}
-(void)setFont1:(UIFont *)f1 Font2:(UIFont *)f2 Font3:(UIFont *)f3{
    [((LabelH3*)[self getView]) setFont1:f1 Font2:f2 Font3:f3];
}
@end


@implementation LFLabel
-(id)init{
    self = [super init ];
    UILabel * label = [UILabel new];
    label.lineBreakMode = UILineBreakModeWordWrap;
    //[label sizeToFit];
    //
   // [label setContentHuggingPriority:250 forAxis:UILayoutConstraintAxisHorizontal];
     //[label setContentHuggingPriority:250 forAxis:UILayoutConstraintAxisVertical];
    
    //压缩时，压缩的约束Priority必须大于1000才能生效，就是说你丫不了。
    [label setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
    
   
    [label setNumberOfLines:0];
    [self setContentView:label];
    return self;
}

+(LFLabel*)newWithText:(NSString*)text
              FontSize:(float)size
             FontColor:(int)c
             BackColor:(int)bc
{
    return [LFLabel newWithText:text FontSize:size FontColor:c   BackColor:bc MarginLeft:0 MarginTop:0 MarginRight:0 MarginBottom:0 PadingLeft:0 PadingTop:0 PadingRight:0 PadingBottom:0 UseWeight:false Weight:0 ];
}

+(LFLabel*)newWithText:(NSString*)text
              FontSize:(float)size
             FontColor:(int)c
             BackColor:(int)bc
            MarginLeft:(float) ml
             MarginTop:(float) mt
           MarginRight:(float) mr
          MarginBottom:(float) mb
            PadingLeft:(float) pl
             PadingTop:(float) pt
           PadingRight:(float) pr
          PadingBottom:(float) pb
             UseWeight:(BOOL) use
                Weight:(float) w
{
    
    LFLabel *  lv = [LFLabel new];
    
    [lv setText:text];
    [lv setFontSize:size];
    [lv setFontColor:COLOR(c)];
    [lv setBackColor:(bc)];
    
    [lv setMLeft:ml ];
    [lv setMRight:mr];
    [lv setMTop:mt];
    [lv setMBottom:mb];
    
    [lv setPLeft:pl];
    [lv setPRight:pr];
    [lv setPTop:pt];
    [lv setPBottom:pb];
    
    [lv setUse:use Weight:w];
    
    return lv;
    
}

-(LFLabel*)setText:(NSString*)text
{
    [((UILabel*)[self getContentView]) setText:text];
    return self;
}
-(LFLabel*)setFontSize:(float)size
{
    UILabel *label = [self getLabel];
    [label setFont: [label.font fontWithSize:size]];
    return self;
}
-(LFLabel*)setFontColor:(UIColor*)color
{
    [((UILabel*)[self getContentView]) setTextColor:color];
    return self;
}
-(LFLabel*)setLineNum:(int)n
{
    [((UILabel*)[self getContentView]) setNumberOfLines:n];
    return self;
}
-(LFLabel*)setTextAlignment:(NSTextAlignment)ali
{
    [((UILabel*)[self getContentView]) setTextAlignment:ali];
    return self;
}
-(UILabel*)getLabel
{
    return [super getContentView];
}

@end
@interface LFTextField()
{
    UITextField*field;
    int maxLenght;
    BOOL isForMoney;
    int intLenght;
    int floatLenght;
    NSString*passwordOpenPath;
    NSString*passwordClosePath;
    LCImage*passwordButton;
    BOOL isPasswordButtonOpen;
    //
    NSString*allowText;
    NSString*allowMatches;
}
@property(nonatomic,weak)UITextField*nextField;
@property(nonatomic,weak)id returnTag;
@property(nonatomic)SEL returnSel;

@end
@implementation LFTextField
-(int)getMaxLenght{
    return maxLenght;
}
-(LFTextField*)setMaxLenght:(int)lenght
{
    maxLenght =lenght;
    [field addTarget:self
              action:@selector(textViewDidChange)
    forControlEvents:UIControlEventEditingChanged];
   return self;
}
- (void)textViewDidChange
{
    NSInteger number = [field.text length];
    UITextRange *selectedRange = [field markedTextRange];
    //获取高亮部分
    UITextPosition *position = [field positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        if (maxLenght > 0 && number>maxLenght) {
            field.text = [field.text substringToIndex:maxLenght];
        }
    }
   
}
-(NSInteger)getRealLength{
    UITextRange *selectedRange = [field markedTextRange];
  UITextPosition *position = [field positionFromPosition:selectedRange.start offset:0];
    
    return field.text.length- [field offsetFromPosition:selectedRange.start toPosition:selectedRange.end];

}
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //初始化的text不考虑
    if(allowText.length>0&&string.length>0){
        for (int i=0; i<string.length; i++) {
            if(![allowText containsString:[string substringWithRange:NSMakeRange(i, 1)]]){
                return false;
            }
        }
    }
    if(allowMatches.length>0&&string.length>0){
        NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allowMatches];
        BOOL isMatch0 = [Test evaluateWithObject:string];
        if(!isMatch0){
            return false;
        }
    }
    
    
    NSMutableString *text = [textField.text mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    UITextRange *selectedRange = [field markedTextRange];
    //获取高亮部分
    UITextPosition *position = [field positionFromPosition:selectedRange.start offset:0];
    BOOL isPosition= (position!=nil);
//
    return string.length==0|| isPosition||([text length] <= maxLenght)&&
            (isForMoney==false || [self isMomeny:textField shouldChangeCharactersInRange:range replacementString:string]);
}
//按下Done按钮的调用方法，我们让键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(field.returnKeyType == UIReturnKeyNext&&self.nextField){
        [self.nextField becomeFirstResponder];
       return YES;
    }
    if(self.returnTag){
        [self.returnTag performSelector:self.returnSel withObject:self];
        return YES;
    }
    [field resignFirstResponder];
    return YES;
}
-(id)init{
    self = [super init];
    field =[UITextField new];
    [self setContentView:field];
    field.returnKeyType = UIReturnKeyDone;
    [field setClearButtonMode:UITextFieldViewModeWhileEditing];
    field.delegate=self;
    self.nextField=nil;
    maxLenght=NSIntegerMax;
    return self;
}
+(LFTextField*)newWithHit:(NSString*)text
                 FontSize:(float)size
                FontColor:(int)c
                BackColor:(int)bc
{
    LFTextField* f =[LFTextField new];
    [f setHitText:text];
    [f setFontSize:size];
    [f setFontColor:COLOR(c)];
    [f setBackColor:bc];
    return f;
}

-(LFTextField*)setText:(NSString*)text{
    [field setText:text];
    
    return self ;
}
-(LFTextField*)setFontSize:(float)size{
    [field setFont:[field.font fontWithSize:size ]];
    return self ;
}
-(LFTextField*)setFontColor:(UIColor*)color{
    [field setTextColor:color];
    return self ;
}
-(LFTextField*)setHitText:(NSString*)text{
    [field setPlaceholder:text];
     return self ;
}
-(LFTextField*)setHitFontSize:(float)size{
    UIFont*font =[field valueForKeyPath:@"_placeholderLabel.font"];
    [field setValue:[font fontWithSize:size ] forKeyPath:@"_placeholderLabel.font"];
     return self ;
}
-(LFTextField*)setHitFontColor:(UIColor*)color{

    [field setValue:color forKeyPath:@"_placeholderLabel.textColor"];
     return self ;
}
-(LFTextField*)setTextAlignment:(NSTextAlignment)ali{
    [field setTextAlignment:ali];
     return self ;
}
-(NSString*)getText{

     return field.text ;
}
-(UITextField*)getTextView{
     return field ;
}
-(LFTextField*)setForPassword{
    field.secureTextEntry = YES;
     return self ;
}
-(void)onClickPButton{
    [self setPasswordButtonOpen:!isPasswordButtonOpen];
}
-(LFTextField*)setPasswordButtonOpen:(BOOL)isopen
{
    isPasswordButtonOpen=isopen;
    
    NSString*str =  [self getText];
 
    field.text=@"";
    field.secureTextEntry = !isPasswordButtonOpen;
    field.text=str;
    [passwordButton setUrl:isPasswordButtonOpen?passwordOpenPath:passwordClosePath];
    
    return self;
}
-(LFTextField*)showPasswordButtonOpen:(NSString*)path1 Colos:(NSString*)path2{
    if(passwordButton==nil){
        passwordOpenPath =path1;
        passwordClosePath =path2;
        passwordButton = [LCImage newWithUrl:nil Width:24 Height:MatchPatrent];
        [passwordButton setMLeft:5];
        [passwordButton setMRight:[self getContentCell].marginRight];
        [[self getContentCell] setMRight:0];
        [[self getLinearLayout] setOrientation:LinearLayoutHorizontal];
        [[self getContentCell] setUse:true Weight:1];
        [[self getContentCell] setHeight:MatchPatrent];
        [[self getLinearLayout] addView:passwordButton];
        [passwordButton setOnClickTarget:self action:@selector(onClickPButton)];
        [self setPasswordButtonOpen:false];
    }
    [passwordButton setVisibleVisibel];
    return self ;
}
-(LCImage*)getPasswordButton{
    return passwordButton;
}

-(LFTextField*)setReturnForNext:(UITextField *)textField
{
    self.nextField=textField;
    field.returnKeyType = UIReturnKeyNext;
    return self;
}
-(LFTextField*)setOnReturnType:(UIReturnKeyType)type Tag:(id)tag Act:(SEL)sel
{
    field.returnKeyType = type;
    self.returnTag=tag;
    self.returnSel=sel;
    return self;
}
-(LFTextField*)setForNumberInt:(int)lenght Float:(int)fLenght
{
    [self getTextView].keyboardType = UIKeyboardTypeDecimalPad;
    isForMoney = true;
    intLenght = lenght;
    floatLenght =fLenght;
    return self;
}
-(LFTextField*)setForInputMoneyIntLenght:(int)lenght
{
    return [self setForNumberInt:lenght Float:2];
}
- (BOOL)isMomeny:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //两位小数限制
    NSMutableString *text = [[self getText] mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    NSArray *arr =  [text componentsSeparatedByString:@"."];
    if([arr count]==0){
        return true;
    }
    if([text hasPrefix:@"00"]){
        return false;
    }
    if([text hasPrefix:@"."]){
        return false;
    }
    //多个小数点错误
    if([arr count]>2){
        return false;
    }
    //
    NSRange r;
    for (int i = 0;i<text.length; i++) {
        r.length = 1;
        r.location=i;
        NSString* c =[text substringWithRange:r];
        if (![@"0123456789." containsString:c]) {
            return false;
        }
    }
    if([arr count]==1){
        if(intLenght>0&&[(NSString*)arr[0] length]>intLenght){
            return false;
        }
    }
    
    if([arr count]==2&&floatLenght>0){
        if(intLenght>0&&[(NSString*)arr[0] length]>intLenght){
            return false;
        }
        if(floatLenght>0&&[(NSString*)arr[1] length]>floatLenght){
            return false;
        }
    }
    
    if([arr count]>=2&&floatLenght==0){
        return false;
    }
    
    return true;
}
-(LFTextField*)setOnChangeTarget:(nullable id)target action:(SEL)action{
    [field addTarget:target
              action:action
    forControlEvents:UIControlEventEditingChanged];
    return self;
}
//设置允许输入的文本
-(LFTextField*)setAllowText:(NSString*)text{
    allowText=text;
    return self;
}
//设置允许输入的正则匹配
-(LFTextField*)setAllowMatches:(NSString*)matches{
    allowMatches =matches;
    return self;
}
@end


@interface UITextViewForWrapContent:UITextView<UITextViewDelegate>
{
    int maxLenght;
    __weak id tag;
    SEL act;
}
@property(nonatomic) UILabel*hitLabel;
-(void)setHintText:(NSString*)hitStr;
-(void)setHintFontSize:(float)size;
-(void)setMaxLength:(int)l;
-(void)setOnChangeTarget:(nullable id)target action:(SEL)action;
@end
@implementation UITextViewForWrapContent
-(void)setMaxLength:(int)length
{
    maxLenght = length;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string
{
    NSMutableString *text = [textView.text mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    return [text length] <= maxLenght;
}

-(id)init{
    self = [super init];
    //[self createHitView];
    maxLenght=NSIntegerMax;
    self.delegate=self;
    return self;
}
-(void)createHitView{
    
        self.hitLabel =[UILabel new];
        [self.hitLabel setTextColor:COLOR(0XFF888888)];
        [self.hitLabel setTranslatesAutoresizingMaskIntoConstraints:FALSE];
        [self addSubview:self.hitLabel];
        //X位置
        [self addConstraint:[NSLayoutConstraint
                                         constraintWithItem:self.hitLabel
                                         attribute:NSLayoutAttributeCenterX
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                         attribute:NSLayoutAttributeCenterX
                                         multiplier:1
                                         constant:0]];
    
        //宽度
        [self addConstraint:[NSLayoutConstraint
                                         constraintWithItem:self.hitLabel
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                         attribute:NSLayoutAttributeWidth
                                         multiplier:1
                                         constant:0]];
    
    
    
        //Y位置
        [self addConstraint:[NSLayoutConstraint
                                         constraintWithItem:self.hitLabel
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                         attribute:NSLayoutAttributeTop
                                         multiplier:1
                                         constant:0]];
    
        //高度
        [self setViewHeight:self.hitLabel h:self.font.lineHeight];
    
    
    
  
}
-(void)setText:(NSString *)text{
    [super setText:text];
    if ([self.text length]>0) {
        [self.hitLabel setVisible:AutoLayoutVisibleHideHeight];
    }else{
        [self.hitLabel setVisible:AutoLayoutVisibleShow];
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger number = [textView.text length];
    if (maxLenght > 0 && number>maxLenght) {
        textView.text = [textView.text substringToIndex:maxLenght];
    }
    
    if (tag) {
        [tag performSelector:act withObject:self];
    }
    if ([textView.text length]>0) {
        [self.hitLabel setVisible:AutoLayoutVisibleHideHeight];
    }else{
        [self.hitLabel setVisible:AutoLayoutVisibleShow];
    }
  
}
-(void)setOnChangeTarget:(nullable id)target action:(SEL)action
{
    tag = target;
    act = action;
}

-(void)setHintText:(NSString*)hit{
    [self.hitLabel setText:hit];
}
-(void)setHintFontSize:(float)size{
    [self.hitLabel setFont:[UIFont systemFontOfSize:size ]];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    float needHeight=[self contentSize].height;
    
    if (needHeight==0) {
        needHeight = self.font.lineHeight;
    }
    [self setViewHeight:self h:needHeight];
 
}
-(void)setViewHeight:(UIView*)view h:(float)needHeight{
    if (view==nil) {
        return;
    }
    NSLayoutConstraint * c = [self getH_NSLayoutConstraint:view];
    if (c==nil) {
        c = [self newH_NSLayoutConstraint:view];
        c.constant =needHeight;
        [self addConstraint:c];
    }
    
    if (c.constant != needHeight) {
        [self removeConstraint:c];
        c.constant =needHeight;
        [self addConstraint:c];
        [self setNeedsLayout];
    }
}
-(NSLayoutConstraint*)getH_NSLayoutConstraint:(UIView*)view{
    NSArray*arr =  [self constraints];
    for (int i=0;i<arr.count; i++) {
        NSLayoutConstraint * c =[arr objectAtIndex:i];
        if (c.firstItem==view &&
            c.secondItem==nil&&
            c.priority==757 &&
            c.firstAttribute==NSLayoutAttributeHeight) {
            
            return c;
        }
    }
    return nil;
}

-(NSLayoutConstraint*)newH_NSLayoutConstraint:(UIView*)view{
    
    NSLayoutConstraint * c = [NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:0
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:NSLayoutAttributeNotAnAttribute
                                                           constant:0];
    c.priority=757;
    return c;
}

@end

@interface LFEditText()
{
    UILabel*hitLabel;

}
@end
@implementation LFEditText
-(LFEditText*)setMaxLenght:(int)lenght
{
    UITextViewForWrapContent*c =[ self getTextView];
    [c setMaxLength:lenght];
    return self;
}
-(id)init{
    self = [super init ];
    UITextViewForWrapContent * label = [UITextViewForWrapContent new];
    //label.lineBreakMode = UILineBreakModeWordWrap;
    //[label setNumberOfLines:0];
    label.autocorrectionType = UITextAutocorrectionTypeNo;
    label.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self setContentView:label];
    [self createHitView];
    label.hitLabel=hitLabel;
    //去掉边距
    [label setContentInset:UIEdgeInsetsMake(-7, -4, -7, -4)];
    return self;
}
-(void )createHitView{
    
    hitLabel =[UILabel new];
    [hitLabel setTextColor:COLOR(0XFF888888)];
    hitLabel.numberOfLines=0;
    [hitLabel setTranslatesAutoresizingMaskIntoConstraints:FALSE];
    UIView *back = [self getBackView];
    UITextView * label = [self getTextView];
    [back addSubview:hitLabel];
    //X位置
    [back addConstraint:[NSLayoutConstraint
                         constraintWithItem:hitLabel
                         attribute:NSLayoutAttributeLeft
                         relatedBy:NSLayoutRelationEqual
                         toItem:label
                         attribute:NSLayoutAttributeLeft
                         multiplier:1
                         constant:1]];
    
    //宽度
    [back addConstraint:[NSLayoutConstraint
                         constraintWithItem:hitLabel
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationEqual
                         toItem:label
                         attribute:NSLayoutAttributeWidth
                         multiplier:1
                         constant:-2]];
    
    
    
    //Y位置
    [back addConstraint:[NSLayoutConstraint
                         constraintWithItem:hitLabel
                         attribute:NSLayoutAttributeTop
                         relatedBy:NSLayoutRelationEqual
                         toItem:label
                         attribute:NSLayoutAttributeTop
                         multiplier:1
                         constant:0]];
    
    //高度
//    [back addConstraintBig:[NSLayoutConstraint
//                         constraintWithItem:hitLabel
//                         attribute:NSLayoutAttributeHeight
//                         relatedBy:NSLayoutRelationEqual
//                         toItem:label
//                         attribute:NSLayoutAttributeHeight
//                         multiplier:1
//                         constant:0]];
  
}
+(LFEditText*)newWithHit:(NSString*)text
                FontSize:(float)size
               FontColor:(int)c
               BackColor:(int)bc
{
    
    LFEditText *  lv = [LFEditText new];
    
    [lv setHitText:text];
    [lv setFontSize:size];
    [lv setFontColor:COLOR(c)];
    [lv setBackColor:(bc)];
    
    
    
    return lv;
    
}

-(LFEditText*)setText:(NSString*)text
{
    [((UITextView*)[self getContentView]) setText:text];
    return self;
}
-(LFEditText*)setFontSize:(float)size
{
    [((UITextView*)[self getContentView]) setFont:[UIFont systemFontOfSize:size ]];
    [self setHitFontSize:size];
    return self;
}
-(LFEditText*)setFontColor:(UIColor*)color
{
    [((UITextView*)[self getContentView]) setTextColor:color];
    return self;
}
-(LFEditText*)setHitText:(NSString*)text
{
    [hitLabel setText:text];
    [((UITextViewForWrapContent*)[self getContentView]) setHintText:text];
    return self;
}
-(LFEditText*)setHitFontSize:(float)size
{
    [((UITextViewForWrapContent*)[self getContentView]) setHintFontSize:size];
    return self;
}
-(LFEditText*)setHitFontColor:(UIColor*)color
{
    [((UITextViewForWrapContent*)[self getContentView]).hitLabel setTextColor:color];
    return self;
}
-(LFEditText*)setLineNum:(int)n
{
    
    return self;
}
-(LFEditText*)setTextAlignment:(NSTextAlignment)ali
{
    [((UITextView*)[self getContentView]) setTextAlignment:ali];
    [hitLabel setTextAlignment:ali];
    return self;
}
-(UITextView*)getTextView
{
    return [super getContentView];
}
-(void)setOnChangeTarget:(nullable id)target action:(SEL)action
{
    [(UITextViewForWrapContent*)[self getTextView] setOnChangeTarget:target action:action];
}
-(NSString*)getText
{
    return [self getTextView].text;
}
//保护高度问题
-(LCFrame*)setHeight:(float)h{
    [super setHeight:h];
    [self chackHeight];
    return self;
}
-(LCFrame*)setPTop:(float)t
{
    [super setPTop:t];
    [self chackHeight];
    return self;
}
-(LCFrame*)setPBottom:(float)b
{
    [super setPBottom:b];
    [self chackHeight];
    return self;
}
-(void)chackHeight{
    if([self getHeight]<0){
        [[self getContentCell] setHeight:[self getHeight]];
    }else{
        int h = [self getHeight] -[self getContentCell].marginTop  -[self getContentCell].marginBottom ;
        
        if(h<0){
            h = [self getHeight];
        }
        [[self getContentCell] setHeight:h];
    }
}
@end

@implementation LCImage
-(id)init{
    self = [super init ];
    UIImageView * image = [UIImageView new];
    [image setContentMode:UIViewContentModeScaleAspectFit];
    [image setClipsToBounds:true];
    
    //[image setContentHuggingPriority:1 forAxis:UILayoutConstraintAxisHorizontal];
    //[image setContentHuggingPriority:1 forAxis:UILayoutConstraintAxisVertical];
    
    //压缩时，压缩的约束Priority必须大于1000才能生效，就是说你丫不了。
    [image setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
    [image setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisVertical];
    
    
    [self setView:image];
    return self;
}
+(LCImage*)newWithHolder:(NSString*)path
                   Width:(float)w
                  Height:(float)h{
    LCImage*image = [LCImage newWithUrl:nil Width:w Height:h];
    [image setHolderPath:path];
    [image setUrl:path];
    return image;
}
+(LCImage*)newWithUrl:(NSString*)path
                Width:(float)w
               Height:(float)h{
    return [LCImage newWithUrl:path Width:w Height:h Mode:UIViewContentModeScaleAspectFit MarginLeft:0 MarginTop:0 MarginRight:0 MarginBottom:0 PadingLeft:0 PadingTop:0 PadingRight:0 PadingBottom:0 UseWeight:false Weight:0];
}
+(LCImage*)newWithUrl:(NSString*)path
                Width:(float)w
               Height:(float)h
                 Mode:(UIViewContentMode)mode
           MarginLeft:(float) ml
            MarginTop:(float) mt
          MarginRight:(float) mr
         MarginBottom:(float) mb
           PadingLeft:(float) pl
            PadingTop:(float) pt
          PadingRight:(float) pr
         PadingBottom:(float) pb
            UseWeight:(BOOL) use
               Weight:(float) weight{
    LCImage * image = [LCImage new];
    [image setUrl:path];
    [image setMode:mode];
    [image setWidth:w];
    [image setHeight:h];
    
    
    [image setMLeft:ml ];
    [image setMRight:mr];
    [image setMTop:mt];
    [image setMBottom:mb];
    
    [image setPLeft:pl];
    [image setPRight:pr];
    [image setPTop:pt];
    [image setPBottom:pb];
    
    [image setUse:use Weight:weight];
    
    return image;

}
-(LCImage*)setUrl:(NSString*)path Holder:(NSString*)holder{
    _holderPath = holder;
    [self setUrl:path];
    return self;
}
-(LCImage*)setUrl:(NSString*)path{
    if (path.length==0) {
        path=_holderPath;
    }


    if([path hasPrefix:@"file://"]){
        NSString * p = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        
        NSString*name = [path substringFromIndex:@"file://".length];
        path=[p  stringByAppendingPathComponent:name];
       
    }
    
    if ([path hasPrefix:@"http://"] || [path hasPrefix:@"https://"]) {
        [[self getImageView] sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:_holderPath]];
    }else{
        [[self getImageView] setImage:[UIImage imageNamed:path]];
    }
    
    return self;
}
-(LCImage*)setMode:(UIViewContentMode)mod{
    [[self getImageView] setContentMode:mod];
    return self;
}
-(UIImageView*)getImageView{
    return [self getView];
}
@end
@implementation LFImage
-(id)init{
    self = [super init ];
    UIImageView * image = [UIImageView new];
    [image setContentMode:UIViewContentModeScaleAspectFit];
    [image setClipsToBounds:true];
    
    //[image setContentHuggingPriority:1 forAxis:UILayoutConstraintAxisHorizontal];
    //[image setContentHuggingPriority:1 forAxis:UILayoutConstraintAxisVertical];
    
    //压缩时，压缩的约束Priority必须大于1000才能生效，就是说你丫不了。
    [image setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
    [image setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisVertical];
    
    
    [self setContentView:image];
    return self;
}

+(LFImage*)newWithUrl:(NSString*)path
                Width:(float)w
               Height:(float)h
{
    
    return [LFImage newWithUrl:path Width:w Height:h Mode:UIViewContentModeScaleAspectFit MarginLeft:0 MarginTop:0 MarginRight:0 MarginBottom:0 PadingLeft:0 PadingTop:0 PadingRight:0 PadingBottom:0 UseWeight:false Weight:0];
}
+(LFImage*)newWithUrl:(NSString*)path
                Width:(float)w
               Height:(float)h
                 Mode:(UIViewContentMode)mode
           MarginLeft:(float) ml
            MarginTop:(float) mt
          MarginRight:(float) mr
         MarginBottom:(float) mb
           PadingLeft:(float) pl
            PadingTop:(float) pt
          PadingRight:(float) pr
         PadingBottom:(float) pb
            UseWeight:(BOOL) use
               Weight:(float) weight
{
    LFImage * image = [LFImage new];
    [image setUrl:path];
    [image setMode:mode];
    [image setWidth:w];
    [image setHeight:h];
    
    
    [image setMLeft:ml ];
    [image setMRight:mr];
    [image setMTop:mt];
    [image setMBottom:mb];
    
    [image setPLeft:pl];
    [image setPRight:pr];
    [image setPTop:pt];
    [image setPBottom:pb];
    
    [image setUse:use Weight:weight];
    
    return image;
}

-(LFImage*)setUrl:(NSString*)path
{
    if([path hasPrefix:@"file://"]){
        NSString * p = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString*name = [path substringFromIndex:@"file://".length];
        path = [NSString stringWithFormat:@"%@%@",p,name];
    }
    
    if ([path hasPrefix:@"http://"] || [path hasPrefix:@"https://"]) {
        [[self getImageView] sd_setImageWithURL:[NSURL URLWithString:path]];
    }else{
        [[self getImageView] setImage:[UIImage imageNamed:path]];
    }
    
    return self;
}
-(LFImage*)setMode:(UIViewContentMode)mod
{
    [((UIImageView*)[self getContentView]) setContentMode:mod];
    return self;
}
-(UIImageView*)getImageView
{
    return [super getContentView];
}
@end
@implementation LCLine

//竖直方向的line
+(LCLine*)newWidth1Color:(int)lineColor{
    return [LCLine newVWith:lineColor];
}
//水平方向的line
+(LCLine*)newHeight1Color:(int)lineColor{
    return [LCLine newHWith:lineColor];
}


//竖直方向的line
+(LCLine*)newVWith:(int)lineColor{
    float onePx = 1.0/[UIScreen mainScreen].scale+0.00000001;
    XLine*line = [XLine newWithWidth:onePx :COLOR(lineColor)];
    [line setOnCenter:true];
    LCLine*lc =[LCLine new];
    [lc setView:line];
    [lc setHeight:MatchPatrent];
    [lc setWidth:onePx];
    return lc;
}
//水平方向的line
+(LCLine*)newHWith:(int)lineColor{
    float onePx = 1.0/[UIScreen mainScreen].scale+0.00000001;
    XLine*line = [XLine newWithHeight:onePx :COLOR(lineColor)];
    [line setOnCenter:true];
    LCLine*lc =[LCLine new];
    [lc setView:line];
    [lc setWidth:MatchPatrent];
    [lc setHeight:onePx];
    return lc;
}
-(XLine*)getLine{
    return (XLine*)[self getView];
}
@end

@implementation ViewFactory





@end
