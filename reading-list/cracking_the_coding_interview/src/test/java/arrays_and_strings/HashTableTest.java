package arrays_and_strings;

import org.junit.Test;

import java.util.Optional;

import static junit.framework.TestCase.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

/**
 * Created by mjhamrick on 12/16/16.
 */
public class HashTableTest {


    @Test
    public void hashTableResizeTest() {
        HashTable<Integer, Integer> myTable = new HashTable<>();
        for (int i = 0; i < 10; i++) {
            myTable.put(i, i);
        }
        assertEquals(10, myTable.size());
    }

    @Test
    public void testHashTable() {

        HashTable<String, String> myTable = new HashTable<>(30);
        String value = "there";
        myTable.put("hi", value);
        Optional<String> actual = myTable.get("hi");

        assertTrue(actual.isPresent());
        assertEquals(actual.get(), value);

    }

    @Test
    public void getWithNoValue() {
        HashTable<String, String> myTable = new HashTable<>();
        Optional<String> actual = myTable.get("hi");

        assertFalse(actual.isPresent());
    }

    @Test
    public void testHashTableWith2Puts() {
        HashTable<String, String> myTable = new HashTable<>(30);
        String value = "there";
        String value2 = "thereAlso";
        myTable.put("hi", value);
        myTable.put("hi", value2);
        Optional<String> actual = myTable.get("hi");

        assertTrue(actual.isPresent());
        assertEquals(actual.get(), value2);
    }

}
