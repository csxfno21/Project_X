//
//  writeWavHeader.m
//  MAPDemo
//
//  Created by csxfno21 on 13-5-13.
//  Copyright (c) 2013年 szmap. All rights reserved.
//

#import "WriteWavHeader.h"

@implementation WriteWavHeader

- (void) writeHeader:(FILE *)file
{
    
    struct fmt format = {
		.wFormatTag = 1,/* PCM = 1 (i.e. Linear quantization) */
		.nChannels = 1, /* Mono = 1, Stereo = 2, etc. */
		.nSamplesPerSec = 16000,
		.nAvgBytesPerSec = 16000 * 1 * 16 / 8, /* == SampleRate * NumChannels * BitsPerSample/8 */
		.wBitsPerSample = 16,
		.nBlockAlign = 1 * 16 / 8, /* BlockAlign       == NumChannels * BitsPerSample/8*/
	};
    
    struct RIFF r = {
		{ 'R','I','F','F' } ,
		0
	};
    
	struct WAVE w = {
		{ 'W','A','V','E','f','m','t',' ' },
		0
	};
    
	struct data d = {
		{ 'd','a','t','a' },
		0
	};
    
	w.fmtlen = sizeof(format);
	r.WAVElen = sizeof(w) + w.fmtlen + sizeof(d);
	d.datalen = 913000;
   
	/* RIFF */
	fwrite(&r.riffheader, 1, 4, file);
	fwrite_le32(r.WAVElen, file);
    
	/* WAVE */
	fwrite(&w.fmtheader, 1, 8, file);
	fwrite_le32(w.fmtlen, file);
    
	/* fmt */
	fwrite_le16(format.wFormatTag, file);
	fwrite_le16(format.nChannels, file);
	fwrite_le32(format.nSamplesPerSec, file);
	fwrite_le32(format.nAvgBytesPerSec, file);
	fwrite_le16(format.nBlockAlign, file);
	fwrite_le16(format.wBitsPerSample, file);
    
	/* data */
	fwrite(&d.dataheader, 1, 4, file);
	fwrite_le32(d.datalen, file);
}

- (void) editHeader:(FILE *)file{
    uint32_t filePosition = ftell(file);
    uint32_t Subchunk2Size = filePosition - 44;
    uint32_t ChunkSize = Subchunk2Size + 36;
    fseek(file, 4, SEEK_SET);
    fwrite_le32(ChunkSize, file);
    fseek(file, 40, SEEK_SET);
    fwrite_le32(Subchunk2Size, file);
    fflush(file);
}

@end
