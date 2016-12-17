package arrays_and_strings;

import org.junit.Test;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

/**
 * Created by mjhamrick on 12/16/16.
 */
public class _5Test {

    @Test
    public void test1Away() {
        assertTrue(_5.oneEditAway("pale", "ple"));
        assertTrue(_5.oneEditAway("pales", "pale"));
        assertTrue(_5.oneEditAway("pale", "bale"));
        assertFalse(_5.oneEditAway("bake", "pale"));
    }
}
