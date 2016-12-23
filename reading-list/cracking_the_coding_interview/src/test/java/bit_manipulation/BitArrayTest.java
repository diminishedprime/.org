package bit_manipulation;

import org.junit.Test;

import java.util.Iterator;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

/**
 * Created by mjhamrick on 12/23/16.
 */
public class BitArrayTest {

    @Test
    public void test() {

        BitArray myBitArary = new BitArray();
        myBitArary.setBit(1000);
        assertTrue(myBitArary.getBit(1000));

        myBitArary.setBit(10000);
        assertTrue(myBitArary.getBit(1000));
        assertFalse(myBitArary.getBit(13));

        assertFalse(myBitArary.getBit(1234567));

    }
    @Test
    public void primeSieve() {
        BitArray myArray = new BitArray(100);

        myArray.setBit(2);

        Iterator<Boolean> iterator = myArray.getIterator();
        while (iterator.hasNext()) {
            Boolean val = iterator.next();
            System.out.println(val);
        }

    }

}
