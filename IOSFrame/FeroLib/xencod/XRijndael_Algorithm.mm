 /* XRijndael_Algorithm.mm
 * Compile with: g++ -x objective-c++ -framework Foundation XRijndael_Algorithm.mm  -o XRijndael_Algorithm 
 */


#import "XRijndael_Algorithm.h"


//$Id: Rijndael_Algorithm.java,v 1.1 2001/05/21 02:24:30 jis Exp $
//
// $Log: Rijndael_Algorithm.java,v $
// Revision 1.1  2001/05/21 02:24:30  jis
// First version
//
// Revision 1.1  1998/04/12  Paulo
// + optimized methods for the default 128-bit block size.
//
// Revision 1.0  1998/03/11  Raif
// + original version.
//
// $Endlog$
/*
 * Copyright (c) 1997, 1998 Systemics Ltd on behalf of
 * the Cryptix Development Team. All rights reserved.
 */


// ...........................................................................
/**
 * Rijndael --pronounced Reindaal-- is a variable block-size (128-, 192- and
 * 256-bit), variable key-size (128-, 192- and 256-bit) symmetric cipher.
 * <p>
 *
 * Rijndael was written by <a href="mailto:rijmen@esat.kuleuven.ac.be">Vincent
 * Rijmen</a> and <a href="mailto:Joan.Daemen@village.uunet.be">Joan Daemen</a>.
 * <p>
 *
 * Portions of this code are <b>Copyright</b> &copy; 1997, 1998 <a
 * href="http://www.systemics.com/">Systemics Ltd</a> on behalf of the <a
 * href="http://www.systemics.com/docs/cryptix/">Cryptix Development Team</a>.
 * <br>
 * All rights reserved.
 * <p>
 *
 * <b>$Revision: 1.1 $</b>
 *
 * @author Raif S. Naffah
 * @author Paulo S. L. M. Barreto
 */



    // Constants and variables
    // ...........................................................................
    
     int BLOCK_SIZE = 16; // default block size in bytes
    
    int * alog = new int[256]{0};

     int * olog = new int[256]{0};
    
     Byte* S = new Byte[256]{0};
    
     Byte* Si = new Byte[256]{0};
    
     int* T1 = new int[256]{0};
    
     int* T2 = new int[256]{0};
    
     int* T3 = new int[256]{0};
    
     int* T4 = new int[256]{0};
    
     int* T5 = new int[256]{0};
    
     int* T6 = new int[256]{0};
    
     int* T7 = new int[256]{0};
    
     int* T8 = new int[256]{0};
    
     int* U1 = new int[256]{0};
    
     int* U2 = new int[256]{0};
    
     int* U3 = new int[256]{0};
    
     int* U4 = new int[256]{0};

     Byte* rcon = new Byte[30]{0};
    
     int shifts [3][4][2] = {
        { { 0, 0 }, { 1, 3 }, { 2, 2 }, { 3, 1 } },
        { { 0, 0 }, { 1, 5 }, { 2, 4 }, { 3, 3 } },
        { { 0, 0 }, { 1, 7 }, { 3, 5 }, { 4, 4 } } };
    
    char HEX_DIGITS[] = { '0', '1', '2', '3', '4', '5',
        '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
    
    // Static code - to intialise S-boxes and T-boxes
    // ...........................................................................
    
    int staticFun()
    {
        //long time = [[NSDate date] timeIntervalSince1970];
        
 
        int ROOT = 0x11B;
        int i, j = 0;
        
        //
        // produce log and alog tables, needed for multiplying in the
        // field GF(2^m) (generator = 3)
        //
        alog[0] = 1;
        for (i = 1; i < 256; i++) {
            j = (alog[i - 1] << 1) ^ alog[i - 1];
            if ((j & 0x100) != 0)
                j ^= ROOT;
            alog[i] = j;
        }
        for (i = 1; i < 255; i++)
            olog[alog[i]] = i;
        Byte A [8][8]= { { 1, 1, 1, 1, 1, 0, 0, 0 },
            { 0, 1, 1, 1, 1, 1, 0, 0 }, { 0, 0, 1, 1, 1, 1, 1, 0 },
            { 0, 0, 0, 1, 1, 1, 1, 1 }, { 1, 0, 0, 0, 1, 1, 1, 1 },
            { 1, 1, 0, 0, 0, 1, 1, 1 }, { 1, 1, 1, 0, 0, 0, 1, 1 },
            { 1, 1, 1, 1, 0, 0, 0, 1 } };
        Byte B [8] =  { 0, 1, 1, 0, 0, 0, 1, 1 };
        
        //
        // substitution box based on F^{-1}(x)
        //
        int t;
        Byte box[256][8] = {};
        
        box[1][7] = 1;
        for (i = 2; i < 256; i++) {
            j = alog[255 - olog[i]];
            for (t = 0; t < 8; t++)
                box[i][t] = (Byte) ((j >> (7 - t)) & 0x01);
        }
        //
        // affine transform: box[i] <- B + A*box[i]
        //
        Byte cox[256][8] = {};
        for (i = 0; i < 256; i++)
            for (t = 0; t < 8; t++) {
                cox[i][t] = B[t];
                for (j = 0; j < 8; j++)
                    cox[i][t] ^= A[t][j] * box[i][j];
            }
        //
        // S-boxes and inverse S-boxes
        //
        for (i = 0; i < 256; i++) {
            S[i] = (Byte) (cox[i][0] << 7);
            for (t = 1; t < 8; t++)
                S[i] ^= cox[i][t] << (7 - t);
            Si[S[i] & 0xFF] = (Byte) i;
        }
        //
        // T-boxes
        //
        Byte G [4][4]= { { 2, 1, 1, 3 }, { 3, 2, 1, 1 },
            { 1, 3, 2, 1 }, { 1, 1, 3, 2 } };
        Byte AA [4][8]= {};
        for (i = 0; i < 4; i++) {
            for (j = 0; j < 4; j++)
                AA[i][j] = G[i][j];
            AA[i][i + 4] = 1;
        }
        Byte pivot, tmp;
        Byte iG [4][4]= {};
        for (i = 0; i < 4; i++) {
            pivot = AA[i][i];
            if (pivot == 0) {
                t = i + 1;
                while ((AA[t][i] == 0) && (t < 4))
                    t++;
                //if (t == 4)
                    //throw new RuntimeException("G matrix is not invertible");
                    //else
                if (t != 4){
                    for (j = 0; j < 8; j++) {
                        tmp = AA[i][j];
                        AA[i][j] = AA[t][j];
                        AA[t][j] = (Byte) tmp;
                    }
                    pivot = AA[i][i];
                }
            }
            for (j = 0; j < 8; j++)
                if (AA[i][j] != 0)
                    AA[i][j] = (Byte) alog[(255 + olog[AA[i][j] & 0xFF] - olog[pivot & 0xFF]) % 255];
            for (t = 0; t < 4; t++)
                if (i != t) {
                    for (j = i + 1; j < 8; j++)
                        AA[t][j] ^= mul(AA[i][j], AA[t][i]);
                    AA[t][i] = 0;
                }
        }
        for (i = 0; i < 4; i++)
            for (j = 0; j < 4; j++)
                iG[i][j] = AA[i][j + 4];
        
        int s;
        for (t = 0; t < 256; t++) {
            s = S[t];
            T1[t] = mul4(s, G[0]);
            T2[t] = mul4(s, G[1]);
            T3[t] = mul4(s, G[2]);
            T4[t] = mul4(s, G[3]);
            
            s = Si[t];
            T5[t] = mul4(s, iG[0]);
            T6[t] = mul4(s, iG[1]);
            T7[t] = mul4(s, iG[2]);
            T8[t] = mul4(s, iG[3]);
            
            U1[t] = mul4(t, iG[0]);
            U2[t] = mul4(t, iG[1]);
            U3[t] = mul4(t, iG[2]);
            U4[t] = mul4(t, iG[3]);
        }
        //
        // round constants
        //
        rcon[0] = 1;
        int r = 1;
        for (t = 1; t < 30;)
        {
            Byte btemp =(Byte) (r = mul(2, r));
            rcon[t++] = btemp;
        }
        
        
        //time = [[NSDate date] timeIntervalSince1970] - time;
  
        return 0;
    }
    
    // multiply two elements of GF(2^m)
    int mul(int a, int b) {
        return (a != 0 && b != 0) ? alog[(olog[a & 0xFF] + olog[b & 0xFF]) % 255]
        : 0;
    }
    
    // convenience method used in generating Transposition boxes
     int mul4(int a, Byte b[]) {
        if (a == 0)
            return 0;
        a = olog[a & 0xFF];
        int a0 = (b[0] != 0) ? alog[(a + olog[b[0] & 0xFF]) % 255] & 0xFF : 0;
        int a1 = (b[1] != 0) ? alog[(a + olog[b[1] & 0xFF]) % 255] & 0xFF : 0;
        int a2 = (b[2] != 0) ? alog[(a + olog[b[2] & 0xFF]) % 255] & 0xFF : 0;
        int a3 = (b[3] != 0) ? alog[(a + olog[b[3] & 0xFF]) % 255] & 0xFF : 0;
        return a0 << 24 | a1 << 16 | a2 << 8 | a3;
    }
    
    // Basic API methods
    // ...........................................................................
    
    /**
     * Convenience method to expand a user-supplied key material into a session
     * key, assuming Rijndael's default block size (128-bit).
     *
     * @param key
     *            The 128/192/256-bit user-key to use.
     * @exception InvalidKeyException
     *                If the key is invalid.
     */
//    id makeKey(Byte k[])
//    {
//        return makeKey(k, BLOCK_SIZE);
//    }

    /**
     * Convenience method to encrypt exactly one block of plaintext, assuming
     * Rijndael's default block size (128-bit).
     *
     * @param in
     *            The plaintext.
     * @param inOffset
     *            Index of in from which to start considering data.
     * @param sessionKey
     *            The session key to use for encryption.
     * @return The ciphertext generated from a plaintext using the session key.
     */

     XByteArray* blockEncrypt3(XByteArray* inBytes, int inOffset, NSObject *sessionKey)
     {
        //		if (DEBUG)
        //			trace(IN, "blockEncrypt(" + in + ", " + inOffset + ", "
        //					+ sessionKey + ")");
         
    
         
         //int[][] Ke = (int[][]) ((Object[]) sessionKey)[0]; // extract
         
         NSArray*Ke0=sessionKey;
         NSMutableArray*Ke =Ke0[0];//int [] []
         
         
         // encryption round
         // keys
         uint ROUNDS = [Ke count] - 1;
         
         NSMutableArray*  Ker = Ke[0];//int []
         
        
        // plaintext to ints + key
        uint t0 = (([inBytes[inOffset++] getByte]  & 0xFF) << 24 | ( [inBytes[inOffset++] getByte]  & 0xFF) << 16
                  | ( [inBytes[inOffset++] getByte]  & 0xFF) << 8 | ( [inBytes[inOffset++] getByte]  & 0xFF))
        ^ [Ker[0] intValue];
        uint t1 = (( [inBytes[inOffset++] getByte]  & 0xFF) << 24 | ( [inBytes[inOffset++] getByte]  & 0xFF) << 16
                  | ( [inBytes[inOffset++] getByte]  & 0xFF) << 8 | ( [inBytes[inOffset++] getByte]  & 0xFF))
        ^ [Ker[1] intValue];
        uint t2 = (( [inBytes[inOffset++] getByte]  & 0xFF) << 24 | ( [inBytes[inOffset++] getByte]  & 0xFF) << 16
                  | ( [inBytes[inOffset++] getByte]  & 0xFF) << 8 | ( [inBytes[inOffset++] getByte]  & 0xFF))
        ^ [Ker[2] intValue];
        uint t3 = (( [inBytes[inOffset++] getByte]  & 0xFF) << 24 | ( [inBytes[inOffset++] getByte]  & 0xFF) << 16
                  | ( [inBytes[inOffset++] getByte]  & 0xFF) << 8 | ( [inBytes[inOffset++] getByte]  & 0xFF))
        ^ [Ker[3] intValue];
        
        uint a0, a1, a2, a3;
        for (int r = 1; r < ROUNDS; r++) { // apply round transforms
            Ker = Ke[r];
            a0 = (T1[(t0 >> 24) & 0xFF] ^ T2[(t1 >> 16) & 0xFF]
                  ^ T3[(t2 >> 8) & 0xFF] ^ T4[t3 & 0xFF])
            ^ [Ker[0] intValue];
            a1 = (T1[(t1 >> 24) & 0xFF] ^ T2[(t2 >> 16) & 0xFF]
                  ^ T3[(t3 >> 8) & 0xFF] ^ T4[t0 & 0xFF])
            ^ [Ker[1] intValue];
            a2 = (T1[(t2 >> 24) & 0xFF] ^ T2[(t3 >> 16) & 0xFF]
                  ^ T3[(t0 >> 8) & 0xFF] ^ T4[t1 & 0xFF])
            ^ [Ker[2] intValue];
            a3 = (T1[(t3 >> 24) & 0xFF] ^ T2[(t0 >> 16) & 0xFF]
                  ^ T3[(t1 >> 8) & 0xFF] ^ T4[t2 & 0xFF])
            ^ [Ker[3] intValue];
            t0 = a0;
            t1 = a1;
            t2 = a2;
            t3 = a3;
            //			if (DEBUG && debuglevel > 6)
            //				System.out.println("CT" + r + "=" + intToString(t0)
            //						+ intToString(t1) + intToString(t2) + intToString(t3));
        }
        
        // last round is special
        XByteArray* result = [XByteArray newWithLength:BLOCK_SIZE]; // the resulting ciphertext
        Ker = Ke[ROUNDS];
        uint tt = [Ker[0] intValue];
        result[0] = [XByte newWithByte: (S[(t0 >> 24) & 0xFF] ^ (tt >> 24))];
        result[1] = [XByte newWithByte:(S[(t1 >> 16) & 0xFF] ^ (tt >> 16))];
        result[2] = [XByte newWithByte:(S[(t2 >> 8) & 0xFF] ^ (tt >> 8))];
        result[3] = [XByte newWithByte: (S[t3 & 0xFF] ^ tt)];
        tt = [Ker[1] intValue];
        result[4] = [XByte newWithByte:(S[(t1 >> 24) & 0xFF] ^ (tt >> 24))];
        result[5] = [XByte newWithByte: (S[(t2 >> 16) & 0xFF] ^ (tt >> 16))];
        result[6] = [XByte newWithByte: (S[(t3 >> 8) & 0xFF] ^ (tt >> 8))];
        result[7] = [XByte newWithByte: (S[t0 & 0xFF] ^ tt)];
        tt = [Ker[2] intValue];
        result[8] = [XByte newWithByte: (S[(t2 >> 24) & 0xFF] ^ (tt >> 24))];
        result[9] = [XByte newWithByte: (S[(t3 >> 16) & 0xFF] ^ (tt >> 16))];
        result[10] = [XByte newWithByte: (S[(t0 >> 8) & 0xFF] ^ (tt >> 8))];
        result[11] = [XByte newWithByte: (S[t1 & 0xFF] ^ tt)];
        tt = [Ker[3] intValue];
        result[12] = [XByte newWithByte: (S[(t3 >> 24) & 0xFF] ^ (tt >> 24))];
        result[13] = [XByte newWithByte: (S[(t0 >> 16) & 0xFF] ^ (tt >> 16))];
        result[14] = [XByte newWithByte: (S[(t1 >> 8) & 0xFF] ^ (tt >> 8))];
        result[15] = [XByte newWithByte: (S[t2 & 0xFF] ^ tt)];
     
        return result;
    }
    
    /**
     * Convenience method to decrypt exactly one block of plaintext, assuming
     * Rijndael's default block size (128-bit).
     *
     * @param in
     *            The ciphertext.
     * @param inOffset
     *            Index of in from which to start considering data.
     * @param sessionKey
     *            The session key to use for decryption.
     * @return The plaintext generated from a ciphertext using the session key.
     */
    XByteArray* blockDecrypt3(XByteArray* inBytes, int inOffset, NSObject* sessionKey) {
        //		if (DEBUG)
        //			trace(IN, "blockDecrypt(" + in + ", " + inOffset + ", "
        //					+ sessionKey + ")");
        //int[][] Kd = (int[][]) ((Object[]) sessionKey)[1]; // extract
        
        NSArray*Kd0=sessionKey;
        NSMutableArray*Kd =Kd0[1];//int [] []
        
        // decryption round
        // keys
       // int ROUNDS = Kd.length - 1;
        //int[] Kdr = Kd[0];
        
        int ROUNDS =[Kd count] - 1;
        NSMutableArray *Kdr =Kd[0];
        
        // ciphertext to ints + key
        uint t0 = (( [inBytes[inOffset++] getByte] & 0xFF) << 24 | ( [inBytes[inOffset++] getByte] & 0xFF) << 16
                  | ( [inBytes[inOffset++] getByte] & 0xFF) << 8 | ( [inBytes[inOffset++] getByte] & 0xFF))
        ^ [Kdr[0] intValue];
        uint t1 = (( [inBytes[inOffset++] getByte] & 0xFF) << 24 | ( [inBytes[inOffset++] getByte] & 0xFF) << 16
                  | ( [inBytes[inOffset++] getByte] & 0xFF) << 8 | ( [inBytes[inOffset++] getByte] & 0xFF))
        ^ [Kdr[1] intValue];
        uint t2 = (( [inBytes[inOffset++] getByte] & 0xFF) << 24 | ( [inBytes[inOffset++] getByte] & 0xFF) << 16
                  | ( [inBytes[inOffset++] getByte] & 0xFF) << 8 | ( [inBytes[inOffset++] getByte] & 0xFF))
        ^ [Kdr[2] intValue];
        uint t3 = (( [inBytes[inOffset++] getByte] & 0xFF) << 24 | ( [inBytes[inOffset++] getByte] & 0xFF) << 16
                  | ( [inBytes[inOffset++] getByte] & 0xFF) << 8 | ( [inBytes[inOffset++] getByte] & 0xFF))
        ^ [Kdr[3] intValue];
        
        uint a0, a1, a2, a3;
        for (int r = 1; r < ROUNDS; r++) { // apply round transforms
            Kdr = Kd[r];
            a0 = (T5[(t0 >> 24) & 0xFF] ^ T6[(t3 >> 16) & 0xFF]
                  ^ T7[(t2 >> 8) & 0xFF] ^ T8[t1 & 0xFF])
            ^ [Kdr[0] intValue];
            a1 = (T5[(t1 >> 24) & 0xFF] ^ T6[(t0 >> 16) & 0xFF]
                  ^ T7[(t3 >> 8) & 0xFF] ^ T8[t2 & 0xFF])
            ^ [Kdr[1] intValue];
            a2 = (T5[(t2 >> 24) & 0xFF] ^ T6[(t1 >> 16) & 0xFF]
                  ^ T7[(t0 >> 8) & 0xFF] ^ T8[t3 & 0xFF])
            ^ [Kdr[2] intValue];
            a3 = (T5[(t3 >> 24) & 0xFF] ^ T6[(t2 >> 16) & 0xFF]
                  ^ T7[(t1 >> 8) & 0xFF] ^ T8[t0 & 0xFF])
            ^ [Kdr[3] intValue];
            t0 = a0;
            t1 = a1;
            t2 = a2;
            t3 = a3;
            //			if (DEBUG && debuglevel > 6)
            //				System.out.println("PT" + r + "=" + intToString(t0)
            //						+ intToString(t1) + intToString(t2) + intToString(t3));
        }
        
        // last round is special
        XByteArray* result = [XByteArray newWithLength:16]; // the resulting plaintext
        Kdr = Kd[ROUNDS];
        uint tt = [Kdr[0] intValue];
        result[0] = [XByte  newWithByte:(Si[(t0 >> 24) & 0xFF] ^ (tt >> 24))];
        result[1] = [XByte  newWithByte: (Si[(t3 >> 16) & 0xFF] ^ (tt >> 16))];
        result[2] = [XByte  newWithByte: (Si[(t2 >> 8) & 0xFF] ^ (tt >> 8))];
        result[3] = [XByte  newWithByte: (Si[t1 & 0xFF] ^ tt)];
        tt = [Kdr[1] intValue];
        result[4] = [XByte  newWithByte: (Si[(t1 >> 24) & 0xFF] ^ (tt >> 24))];
        result[5] = [XByte  newWithByte: (Si[(t0 >> 16) & 0xFF] ^ (tt >> 16))];
        result[6] = [XByte  newWithByte: (Si[(t3 >> 8) & 0xFF] ^ (tt >> 8))];
        result[7] = [XByte  newWithByte: (Si[t2 & 0xFF] ^ tt)];
        tt = [Kdr[2] intValue];
        result[8] = [XByte  newWithByte: (Si[(t2 >> 24) & 0xFF] ^ (tt >> 24))];
        result[9] = [XByte  newWithByte: (Si[(t1 >> 16) & 0xFF] ^ (tt >> 16))];
        result[10] = [XByte  newWithByte: (Si[(t0 >> 8) & 0xFF] ^ (tt >> 8))];
        result[11] = [XByte  newWithByte: (Si[t3 & 0xFF] ^ tt)];
        tt = [Kdr[3] intValue];
        result[12] = [XByte  newWithByte: (Si[(t3 >> 24) & 0xFF] ^ (tt >> 24))];
        result[13] = [XByte  newWithByte: (Si[(t2 >> 16) & 0xFF] ^ (tt >> 16))];
        result[14] = [XByte  newWithByte: (Si[(t1 >> 8) & 0xFF] ^ (tt >> 8))];
        result[15] = [XByte  newWithByte: (Si[t0 & 0xFF] ^ tt)];
        //		if (DEBUG && debuglevel > 6) {
        //			System.out.println("PT=" + toString(result));
        //			System.out.println();
        //		}
        //		if (DEBUG)
        //			trace(OUT, "blockDecrypt()");
        return result;
    }
    
    /** A basic symmetric encryption/decryption test. */
//    Boolean self_test() {
//        return self_test(BLOCK_SIZE);
//    }

    // Rijndael own methods
    // ...........................................................................
    
    /** @return The default length in bytes of the Algorithm input block. */
//    int blockSize() {
//        return BLOCK_SIZE;
//    }

    /**
     * Expand a user-supplied key material into a session key.
     *
     * @param key
     *            The 128/192/256-bit user-key to use.
     * @param blockSize
     *            The block size in bytes of this Rijndael.
     * @exception InvalidKeyException
     *                If the key is invalid.
     //返回值 sessionKey: int [][][]
     NSArray*Ke0=sessionKey;
     NSMutableArray*Ke =Ke0[0];//int [] []
     
     
     // encryption round
     // keys
     uint ROUNDS = [Ke count] - 1;
     
     NSMutableArray*  Ker = Ke[0];//int []
     
     */


    NSObject* makeKey(XByteArray* k, int blockSize) {
        //		if (DEBUG)
        //			trace(IN, "makeKey(" + k + ", " + blockSize + ")");
//        if (k == null)
//            throw new InvalidKeyException("Empty key");
//        if (!(k.length == 16 || k.length == 24 || k.length == 32))
//            throw new InvalidKeyException("Incorrect key length");
        int ROUNDS = getRounds([k count], blockSize);
        int BC = blockSize / 4;
//        int[][] Ke = new int[ROUNDS + 1][BC]; // encryption round keys
//        int[][] Kd = new int[ROUNDS + 1][BC]; // decryption round keys
        
        NSMutableArray *Ke = [NSMutableArray newWithLength:ROUNDS + 1];
        for (int i=0; i<ROUNDS + 1; i++) {
            NSMutableArray *Ke2 = [NSMutableArray newWithLength:BC];
            Ke[i]=Ke2;
        }
        
        NSMutableArray *Kd = [NSMutableArray newWithLength:ROUNDS + 1];
        for (int i=0; i<ROUNDS + 1; i++) {
            NSMutableArray *Kd2 = [NSMutableArray newWithLength:BC];
            Kd[i]=Kd2;
        }
        
        
        int ROUND_KEY_COUNT = (ROUNDS + 1) * BC;
        int KC = [k count] / 4;
        //int[] tk = new int[KC];
        NSMutableArray*tk = [NSMutableArray newWithLength:KC];
        int i, j;
        
        // copy user material bytes into temporary ints
        for (i = 0, j = 0; i < KC;)
            tk[i++] =  [[NSNumber alloc]initWithInt:([k[j++] getByte] & 0xFF) << 24 | ([k[j++]getByte] & 0xFF) << 16
            | ([k[j++]getByte] & 0xFF) << 8 |([k[j++]getByte] & 0xFF) ];
        
        // copy values into round key arrays
        int t = 0;
        for (j = 0; (j < KC) && (t < ROUND_KEY_COUNT); j++, t++) {
            Ke[t / BC][t % BC] =  [[NSNumber alloc]initWithInt: [tk[j] intValue]];
            Kd[ROUNDS - (t / BC)][t % BC] = [[NSNumber alloc]initWithInt: [tk[j] intValue]];
        }
        uint tt, rconpointer = 0;
        while (t < ROUND_KEY_COUNT) {
            // extrapolate using phi (the round key evolution function)
            tt = [tk[KC - 1] intValue];
           
            tk[0] = [[NSNumber alloc]initWithInt:([tk[0] intValue]^
                                                  (
                                                   (S[(tt >> 16) & 0xFF] & 0xFF) << 24
                                                   ^ (S[(tt >> 8) & 0xFF] & 0xFF) << 16
                                                   ^ (S[tt & 0xFF] & 0xFF) << 8
                                                   ^ (S[(tt >> 24) & 0xFF] & 0xFF)
                                                   ^ (rcon [rconpointer++] & 0xFF) << 24
                                                   )
                                                  )];
            //NSLog(@"1: tk[%d]=%d",0,[tk[0] intValue]);
            if (KC != 8)
                for (i = 1, j = 0; i < KC;)
                {
                    int index = i++;
                     tk[index] = [[NSNumber alloc]initWithInt:( [tk[index] intValue]^[tk[j++]intValue])];
                    //NSLog(@"2: tk[%d]=%d",index,[tk[index] intValue]);
                }
            
            else {
                for (i = 1, j = 0; i < KC / 2;)
                {
                    int index = i++;
                    tk[index] = [[NSNumber alloc]initWithInt:( [tk[index] intValue]^[tk[j++]intValue])];
                    //NSLog(@"3: tk[%d]=%d",index,[tk[index] intValue]);
                }
   
                tt = [tk[KC / 2 - 1] intValue ];
                //tk[KC / 2] ^= (S[tt & 0xFF] & 0xFF)
                //^ (S[(tt >>> 8) & 0xFF] & 0xFF) << 8
                //^ (S[(tt >>> 16) & 0xFF] & 0xFF) << 16
                //^ (S[(tt >>> 24) & 0xFF] & 0xFF) << 24;
                tk[KC / 2] = [[NSNumber alloc]initWithInt:( [tk[KC / 2] intValue]^
                                                           (
                                                            (S[tt & 0xFF] & 0xFF)
                                                            ^ (S[(tt >> 8) & 0xFF] & 0xFF) << 8
                                                            ^ (S[(tt >> 16) & 0xFF] & 0xFF) << 16
                                                            ^ (S[(tt >> 24) & 0xFF] & 0xFF) << 24
                                                           )
                                                           )];
              //NSLog(@"4: tk[%d]=%d",KC / 2,[tk[KC / 2] intValue]);
                for (j = KC / 2, i = j + 1; i < KC;)
                {
                    int index = i++;
                    tk[index] = [[NSNumber alloc]initWithInt:( [tk[index] intValue]^[tk[j++]intValue])];
                    //NSLog(@"5: tk[%d]=%d",index,[tk[index] intValue]);
                }
                
                    //tk[i++] ^= tk[j++];
            }
            // copy values into round key arrays
            for (j = 0; (j < KC) && (t < ROUND_KEY_COUNT); j++, t++) {
                Ke[t / BC][t % BC] = [[NSNumber alloc]initWithInt: [tk[j] intValue]];
                Kd[ROUNDS - (t / BC)][t % BC] = [[NSNumber alloc]initWithInt: [tk[j] intValue]];
            }
        }
        for (int r = 1; r < ROUNDS; r++)
            // inverse MixColumn where needed
            for (j = 0; j < BC; j++) {
                tt = [Kd[r][j] intValue];
                Kd[r][j] = [[NSNumber alloc]initWithInt:(
                                                         U1[(tt >> 24) & 0xFF]
                                                         ^ U2[(tt >> 16) & 0xFF]
                                                         ^ U3[(tt >> 8) & 0xFF]
                                                         ^ U4[tt & 0xFF]
                                                         )];
            }
        // assemble the encryption (Ke) and decryption (Kd) round keys into
        // one sessionKey object
       // Object[] sessionKey = new Object[] { Ke, Kd };
        NSMutableArray*sessionKey = [NSMutableArray newWithLength:2];
        sessionKey[0]=Ke;
        sessionKey[1]=Kd;
        //		if (DEBUG)
        //			trace(OUT, "makeKey()");
        return sessionKey;
    }
    
    /**
     * Encrypt exactly one block of plaintext.
     *
     * @param in
     *            The plaintext.
     * @param inOffset
     *            Index of in from which to start considering data.
     * @param sessionKey
     *            The session key to use for encryption.
     * @param blockSize
     *            The block size in bytes of this Rijndael.
     * @return The ciphertext generated from a plaintext using the session key.
     */
    XByteArray* blockEncrypt(XByteArray* inBytes, int inOffset,
                                      NSObject* sessionKey, int blockSize) {
        if (blockSize == BLOCK_SIZE)
            return blockEncrypt3(inBytes, inOffset, sessionKey);
        //		if (DEBUG)
        //			trace(IN, "blockEncrypt(" + in + ", " + inOffset + ", "
        //					+ sessionKey + ", " + blockSize + ")");
//        Object[] sKey = (Object[]) sessionKey; // extract encryption round keys
//        int[][] Ke = (int[][]) sKey[0];
        NSArray*sKey=sessionKey;
        NSMutableArray*Ke =sKey[0];//int [] []
        
        
        int BC = blockSize / 4;
        int ROUNDS = [Ke count] - 1;
        int SC = BC == 4 ? 0 : (BC == 6 ? 1 : 2);
        int s1 = shifts[SC][1][0];
        int s2 = shifts[SC][2][0];
        int s3 = shifts[SC][3][0];
        int *a = new int[BC];
        int *t = new int[BC]; // temporary work array
        int i;
        XByteArray* result = [XByteArray newWithLength:blockSize]; // the resulting ciphertext
        uint j = 0, tt;
        
        for (i = 0; i < BC; i++)
            // plaintext to ints + key
            t[i] = (( [inBytes[inOffset++] getByte] & 0xFF) << 24
                    | ( [inBytes[inOffset++] getByte] & 0xFF) << 16
                    | ( [inBytes[inOffset++] getByte] & 0xFF) << 8
                    | ( [inBytes[inOffset++] getByte] & 0xFF))
            ^ [Ke[0][i] intValue];
        for (int r = 1; r < ROUNDS; r++) { // apply round transforms
            for (i = 0; i < BC; i++)
                a[i] = (T1[(t[i] >> 24) & 0xFF]
                        ^ T2[(t[(i + s1) % BC] >> 16) & 0xFF]
                        ^ T3[(t[(i + s2) % BC] >> 8) & 0xFF] ^ T4[t[(i + s3)
                                                                     % BC] & 0xFF])
                ^[Ke[r][i] intValue];
            
            //System.arraycopy(a, 0, t, 0, BC);
            
            for (i = 0; i < BC; i++)
                    t[i]=a[i];
            
            //			if (DEBUG && debuglevel > 6)
            //				System.out.println("CT" + r + "=" + toString(t));
        }
        for (i = 0; i < BC; i++) { // last round is special
            tt = [Ke[ROUNDS][i] intValue];
            
            result[j++] = [XByte newWithByte: (S[(t[i] >> 24) & 0xFF] ^ (tt >> 24))];
            result[j++] = [XByte newWithByte: (S[(t[(i + s1) % BC] >> 16) & 0xFF] ^ (tt >> 16))];
            result[j++] = [XByte newWithByte: (S[(t[(i + s2) % BC] >> 8) & 0xFF] ^ (tt >> 8))];
            result[j++] = [XByte newWithByte: (S[t[(i + s3) % BC] & 0xFF] ^ tt)];
        }
        //		if (DEBUG && debuglevel > 6) {
        //			System.out.println("CT=" + toString(result));
        //			System.out.println();
        //		}
        //		if (DEBUG)
        //			trace(OUT, "blockEncrypt()");
        delete[] a;
        delete[] t;
        
        return result;
    }
    
    /**
     * Decrypt exactly one block of ciphertext.
     *
     * @param in
     *            The ciphertext.
     * @param inOffset
     *            Index of in from which to start considering data.
     * @param sessionKey
     *            The session key to use for decryption.
     * @param blockSize
     *            The block size in bytes of this Rijndael.
     * @return The plaintext generated from a ciphertext using the session key.
     */
    XByteArray* blockDecrypt(XByteArray* inBytes, int inOffset,
                                      NSObject* sessionKey, int blockSize) {
        if (blockSize == BLOCK_SIZE)
            return blockDecrypt3(inBytes, inOffset, sessionKey);
        //		if (DEBUG)
        //			trace(IN, "blockDecrypt(" + in + ", " + inOffset + ", "
        //					+ sessionKey + ", " + blockSize + ")");
//        Object[] sKey = (Object[]) sessionKey; // extract decryption round keys
//        int[][] Kd = (int[][]) sKey[1];
        NSArray*sKey=sessionKey;
        NSMutableArray*Kd =sKey[1];//int [] []
        
        int BC = blockSize / 4;
        int ROUNDS = [Kd count] - 1;
        int SC = BC == 4 ? 0 : (BC == 6 ? 1 : 2);
        int s1 = shifts[SC][1][1];
        int s2 = shifts[SC][2][1];
        int s3 = shifts[SC][3][1];
        int* a = new int[BC];
        int* t = new int[BC]; // temporary work array
        int i;
        XByteArray* result = [XByteArray newWithLength: blockSize]; // the resulting plaintext
        uint j = 0, tt;
        
        for (i = 0; i < BC; i++)
            // ciphertext to ints + key
            t[i] = (( [inBytes[inOffset++] getByte] & 0xFF) << 24
                    | ( [inBytes[inOffset++] getByte] & 0xFF) << 16
                    | ( [inBytes[inOffset++] getByte] & 0xFF) << 8
                    | ( [inBytes[inOffset++] getByte] & 0xFF))
            ^ [Kd[0][i] intValue];
        for (int r = 1; r < ROUNDS; r++) { // apply round transforms
            for (i = 0; i < BC; i++)
                a[i] = (T5[(t[i] >> 24) & 0xFF]
                        ^ T6[(t[(i + s1) % BC] >> 16) & 0xFF]
                        ^ T7[(t[(i + s2) % BC] >> 8) & 0xFF]
                        ^ T8[t[(i + s3) % BC] & 0xFF])
                ^ [Kd[r][i] intValue];
            //System.arraycopy(a, 0, t, 0, BC);
            for (i = 0; i < BC; i++)
                t[i]=a[i];
            
            //			if (DEBUG && debuglevel > 6)
            //				System.out.println("PT" + r + "=" + toString(t));
        }
        for (i = 0; i < BC; i++) { // last round is special
            tt = [Kd[ROUNDS][i] intValue];
            result[j++] = [XByte newWithByte: (Si[(t[i] >> 24) & 0xFF] ^ (tt >> 24))];
            result[j++] = [XByte newWithByte: (Si[(t[(i + s1) % BC] >> 16) & 0xFF] ^ (tt >> 16))];
            result[j++] = [XByte newWithByte: (Si[(t[(i + s2) % BC] >> 8) & 0xFF] ^ (tt >> 8))];
            result[j++] = [XByte newWithByte: (Si[t[(i + s3) % BC] & 0xFF] ^ tt)];
        }
        //		if (DEBUG && debuglevel > 6) {
        //			System.out.println("PT=" + toString(result));
        //			System.out.println();
        //		}
        //		if (DEBUG)
        //			trace(OUT, "blockDecrypt()");
        
        delete[] a;
        delete[] t;
        return result;
    }
    
//    /** A basic symmetric encryption/decryption test for a given key size. */
//    private static boolean self_test(int keysize) {
//        //		if (DEBUG)
//        //			trace(IN, "self_test(" + keysize + ")");
//        boolean ok = false;
//        try {
//            byte[] kb = new byte[keysize];
//            byte[] pt = new byte[BLOCK_SIZE];
//            int i;
//            
//            for (i = 0; i < keysize; i++)
//                kb[i] = (byte) i;
//            for (i = 0; i < BLOCK_SIZE; i++)
//                pt[i] = (byte) i;
//            
//            //			if (DEBUG && debuglevel > 6) {
//            //				System.out.println("==========");
//            //				System.out.println();
//            //				System.out.println("KEYSIZE=" + (8 * keysize));
//            //				System.out.println("KEY=" + toString(kb));
//            //				System.out.println();
//            //			}
//            Object key = makeKey(kb, BLOCK_SIZE);
//            
//            //			if (DEBUG && debuglevel > 6) {
//            //				System.out
//            //						.println("Intermediate Ciphertext Values (Encryption)");
//            //				System.out.println();
//            //				System.out.println("PT=" + toString(pt));
//            //			}
//            byte[] ct = blockEncrypt(pt, 0, key, BLOCK_SIZE);
//            
//            //			if (DEBUG && debuglevel > 6) {
//            //				System.out
//            //						.println("Intermediate Plaintext Values (Decryption)");
//            //				System.out.println();
//            //				System.out.println("CT=" + toString(ct));
//            //			}
//            byte[] cpt = blockDecrypt(ct, 0, key, BLOCK_SIZE);
//            
//            ok = areEqual(pt, cpt);
//            if (!ok)
//                throw new RuntimeException("Symmetric operation failed");
//        } catch (Exception x) {
//            //			if (DEBUG && debuglevel > 0) {
//            //				debug("Exception encountered during self-test: "
//            //						+ x.getMessage());
//            //				x.printStackTrace();
//            //			}
//        }
//        //		if (DEBUG && debuglevel > 0)
//        //			debug("Self-test OK? " + ok);
//        //		if (DEBUG)
//        //			trace(OUT, "self_test()");
//        return ok;
//    }

    /**
     * Return The number of rounds for a given Rijndael's key and block sizes.
     * 
     * @param keySize
     *            The size of the user key material in bytes.
     * @param blockSize
     *            The desired block size in bytes.
     * @return The number of rounds for a given Rijndael's key and block sizes.
     */
    int getRounds(int keySize, int blockSize) {
        switch (keySize) {
            case 16:
                return blockSize == 16 ? 10 : (blockSize == 24 ? 12 : 14);
            case 24:
                return blockSize != 32 ? 12 : 14;
            default: // 32 bytes = 256 bits
                return 14;
        }
    }
    
    // utility static methods (from cryptix.util.core ArrayUtil and Hex classes)
    // ...........................................................................
    
    /**
     * Compares two byte arrays for equality.
     * 
     * @return true if the arrays have identical contents
     */
//    private static boolean areEqual(byte[] a, byte[] b) {
//        int aLength = a.length;
//        if (aLength != b.length)
//            return false;
//        for (int i = 0; i < aLength; i++)
//            if (a[i] != b[i])
//                return false;
//        return true;
//    }

    /**
     * Returns a string of 2 hexadecimal digits (most significant digit first)
     * corresponding to the lowest 8 bits of <i>n</i>.
     */
//    private static String byteToString(int n) {
//        char[] buf = { HEX_DIGITS[(n >>> 4) & 0x0F], HEX_DIGITS[n & 0x0F] };
//        return new String(buf);
//    }

    /**
     * Returns a string of 8 hexadecimal digits (most significant digit first)
     * corresponding to the integer <i>n</i>, which is treated as unsigned.
     */
//    private static String intToString(int n) {
//        char[] buf = new char[8];
//        for (int i = 7; i >= 0; i--) {
//            buf[i] = HEX_DIGITS[n & 0x0F];
//            n >>>= 4;
//        }
//        return new String(buf);
//    }

    /**
     * Returns a string of hexadecimal digits from a byte array. Each byte is
     * converted to 2 hex symbols.
     */
//    private static String toString(byte[] ba) {
//        int length = ba.length;
//        char[] buf = new char[length * 2];
//        for (int i = 0, j = 0, k; i < length;) {
//            k = ba[i++];
//            buf[j++] = HEX_DIGITS[(k >>> 4) & 0x0F];
//            buf[j++] = HEX_DIGITS[k & 0x0F];
//        }
//        return new String(buf);
//    }

    /**
     * Returns a string of hexadecimal digits from an integer array. Each int is
     * converted to 4 hex symbols.
     */
//    private static String toString(int[] ia) {
//        int length = ia.length;
//        char[] buf = new char[length * 8];
//        for (int i = 0, j = 0, k; i < length; i++) {
//            k = ia[i];
//            buf[j++] = HEX_DIGITS[(k >>> 28) & 0x0F];
//            buf[j++] = HEX_DIGITS[(k >>> 24) & 0x0F];
//            buf[j++] = HEX_DIGITS[(k >>> 20) & 0x0F];
//            buf[j++] = HEX_DIGITS[(k >>> 16) & 0x0F];
//            buf[j++] = HEX_DIGITS[(k >>> 12) & 0x0F];
//            buf[j++] = HEX_DIGITS[(k >>> 8) & 0x0F];
//            buf[j++] = HEX_DIGITS[(k >>> 4) & 0x0F];
//            buf[j++] = HEX_DIGITS[k & 0x0F];
//        }
//        return new String(buf);
//    }

    // main(): use to generate the Intermediate Values KAT
    // ...........................................................................
    
//    public static void main(String[] args) {
//        self_test(16);
//        self_test(24);
//        self_test(32);
//    }


   int ss =  staticFun();

@implementation XRijndael_Algorithm
+(NSObject*)makeKey:(XByteArray*)kb :(int)blockSize
{
    return makeKey(kb,blockSize);
}

+(XByteArray*)blockEncrypt:(XByteArray*)pt   :(int)i  :( NSObject* )key    :(int)intblockSize
{
    return blockEncrypt(pt,i,key,intblockSize);
}

+(XByteArray*) blockDecrypt:(XByteArray*) inBytes : (int) inOffset :(NSObject*) sessionKey : (int )blockSize
{
    return blockDecrypt(inBytes,inOffset,sessionKey,blockSize);
}
@end
