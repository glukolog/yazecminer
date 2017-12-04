#ifndef EQUIHASH_H
#define EQUIHASH_H

#define WN			96
#define WK			5

typedef struct {
	unsigned char	version[4];
	unsigned char	prevhash[32];
	unsigned char	merkleroot[32];
	unsigned char	reserved[32];
	unsigned char	time[4];
	unsigned char	bits[4];
	unsigned char	nonce[32];
	unsigned char	solsize[1];
	unsigned char	solution[68];
} block_t;

char		*equihash_info (void);
void		step0 (block_t *block);
void		step (int step);	/* 1..WK */
int		solution (void);	/* implemented by caller */

#endif
