package arrays_and_strings;

/**
 * Created by mjhamrick on 12/16/16.
 */
public class _9 {
    // String Rotation: Assume you have a method isSubstring which checks
    // if one word is a substring of another. Given two strings, s1 and
    // s2, write code to check if s2 is a rotation of s1 using only one
    // call to isSubstring (e.g.,"waterbottle" is a rotation of"erbottlewat").
    // Hints:#34,#88, #704

    public static boolean isRotation(String s1, String s2) {
        String combined = s2 + s2;
        return combined.contains(s1);
    }

}
