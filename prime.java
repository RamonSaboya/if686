import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Main {

	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);

		int n, x, l;

		n = 10000;
		x = 150;

		final boolean notPrime[] = new boolean[n + 1];

		notPrime[1] = true;

		l = (int) Math.sqrt(n);

		if (x >= (l - 1)) {
			List<Thread> threads = new ArrayList<Thread>();

			System.out.println(l);
			for (int i = 2; i <= l; i++) {
				if (!isPrimeLazy(i)) {
					continue;
				}

				final int multiplier = i;

				threads.add(new Thread(() -> {
					System.out.println("MUltiplos de " + multiplier);
					for (int c = multiplier * 2; c <= n; c += multiplier) {
						notPrime[c] = true;
					}
				}));

				threads.get(threads.size() - 1).start();
			}

			for (int i = 0; i < threads.size(); i++) {
				try {
					threads.get(i).join();
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}

			for (int i = 1; i <= n; i++) {
				if (!notPrime[i]) {
					System.out.println(i);
				}
			}
		}
	}

	private static boolean isPrimeLazy(int n) {
		for (int i = 2; i <= Math.sqrt(n); i++) {
			if (n % i == 0) {
				return false;
			}
		}
		return true;
	}
}
