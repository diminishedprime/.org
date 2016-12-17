package arrays_and_strings;

import org.junit.Test;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

/**
 * Created by mjhamrick on 12/16/16.
 */
public class _4Test {

    @Test
    public void testPalindromeThing() {
        // Input: Tact Coa
        // Output: True (permutations: "taco cat", "atco cta", etc.)
        assertTrue(_4.palindromePermutation("Tact Coa"));
        assertFalse(_4.palindromePermutation("ab"));
        assertTrue(_4.palindromePermutation("a"));
        assertTrue(_4.palindromePermutation(""));
        assertFalse(_4.palindromePermutation("The Butler"));
    }
}
