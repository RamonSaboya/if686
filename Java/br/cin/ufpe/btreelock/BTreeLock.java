package br.cin.ufpe.btreelock;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

import javafx.util.Pair;

class BTree {

	private Integer root;
	private BTree left;
	private BTree right;

	private Lock lock;

	public BTree() {
		this.root = null;
		this.left = null;
		this.right = null;

		this.lock = new ReentrantLock();
	}

	public void insertLock(int value, boolean first) {
		boolean lock;

		if (root == null) {
			this.root = value;
			this.left = new BTree();
			this.right = new BTree();
		} else if (value < root) {
			lock = this.left.lock.tryLock();
			try {
				while (!lock) {
					lock = this.left.lock.tryLock();
				}
				if (!first) {
					this.lock.unlock();
				}
				this.left.insertLock(value, false);
			} finally {
				while(!this.left.lock.tryLock()) {
					this.left.lock.unlock();
				}
			}
		} else {
			lock = this.right.lock.tryLock();
			try {
				lock = this.right.lock.tryLock();
				while (!lock) {
					lock = this.right.lock.tryLock();
				}
				if (!first) {
					this.lock.unlock();
				}
				this.right.insertLock(value, false);
			} finally {
				while(!this.right.lock.tryLock()) {
					this.right.lock.unlock();
				}
			}
		}
	}

	public void insertSync(int value) {
		if (root == null) {
			this.root = value;
			this.left = new BTree();
			this.right = new BTree();
		} else if (value < root) {
			synchronized (right) {
				right.insertSync(value);
			}
		} else {
			synchronized (left) {
				left.insertSync(value);
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

public class BTreeLock {

	private static Random random = new Random();

	public static void main(String[] args) {
		Pair<Long, Integer> singleSync = singleThreadSync(1000);
		System.out.println("============== SingleThreadSync ==============");
		System.out.printf("Tempo de execução: %d%n", singleSync.getKey());
		System.out.printf("Tamanho da árvore: %d%n", singleSync.getValue());

		Pair<Long, Integer> singleLock = singleThreadLock(1000);
		System.out.println("============== SingleThreadLock ==============");
		System.out.printf("Tempo de execução: %d%n", singleLock.getKey());
		System.out.printf("Tamanho da árvore: %d%n", singleLock.getValue());

		Pair<Long, Integer> multiSync = multiThreadSync(50, 2);
		System.out.println("============== MultiThreadSync ==============");
		System.out.printf("Tempo de execução: %d%n", multiSync.getKey());
		System.out.printf("Tamanho da árvore: %d%n", multiSync.getValue());

		Pair<Long, Integer> multiLock = multiThreadLock(50, 2);
		System.out.println("============== MultiThreadLock ==============");
		System.out.printf("Tempo de execução: %d%n", multiLock.getKey());
		System.out.printf("Tamanho da árvore: %d%n", multiLock.getValue());
	}

	private static Pair<Long, Integer> singleThreadSync(int values) {
		long start = System.currentTimeMillis();

		BTree tree = new BTree();
		for (int i = 0; i < values; i++) {
			tree.insertSync(random.nextInt(100));
		}

		int nodes = tree.size() - 1;

		Pair<Long, Integer> pair = new Pair<Long, Integer>(System.currentTimeMillis() - start, nodes);

		return pair;
	}

	private static Pair<Long, Integer> singleThreadLock(int values) {
		long start = System.currentTimeMillis();

		BTree tree = new BTree();
		for (int i = 0; i < values; i++) {
			tree.insertLock(random.nextInt(100), true);
		}

		int nodes = tree.size() - 1;

		Pair<Long, Integer> pair = new Pair<Long, Integer>(System.currentTimeMillis() - start, nodes);

		return pair;
	}

	private static Pair<Long, Integer> multiThreadSync(int threads, int values) {
		long start = System.currentTimeMillis();

		List<Thread> threadList = new ArrayList<Thread>();

		BTree tree = new BTree();
		for (int i = 0; i < threads; i++) {
			threadList.add(new Thread(() -> {
				for (int c = 0; c < values; c++) {
					tree.insertSync(random.nextInt(100));
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

		Pair<Long, Integer> pair = new Pair<Long, Integer>(System.currentTimeMillis() - start, nodes);

		return pair;
	}

	private static Pair<Long, Integer> multiThreadLock(int threads, int values) {
		long start = System.currentTimeMillis();

		List<Thread> threadList = new ArrayList<Thread>();

		BTree tree = new BTree();
		for (int i = 0; i < threads; i++) {
			threadList.add(new Thread(() -> {
				for (int c = 0; c < values; c++) {
					tree.insertLock(random.nextInt(100), true);
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

		Pair<Long, Integer> pair = new Pair<Long, Integer>(System.currentTimeMillis() - start, nodes);

		return pair;
	}

}