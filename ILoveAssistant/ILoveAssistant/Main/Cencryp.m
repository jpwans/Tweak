////#include "StdAfx.h"
//#include "Cencryp.h"
//
//
//
//Cencryp::Cencryp(void)
//{
//}
//
//Cencryp::~Cencryp(void)
//{
//}
//tea 加密 v=8byte数据 k=16位密钥
//void Cencryp::encrypt(unsigned long * v, unsigned long * k)
//{
////	ENCODE_START
//	unsigned long y=v[0], z=v[1], sum=0, i;			/* set up */
//	unsigned long delta=0x9e3779b9;					/* a key schedule constant */
//	unsigned long a=k[0], b=k[1], c=k[2], d=k[3];	/* cache key */
//	for (i=0; i < 32; i++) {						/* basic cycle start */
//		sum += delta;
//		y += ((z<<4) + a) ^ (z + sum) ^ ((z>>5) + b);
//		z += ((y<<4) + c) ^ (y + sum) ^ ((y>>5) + d);/* end cycle */
//	}
//	v[0]=y;
//	v[1]=z;
////	ENCODE_END
//}
////tea 解密 v=8byte数据 k=16位密钥
//void Cencryp::decrypt(unsigned long * v, unsigned long * k)
//{
////	ENCODE_START
//	unsigned long y=v[0], z=v[1], sum=0xC6EF3720, i;	/* set up */
//	unsigned long delta=0x9e3779b9;						/* a key schedule constant */
//	unsigned long a=k[0], b=k[1], c=k[2], d=k[3];		/* cache key */
//	for(i=0; i<32; i++) {								/* basic cycle start */
//		z -= ((y<<4) + c) ^ (y + sum) ^ ((y>>5) + d);
//		y -= ((z<<4) + a) ^ (z + sum) ^ ((z>>5) + b);
//		sum -= delta;									/* end cycle */
//	}
//	v[0]=y;
//	v[1]=z;
////	ENCODE_END
//}
//tea 加密 v=8byte数据 k=16位密钥 (参3必须指定数据的长度 且数据长度必须是8的倍数)
//void Cencryp::encryptLen(unsigned long * v, unsigned long * k,int len)
//{
//
////	ENCODE_START
//	int num=len/8;
//	for(int i=0;i<num;i++)//循环加密 
//	{
//		encrypt(v+(i*2),k);//由于是unsigned long类型所以 每次自动增长2 (2*4=8字节)
//	}
//    UInt8* value = (UInt8*)v;
//    UInt8 key = *(UInt8*)k;
//    for (int i=0; i < len; i++) {
//        value[i] ^= k;
//    }
//    
//	__asm //利用key字符串的第一个byte 对我们的数据再进行一次xor操作
//	{
//		mov eax,k
//		mov	al,[eax]
//		mov esi,v
//		mov	ecx,len
//		mov	ebx,0
//	jm:
//		xor byte ptr [esi+ebx],al
//		inc	ebx
//		loop jm
//	}
//	ENCODE_END
//}
////tea 解密 v=8byte数据 k=16位密钥 (参3必须指定数据的长度 且数据长度必须是8的倍数)
//void Cencryp::decryptLen(unsigned long * v, unsigned long * k,int len)
//{
////	ENCODE_START
////	__asm //利用key字符串的第一个byte 对我们的数据再进行一次xor操作  (记得先还原xor操作 不然就不正确了)
////	{
////		mov eax,k
////		mov	al,[eax]
////		mov esi,v
////		mov	ecx,len
////		mov	ebx,0
////	jm:
////		xor byte ptr [esi+ebx],al
////		inc	ebx
////		loop jm
////	}
//
//	int num=len/8;
//	for(int i=0;i<num;i++)//循环加密 
//	{
//		decrypt(v+(i*2),k);//由于是unsigned long类型所以 每次自动增长2 (2*4=8字节)
//	}
////	ENCODE_END
//}
//
//
////tea 加密 v=8byte数据 k=16位密钥
//void Cencryp::encryptDt(unsigned long * v, unsigned long * k)
//{
////	VM_START
////	__asm
////	{
////		mov eax,4341;
////		mov	al,321;
////		mov	ecx,342;
////		mov	ebx,0;
////	}
////	VM_END
//	unsigned long y=v[0], z=v[1], sum=0, i;			/* set up */
//	unsigned long delta=0x9e3779b9;					/* a key schedule constant */
//	unsigned long a=k[0], b=k[1], c=k[2], d=k[3];	/* cache key */
//	for (i=0; i < 32; i++) {						/* basic cycle start */
//		sum += delta;
//		y += ((z<<4) + a) ^ (z + sum) ^ ((z>>5) + b);
//		z += ((y<<4) + c) ^ (y + sum) ^ ((y>>5) + d);/* end cycle */
//	}
//	v[0]=y;
//	v[1]=z;
//}
////tea 解密 v=8byte数据 k=16位密钥
//void Cencryp::decryptDt(unsigned long * v, unsigned long * k)
//{
////	VM_START
////	__asm
////	{
////		mov eax,4341;
////		mov	al,321;
////		mov	ecx,342;
////		mov	ebx,0;
////	}
////	VM_END
//	unsigned long y=v[0], z=v[1], sum=0xC6EF3720, i;	/* set up */
//	unsigned long delta=0x9e3779b9;						/* a key schedule constant */
//	unsigned long a=k[0], b=k[1], c=k[2], d=k[3];		/* cache key */
//	for(i=0; i<32; i++) {								/* basic cycle start */
//		z -= ((y<<4) + c) ^ (y + sum) ^ ((y>>5) + d);
//		y -= ((z<<4) + a) ^ (z + sum) ^ ((z>>5) + b);
//		sum -= delta;									/* end cycle */
//	}
//	v[0]=y;
//	v[1]=z;
//
//}
////tea 加密 v=8byte数据 k=16位密钥 (参3必须指定数据的长度 且数据长度必须是8的倍数)
//void Cencryp::encryptLenDt(unsigned long * v, unsigned long * k,int len)
//{
//	
////	VM_START
////	__asm
////	{
////		mov eax,4341;
////		mov	al,321;
////		mov	ecx,342;
////		mov	ebx,0;
////	}
////	VM_END
//
//	int num=len/8;
//	for(int i=0;i<num;i++)//循环加密 
//	{
//		encryptDt(v+(i*2),k);//由于是unsigned long类型所以 每次自动增长2 (2*4=8字节)
//	}
//}
////tea 解密 v=8byte数据 k=16位密钥 (参3必须指定数据的长度 且数据长度必须是8的倍数)
//void Cencryp::decryptLenDt(unsigned long * v, unsigned long * k,int len)
//{
////	VM_START
////	__asm
////	{
////		mov eax,4341;
////		mov	al,321;
////		mov	ecx,342;
////		mov	ebx,0;
////	}
////	VM_END
//
//	int num=len/8;
//	for(int i=0;i<num;i++)//循环加密 
//	{
//		decryptDt(v+(i*2),k);//由于是unsigned long类型所以 每次自动增长2 (2*4=8字节)
//	}
//	
//}
//
//void Cencryp::GetRandom(char Random[])//获取16byte随机数
//{
////	VM_START
//
////	srand((unsigned)time(0)); //随机种子
////	
////	DWORD  sts;//用这个代替上面这个是因为上面这个是按秒来计算的，所以不精确
////	__asm
////	{
////		rdtsc;//这是586指令，比GetTickCount更加精确的方法
////		mov	 sts,eax 
////	}
////	int i=0,k=0;
////	while(i<16)
////	{
////		k=rand() &0xff;//随机数
////		if(k!=0)
////		{
////			Random[i]=k;
////			i++;
////		}
////	}
//	/*
//	for(int i=0;i<16;i++)
//	{
//		Random[i] = rand() &0xff;//随机数
//	}*/
//
////	VM_END
//}




