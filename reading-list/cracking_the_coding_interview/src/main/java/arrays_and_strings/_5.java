package arrays_and_strings;

/**
 * Created by mjhamrick on 12/16/16.
 */
public class _5 {
    // One Away: There are three types of edits that can be performed on strings:
    // insert a character, remove a character, or replace a character. Given two
    // strings, write a function to check if they are one edit (or zero edits) away.
    // EXAMPLE
    // pale, ple -> true
    // pales, pale -> true
    // pale, bale -> true
    // pale, bake -> false
    // Hints:#23, #97, #130
    public static boolean oneEditAway(String a, String b) {
        int aLength = a.length();
        int bLength = b.length();

        String shorterA = (aLength < bLength) ? a : b;
        String longerB = (aLength < bLength) ? b : a;

        // check that they are within 1 character
        if (longerB.length() - shorterA.length() > 1) {
            return false;
        }
        boolean haveChanged = false;
        if (longerB.length() == shorterA.length()) {
            for (int i = 0; i < shorterA.length(); i++) {
                String asubs = shorterA.substring(i, i + 1);
                String bsubs = longerB.substring(i, i + 1);
                if (asubs.equals(bsubs)) {
                    continue;
                } else {
                    if (haveChanged) {
                        return false;
                    } else {
                        haveChanged = true;
                    }
                }
            }
        } else {
            boolean haveAdded = false;
            int longerIndex = 0;
            for (int i = 0; i < shorterA.length(); i++) {
                String asubs = shorterA.substring(i, i + 1);
                String bsubs = longerB.substring(longerIndex, longerIndex + 1);
                if (asubs.equals(bsubs)) {
                    longerIndex++;
                    // easier to read this way
                    continue;
                } else {
                    if (haveAdded) {
                        return false;
                    } else {
                        haveAdded = true;
                        i--;
                        longerIndex++;
                        continue;
                    }
                }
            }
        }
        return true;
    }
}
