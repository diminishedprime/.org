package stacks_and_queues;

import java.util.ArrayList;

/**
 * Created by mjhamrick on 12/21/16.
 */
public class _1 {

    // Three in One: Describe how you could use a single array to implement three stacks.
    // Hints: #2, #72, #38, #58

    public static class TripleStack<T> {
        private static final int numberOfStacks = 3;
        private int capacity;
        private Object[] data;
        private int[] sizes;

        public TripleStack(int capacity) {
            this.capacity = capacity;
            this.data = new Object[capacity * numberOfStacks];
            this.sizes = new int[numberOfStacks];
        }

        public void push(int stackNumber, T value) {
            if (isFull(stackNumber)) throw new StackOverflowError();

            sizes[stackNumber]++;
            data[indexOfTop(stackNumber)] = value;
        }

        private int indexOfTop(int stackNumber) {
            int offset = stackNumber * capacity;
            int size = sizes[stackNumber];
            return offset + size - 1;
        }

        private boolean isFull(int stackNumber) {
            return sizes[stackNumber] == capacity;
        }

        public T pop(int stackNumber) {
            if (isEmpty(stackNumber)) throw new StackOverflowError();

            int topindex = indexOfTop(stackNumber);
            T value = (T) data[topindex]; // Get top
            data[topindex] = null; // clear old value
            sizes[stackNumber]--; // Shrink
            return value;
        }

        public T peek(int stackNumber) {
            if (isEmpty(stackNumber)) throw new StackOverflowError();

            return (T) data[indexOfTop(stackNumber)];
        }

        private boolean isEmpty(int stackNumber) {
            return sizes[stackNumber] == 0;
        }
    }
}
