//
//  CCDefineColor.h
//  Kingkong_ios
//
//  Created by hello on 2018/9/18.
//  Copyright © 2018年 MC. All rights reserved.
//

#ifndef CCDefineColor_h
#define CCDefineColor_h

// 颜色
#define MCUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define MCUIColorWithRGB(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define MCUIColorLotMain        MCUIColorFromRGB(0xBC5454)
// 项目主色
#define MCUIColorMain           MCUIColorFromRGB(0xfcd92d)
#define MCUIColorBlack          MCUIColorFromRGB(0x333333)
//深灰色
#define MCUIColorGray           MCUIColorFromRGB(0x323232)
//深褐色
#define MCUIColorBrown          MCUIColorFromRGB(0xB79D93)
//中灰色
#define MCUIColorMiddleGray     MCUIColorFromRGB(0x969696)
//浅灰色
#define MCUIColorLightGray      MCUIColorFromRGB(0xf0f0f0)
//浅褐色
#define MCUIColorLighttingBrown MCUIColorFromRGB(0xE0CBC2)

//个人页面tableView底色
#define MCMineTableViewBgColor  [UIColor colorWithRed:((float)((0xE6D4CE & 0xFF0000) >> 16))/255.0 green:((float)((0xE6D4CE & 0xFF00) >> 8))/255.0 blue:((float)(0xE6D4CE & 0xFF))/255.0 alpha:(0.5)]
//个人页面cell底色
#define MCMineTableCellBgColor  MCUIColorFromRGB(0xF3EAE5)

// 输入框的placeHolder颜色
#define MCUIColorPlaceHolder    MCUIColorFromRGB(0xfCACACC)

//红色
#define MCUIColorRed            MCUIColorFromRGB(0xDA1C36)
#define MCUIColorLightRed       MCUIColorFromRGB(0xFDF9F6)

#define MCUIColorGreen          MCUIColorFromRGB(0x55c03f)
#define MCUIColorBlue           MCUIColorFromRGB(0x4a8af4)
// 每个cell下面线的颜色
#define MCUIColorCellLine       MCUIColorFromRGB(0xDADADA)

//白色
#define MCUIColorWhite          MCUIColorFromRGB(0xffffff)

#define MCUIColorGolden         MCUIColorFromRGB(0xD69700)


#endif /* CCDefineColor_h */
