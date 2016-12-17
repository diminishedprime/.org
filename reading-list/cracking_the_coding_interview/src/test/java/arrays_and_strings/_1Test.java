package arrays_and_strings;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

/**
 * Created by mjhamrick on 12/14/16.
 */
public class _1Test {

    @Test
    public void allUniqueCharactersWithBitArray() {
        assertTrue(_1.allUniqueCharactersWithBitArray("ab"));
        assertTrue(_1.allUniqueCharactersWithBitArray("abcdefghijklmno"));
        assertFalse(_1.allUniqueCharactersWithBitArray("aaa"));
        assertTrue(_1.allUniqueCharactersWithBitArray(""));
    }

    @Test
    public void allUniqueCharactersWithBooleanArray() {
        assertTrue(_1.allUniqueCharactersWithFixedChar("ab"));
        assertTrue(_1.allUniqueCharactersWithFixedChar("abcdefghijklmno"));
        assertFalse(_1.allUniqueCharactersWithFixedChar("aaa"));
        assertTrue(_1.allUniqueCharactersWithFixedChar(""));
    }

    @Test
    public void allUniqueCharactersWithSetTest() {
        assertTrue(_1.allUniqueCharactersWithSet("ab"));
        assertTrue(_1.allUniqueCharactersWithSet("abcdefghijklmno"));
        assertFalse(_1.allUniqueCharactersWithSet("aaa"));
        assertTrue(_1.allUniqueCharactersWithSet(""));
    }

    @Test
    public void allUniqueCharactersTest() {
        assertTrue(_1.allUniqueCharacters("ab"));
        assertTrue(_1.allUniqueCharacters("bcntkaoeu"));
        assertTrue(_1.allUniqueCharacters("abcdefghijklmno"));
        assertFalse(_1.allUniqueCharacters("aaa"));
        assertTrue(_1.allUniqueCharacters(""));
    }

}
