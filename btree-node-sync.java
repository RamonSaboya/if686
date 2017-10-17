import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;

import javafx.util.Pair;

class BTree {

	private Integer root;
	private BTree left;
	private BTree right;

	public BTree() {
		this.root = null;
		this.left = null;
		this.right = null;
	}

	public void insert(int value) {
		if (root == null) {
			this.root = value;
			this.left = new BTree();
			this.right = new BTree();
		} else if (value < root) {
			synchronized (right) {
				right.insert(value);
			}
		} else {
			synchronized (left) {
				left.insert(value);
			}
		}
	}

	public int size() {
		if (root == null) {
			return 1;
		} else {
			return left.size() + right.size();
		}
	}

}

public class PLC {

	private static Random random = new Random();

	public static void main(String[] args) {
		Pair<Long, Integer> single = singleThread(2000);
		System.out.println("============== SingleThread ==============");
		System.out.printf("Tempo de execução: %d%n", single.getKey());
		System.out.printf("Tamanho da árvore: %d%n", single.getValue());

		Pair<Long, Integer> multi = multiThread(100, 2000);
		System.out.println("============== MultiThread ==============");
		System.out.printf("Tempo de execução: %d%n", multi.getKey());
		System.out.printf("Tamanho da árvore: %d%n", multi.getValue());
	}

	private static Pair<Long, Integer> singleThread(int values) {
		long start = System.nanoTime();

		BTree tree = new BTree();
		for (int i = 0; i < values; i++) {
			tree.insert(random.nextInt());
		}

		int nodes = tree.size() - 1;

		Pair<Long, Integer> pair = new Pair<Long, Integer>(System.nanoTime() - start, nodes);

		return pair;
	}

	private static Pair<Long, Integer> multiThread(int threads, int values) {
		long start = System.nanoTime();

		List<Thread> threadList = new ArrayList<Thread>();
		AtomicInteger count = new AtomicInteger(values);

		BTree tree = new BTree();
		for (int i = 0; i < threads; i++) {
			threadList.add(new Thread(() -> {
				while (count.getAndDecrement() > 0) {
					tree.insert(random.nextInt());
				}
			}));

			threadList.get(threadList.size() - 1).start();
		}

		for (Thread thread : threadList) {
			try {
				thread.join();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}

		int nodes = tree.size() - 1;

		Pair<Long, Integer> pair = new Pair<Long, Integer>(System.nanoTime() - start, nodes);

		return pair;
	}

}
