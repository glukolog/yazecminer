package equihash;

use warnings;
use strict;
use blake2b;

sub verify {
	my ($block) = @_;

	length $block == 1487 or die "bad block length ${\length $block}";

	my ($hdr, $solsize, $sol) = unpack 'a140 a3 a1344', $block;

	$solsize eq "\xfd\x40\x05"
		or die "bad solution size ${\unpack 'H*', $solsize}";

	my @sol = map { oct "0b$_" } unpack '(a21)*', unpack 'B*', $sol;
	@sol == 512 or die;

	# indexes are unique
	my %uniq; @uniq{@sol} = (); keys %uniq == 512
		or die "indexes are not unique";

	# indexes are ordered
	for my $step (1..9) {
		my $off = 2**($step-1);
		$sol[$_] < $sol[$_+$off] or die "no order step $step idx $_"
			for map $_*$off*2, 0 .. 2**(9-$step)-1;
	}

	# calculate hashes
	my $blake = blake2b::new (
		hashlen		=> 50,
		personal	=> ('ZcashPoW' . pack 'VV', 200, 9),
	)->update ($hdr);
	@sol = map {
		my $bl = $blake->copy ()->final (pack 'V', $_ / 2);
		length $bl == 50 or die;
		substr $bl, $_ % 2 * 25, 25
	} @sol;

	# hashes xored give zeroes
	for my $step (1..9) {
		@sol = map $sol[$_*2] ^ $sol[$_*2+1], 0 .. @sol/2 - 1;
		unpack ('B' . $step * 20, $_) =~ /^0+\z/
			or die "bad step $step" for @sol;
	}
	@sol == 1 or die;

	# final xor is all zeroes
	$sol[0] =~ /^\x00{25}\z/ or die "bad final";
}

verify (pack 'H*', join '', map /([0-9A-F]+)/ig, $_) for <<BLOCK1,
04000000
6b217cd27dc4e18358013469c314dfe2664355ce604e34cdbe81525f00000000
1993e160b819d4d1c6133a0c4775b2ecdceb612b3360929e5742690fc3cf4b2e
0000000000000000000000000000000000000000000000000000000000000000
3fccdb58
e184001d
00f5cb9a8c
110000000000000000000000000000000000000000000000000000
fd4005
005aef05e4956282f52f7461fcde16b60cb5be8b10010a771c0901e44dd07000
582d83c14916b4ff788b1077e5a0b5c63ed5d22cb1fed757df6a307d1feaaa20
59abd1300eb393648733b109b564c5950170fe4c04073a7195d196fb33a6017f
44d6d3bd5d647ecadc06187574064c4fb0d1aa71bc23bb1930929fabdf9d3d95
144aa318a98dc29cd4cdbaad47be70e61ed6b650ea65c1b355dd34f04765548c
ce90396bf3fe60a00cfe833709d74c8b7f237aa208e98ecad4319ca09a0e3562
ef55079e98bf9f7205f2f2a388d2b09928cb21cf8d73650c6898e863d26942fa
3b75b14cae019b32eccb34e8f48e0fc7fb9398aeb287cebc6a9a16051372b318
9946e2fd87c3a65787fd0f466a103c070b2db28514e8a649cb7ac4c46fb32d02
f6fa1bdf131d16dbf433ab6e12d5e3ec452b6a6a79dd839bd8206f2bcffc470d
9bc54cf36d97e3207f2d9b512a7abfa500ffc9aca7934e7d1b9cc0e2451c09fa
8ca19d28a01f31a4a39fa9ffefa53ef2db31e6d50da6329d2f0c1142942703de
d05504e7434b673182d6a730ff67be13fa30df648a92a0a66ca2225bf37ee180
1634029203024a5c434848a73661d2468bc7fbbe44595f9b030ed5d5fdc2cdba
26db8ac152f11aeb353241ad3cc813d4fd0efdd139d750d84158b94e11f466a9
756e7c3a21a3c9d5577a20fcb245d9c357b67e1f4bf967500254ca5bf102a253
6405d2226c35f76618dddfcd3606dd41531d39682df857513509516f20901e11
0e01086b446f6d9adbc75795011ff0c009b5142a3ea8213764e51f2a5502f901
40768048c8bffb352cbf13c30344dbdf47486af9660575bdc0dbb2d5c560d563
502437a2a05ab41d3fe1a744027b2539ae3a281eab3a06f265b4b6501f4ba48c
81246d3c34dc60b3ce3b9a0f842ab1cff5d769c91c99badf6eba0f0c963a753d
00d39eec89d7660f7fd950c72f8996e203f2d74a8b114bcf6e44c5ed5a9d0ab7
67473d6f01ed06b80f5e00da47bbb284f975f002e2fbf2ad1c5d354c4c7e7f03
03070ece8fd6cac572b140992609c5ff7d91833c18ba2ae645e2afdf481755e5
abc8991a99ca3c57ba195659eeded441a75c87076846d8e009fda48ff0e918d7
9920954a7762fa28d1ef8567f79112dcfdc0691b785b1a1971f549a1f0a46f4a
f412b54452bc7c8009abbb8bbaa331afa78c46a7e9748f01dfa83673453d9063
462fd2373b7921f8326ae8fb73160adb61542f522ed90b68790f7e2e340f473a
39f28dda57d56c33b629bff358199f2fd7f59009c535635dbb7efc0a19b62bb0
5c5b50f16353d4fbc4b3389dcc4e9ada8b2a9926190ed5ef1b56b5062a5831b7
85d175d073371b6bcb0e371e3bcf0a34b4da3de3ca19714e9e04c71c6a279216
1b176f22d81730766d3cfe07e8df1dcb05043aa6bbcd79f13b4a5183c43fe190
62068b98c15b24065c719e47f9955af7503a7ff5da92bbdafa7f076e93d2ed06
7b814143b5a6a6449f4acb501a23a60c97cc1c65122887eda0156cabb5695d64
f23e08160aa96720299cfce95dda852816e23d0992e578fb71225f57755f5f08
811c00b466102921625d3592f8ad14d35c4d24a43911a87bf8978348d126bba6
7e7bf83df3b4858ad2d733fa14d47f7067083236d7f51fbb07319a5cccc6e6d9
acd852949bf08dbf5e70bd274c18544b7a1cd8afa7f34c324af4cd228e936357
e1e426c06a9c00192b71df867325e224c5a8f1ed2cd58e2bd15205d94e9024ca
bb04d794d3ebbd67d59be55d0b3169315e4b9231875826f092465fa1eb821b57
f1135160c5c305bddfd9a2a66835e95b05a26b10300318f7b9121675be87c974
126f101b14e9ae485c391a1cf6fd1197187103036cd1d294a4185f5dc55ed87e
BLOCK1
;

1;