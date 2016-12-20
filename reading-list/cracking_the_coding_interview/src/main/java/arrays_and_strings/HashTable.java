package arrays_and_strings;

import java.util.LinkedList;
import java.util.Optional;

/**
 * Created by mjhamrick on 12/16/16.
 */
public class HashTable<K, V> {

    public int size() {
        return size;
    }

    private static class Node<K, V> {
        K key;
        V value;

        public Node(K key, V value) {
            this.key = key;
            this.value = value;
        }

        K getKey() {
            return key;
        }

        V getValue() {
            return value;
        }
    }

    private LinkedList[] table;
    private int size;
    private int threshold;
    private float loadFactor = 0.75f;

    public HashTable() {
        this(4);
    }

    public HashTable (int initialSize) {
        this.table = new LinkedList[initialSize * 2];
        this.threshold = initialSize;
    }

    public Optional<V> get(K key) {
        int hash = key.hashCode();
        int placeInArray = hash % this.threshold;
        LinkedList<Node<K, V>> list = this.table[placeInArray];
        if (list != null) {
            for (Node<K, V> node : list) {
                if (node.getKey().equals(key)) {
                    return Optional.of(node.getValue());
                }
            }
        }
        return Optional.empty();
    }

    public void put(K key, V value) {
        this.put(new Node<K, V>(key, value));
    }

    private void put(Node<K, V> node) {
        if (size / (double)threshold >= loadFactor) {
            resizeTable();
        }

        int hash = node.getKey().hashCode();
        int placeInArray = hash % this.threshold;
        LinkedList<Node<K, V>> list = this.table[placeInArray];
        if (list == null) {
            list = new LinkedList<>();
            this.table[placeInArray] = list;
        }

        for (int i = 0; i < list.size(); i++) {
            Node<K, V> nodeAtI = list.get(i);
            if (nodeAtI.getKey().equals(node.getKey())) {
                // same key, replace with new data
                list.set(i, node);
                return;
            }
        }
        // otherwise key isn't in the list yet, add to end.
        list.addLast(node);
        size++;
    }

    private void resizeTable() {
        // double table size
        threshold *= 2;
        // copying over all elements so set size to zero
        size = 0;
        LinkedList[] oldArray = this.table;
        this.table = new LinkedList[threshold];
        //copy over old values into newArray
        for (LinkedList<Node<K, V>> list : oldArray) {
            if (list != null) {
                for (Node<K, V> node : list) {
                    this.put(node);
                }
            }
        }
    }



}
