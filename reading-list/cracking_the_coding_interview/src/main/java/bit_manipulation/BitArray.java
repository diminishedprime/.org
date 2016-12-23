package bit_manipulation;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

/**
 * Created by mjhamrick on 12/23/16.
 */
class BitArray {


    private static final int bitsPerIndex = 32;
    private List<Integer> data;

    BitArray() {
        data = new ArrayList<>();
    }
    BitArray(int size) {
        data = new ArrayList<>(size);
    }

    void clearBit(int index) {
        if (index >= data.size() * bitsPerIndex) {
            // no need to do anything since a bit outside of the range will
            // be considered off
            return;
        } else {
            int shift = index / 32;
            int indexedValue = data.get(shift);
            int newVal = clearBit(indexedValue, index);
            data.set(shift, newVal);
        }
    }

    boolean getBit(int index) {
        if (index >= data.size() * bitsPerIndex) {
            return false;
        } else {
            int shift = index / 32;
            int indexedValue = data.get(shift);
            return BitArray.getBit(indexedValue, index);
        }
    }

    void setBit(int index) {
        if (index >= data.size() * bitsPerIndex) {
            data.add(0b0);
            setBit(index);
        } else {
            int shift = index / 32;
            int indexedValue = data.get(shift);
            int newVal = BitArray.setBit(indexedValue, index);
            data.set(shift, newVal);

        }
    }

    private static int clearBit(int data, int index) {
        // shift 1 over by the index amount, and then flip every bit, this will
        // take us from something like
        // 00001
        // to
        // 00100
        // to
        // 11011
        int mask = ~(1 << index);
        // when we and this with the data, everything on will stay on, and the
        // one off in the mask will turn off that bit in the data
        return data & mask;
    }

    private static int setBit(int data, int index) {
        int shifted = (1 << index);
        // or will keep the values the same everywhere, but turn them on where
        // there is a 1 in shifted.
        return data | shifted;
    }

    private static boolean getBit(int data, int index) {
        // shift 1 over by the index amount this will take us from something like
        // 000001
        // to
        // 001000
        int shifted1 = (1 << index);
        // shifted &-ed with data will be zero for everything except potentially the
        // one value that we're checking the index of. This means that if the value is not zero,
        // then the index is currently turned on.
        int anded = data & shifted1;

        return anded != 0;
    }

}
