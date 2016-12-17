package arrays_and_strings;

import org.junit.Test;

import static junit.framework.TestCase.assertEquals;

/**
 * Created by mjhamrick on 12/16/16.
 */
public class _6Test {

    @Test
    public void testThing() {
        // the string aabcccccaaa would become a2blc5a3. If the "compressed"
        String expected = "a2b1c5a3";
        String actual = _6.compressString("aabcccccaaa");
        assertEquals(actual, expected);

        assertEquals("abc", _6.compressString("abc"));
        assertEquals("a10", _6.compressString("aaaaaaaaaa"));
    }
}
