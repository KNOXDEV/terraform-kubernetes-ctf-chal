# Kleptomanic 

> NOTE: this is an example challenge borrowed, with permission, from
> [San Diego CTF 2022](https://github.com/acmucsd/sdctf-2022/tree/main/crypto/hard%20-%20kleptomanic)
> used as a demonstration of the module.

### prompt
An internationally wanted league of bitcoin thieves have finally been tracked down to their internet lair!

They are hiding behind a secure portal that requires guessing seemingly random numbers. After apprehending one of the thieves offline, the authorities were able to get a copy of the source code as well as an apparently secret value...

`5b8c0adce49783789b6995ac0ec3ae87d6005897f0f2ddf47e2acd7b1abd`

Can you help us crack the case? We have no idea how to use this “backdoor number”...

`nc localhost 1337`

### original specification
The title is a reference to the thief aspect, but also the fact that this is a kleptographic backdoor on an Elliptic Curve random number generator with basically the exact same implementation as the NSA's https://en.wikipedia.org/wiki/Dual_EC_DRBG

The backdoor value of d can be used to bruteforce the correct internal state. After which, the numbers can be predicted. Upon correctly guessing, the flag is given.

**flag:** `sdctf{W0W_aR3_y0u_Th3_NSA}`