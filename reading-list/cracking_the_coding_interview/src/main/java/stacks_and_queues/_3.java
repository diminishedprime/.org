package stacks_and_queues;

import java.util.Arrays;

/**
 * Created by mjhamrick on 12/23/16.
 */
public class _3 {

    // Stack of Plates: Imagine a (literal) stack of plates. If the stack gets too high,
    // it might topple. Therefore, in real life, we would likely start a new stack when
    // the previous stack exceeds some threshold. Implement a data structure, SetOfStacks
    // that mimics this. SetOfStacks should be composed of several stacks and should create
    // a new stack once the previous one exceeds capacity. SetOfStacks. push() and
    // SetOfStacks. pop() should behave identically to a single stack (that is, pop()
    // should return the same values as it would if there were just a single stack).
    // FOLLOW UP
    // Implement a function popAt(int index) which performs a pop operation on a specific
    // sub-stack.
    // Hints:#64, #87

    public static class SetOfStacks<T> {

        @Override
        public String toString() {
            return "SetOfStacks{" +
                    "currentStackIndex=" + currentStackIndex +
                    ", stacks=" + Arrays.toString(stacks) +
                    '}';
        }

        private int currentStackIndex = 0;
        private static final int maximumSize = 3;
        private static final int defaultStackNumber = 10;
        private MyStack<T>[] stacks = new MyStack[defaultStackNumber];

        public void push(T value) {
            if (currentStackIndex >= defaultStackNumber) throw new StackOverflowError();

            MyStack<T> currentStack = currentStack();
            if (currentStack.size() >= maximumSize) {
                currentStackIndex++;
                this.push(value);
            } else {
                currentStack.push(value);
            }
        }

        private MyStack<T> currentStack() {
            MyStack<T> stack = stacks[currentStackIndex];
            if (stack == null) {
                stacks[currentStackIndex] = new MyStack<T>();
                return currentStack();
            } else {
                return stack;
            }
        }

        public T pop() {
            MyStack<T> currentStack = currentStack();
            if (currentStack.size() == 0) {
                currentStackIndex--;
                return this.pop();
            } else {
                return currentStack.pop();
            }
        }

        public T popAt(int index) {
            return stacks[index].pop();
        }
    }

}
