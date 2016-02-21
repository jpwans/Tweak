//
//  Utils.h
//  ILoveAssistant
//
//  Created by MoPellet on 15/9/2.
//
//

#ifndef __ILoveAssistant__Utils__
#define __ILoveAssistant__Utils__

#include <stdio.h>
	  void GetRandom(char Random[]);//获取16byte随机数
	  void encrypts(unsigned long * v, unsigned long * k);//tea 加密 v=8byte数据 k=16位密钥
	  void decrypt(unsigned long * v, unsigned long * k);//tea 解密 v=8byte数据 k=16位密钥
	  void encryptLen(unsigned long * v, unsigned long * k,int len);//tea 加密 v=8byte数据 k=16位密钥 (参3必须指定数据的长度 且数据长度必须是8的倍数)
	  void decryptLen(unsigned long * v, unsigned long * k,int len);//tea 解密 v=8byte数据 k=16位密钥 (参3必须指定数据的长度 且数据长度必须是8的倍数)
	//以下是答题相当的


#endif /* defined(__ILoveAssistant__Utils__) */
