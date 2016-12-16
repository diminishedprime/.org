package arrays_and_strings;

import org.junit.Test;

import static arrays_and_strings._3.urlIfy;
import static junit.framework.TestCase.assertEquals;

/**
 * Created by mjhamrick on 12/16/16.
 */
public class _3Test {
    
    @Test
    public void urlIfyTest() {

        // EXAMPLE Input: "Mr John Smith ", 13 Output: "Mr%20John%20Smith" Hints: #53, #118
        char[] inputArray = "Mr John Smith    ".toCharArray();
        String expected   = "Mr%20John%20Smith";
        int trueLength = 13;

        _3.urlIfy(inputArray, trueLength);
        String actual = String.valueOf(inputArray);

        assertEquals(actual, expected);


        char[] inputArray2 = "a b  ".toCharArray();
        String expected2 = "a%20b";
        int trueLength2 = 3;
        _3.urlIfy(inputArray2, trueLength2);
        String actual2 = String.valueOf(inputArray2);
        assertEquals(actual2, expected2);

        char[] inputArray3 = "abcdefg".toCharArray();
        String expected3   = "abcdefg";
        int trueLength3 = expected3.length();
        _3.urlIfy(inputArray3, trueLength3);
        String actual3 = String.valueOf(inputArray3);

        assertEquals(expected3, actual3);


    }
}
