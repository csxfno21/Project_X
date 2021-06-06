//
//  writeWavHeader.h
//  MAPDemo
//
//  Created by csxfno21 on 13-5-13.
//  Copyright (c) 2013年 csxfno21. All rights reserved.
//

#import <Foundation/Foundation.h>
//wav header//
struct fmt {
	uint16_t wFormatTag;
	uint16_t nChannels;
	uint32_t nSamplesPerSec;
	uint32_t nAvgBytesPerSec;
	uint16_t nBlockAlign;
	uint16_t wBitsPerSample;
} __attribute__((__packed__));

struct WAVE {
	char fmtheader[8];
	uint32_t fmtlen;
} __attribute__((__packed__));

struct RIFF {
	char riffheader[4];
	uint32_t WAVElen;
};

struct data {
	char dataheader[4];
	uint32_t datalen;
};


static inline void fwrite_le16(uint16_t x, FILE *file)
{
//	uint16_t tmp = htole16(x);
	fwrite(&x, sizeof(x), 1, file);
}

static inline void fwrite_le32(uint32_t x, FILE *file)
{
	//uint32_t tmp = htole32(x);
	fwrite(&x, sizeof(x), 1, file);
}
//wav header//
@interface WriteWavHeader : NSObject
- (void) writeHeader:(FILE *)file;
- (void) editHeader:(FILE *)file;
@end
