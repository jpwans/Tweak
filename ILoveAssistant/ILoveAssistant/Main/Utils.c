//
//  Utils.c
//  ILoveAssistant
//
//  Created by MoPellet on 15/9/2.
//
//

#include "Utils.h"
#include "stdlib.h"
  void encrypts(unsigned long * v, unsigned long * k)
{
    
    unsigned long y=v[0], z=v[1], sum=0, i;			/* set up */
    unsigned long delta=0x9e3779b9;					/* a key schedule constant */
    unsigned long a=k[0], b=k[1], c=k[2], d=k[3];	/* cache key */
    for (i=0; i < 32; i++) {						/* basic cycle start */
        sum += delta;
        y += ((z<<4) + a) ^ (z + sum) ^ ((z>>5) + b);
        z += ((y<<4) + c) ^ (y + sum) ^ ((y>>5) + d);/* end cycle */
    }
    v[0]=y;
    v[1]=z;
    
}
//tea 加密 v=8byte数据 k=16位密钥 (参3必须指定数据的长度 且数据长度必须是8的倍数)
   void encryptLen(unsigned long * v, unsigned long * k,int len)
{
    
    //	ENCODE_START
    int num=len/8;
    for(int i=0;i<num;i++)//循环加密
    {
        encrypts(v+(i*2),k);//由于是unsigned long类型所以 每次自动增长2 (2*4=8字节)
    }
    unsigned char* value = (unsigned char*)v;
    unsigned char key = *(unsigned char*)k;
    for (int i=0; i < len; i++) {
        value[i] ^= key;
    }
}



//tea 解密 v=8byte数据 k=16位密钥 (参3必须指定数据的长度 且数据长度必须是8的倍数)
void decryptLen(unsigned long * v, unsigned long * k,int len)
{
    unsigned char* value = (unsigned char*)v;
    unsigned char key = *(unsigned char*)k;
    for (int i=0; i < len; i++) {
        value[i] ^= key;
    }

	int num=len/8;
	for(int i=0;i<num;i++)//循环加密
	{
		decrypt(v+(i*2),k);//由于是unsigned long类型所以 每次自动增长2 (2*4=8字节)
	}
}
//tea 解密 v=8byte数据 k=16位密钥
void  decrypt(unsigned long * v, unsigned long * k)
{
//	ENCODE_START
	unsigned long y=v[0], z=v[1], sum=0xC6EF3720, i;	/* set up */
	unsigned long delta=0x9e3779b9;						/* a key schedule constant */
	unsigned long a=k[0], b=k[1], c=k[2], d=k[3];		/* cache key */
	for(i=0; i<32; i++) {								/* basic cycle start */
		z -= ((y<<4) + c) ^ (y + sum) ^ ((y>>5) + d);
		y -= ((z<<4) + a) ^ (z + sum) ^ ((z>>5) + b);
		sum -= delta;									/* end cycle */
	}
	v[0]=y;
	v[1]=z;
//	ENCODE_END
}


void GetRandom(char Random[])//获取16byte随机数
{
	for(int i=0;i<16;i++)
	{
		Random[i] = rand() &0xff;//随机数  
	}
}

