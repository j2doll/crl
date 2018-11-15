# crl.Qt
- Concurrency Runtime Library for Telegram Desktop
- This project uses Qt 5. (2018)
- C++ 17 commpiler is required. 
	- Visual Studio 2017
	- gcc
		- C++17 Support in GCC : https://gcc.gnu.org/projects/cxx-status.html#cxx17
		- GCC has experimental support for the latest revision of the C++ standard, which was published in <b>2017</b>.
		- C++17 features are available as part of "mainline" GCC in the trunk of GCC's repository and in GCC 5 and later. To enable C++17 support, add the command-line parameter -std=c++17 to your g++ command line. Or, to enable GNU extensions in addition to C++17 features, add -std=gnu++17.
		- Important: Because the final ISO C++17 standard is still new, GCC's support is experimental. No attempt will be made to maintain backward compatibility with implementations of C++17 features that do not reflect the final standard.

## Test Code
```cpp
// crl_test.cpp : Defines the entry point for the console application.
//
#include <crl/crl.h>
#include <iostream>
#include <chrono>
#include <numeric>
#include <deque>

void testOutput(crl::queue *queue) {
	for (auto i = 0; i != 1000; ++i) {
		queue->async([i] { std::cout << "Hi from serial queue: " << i << std::endl; });
		if ((i % 100) == 99) {
			crl::async([i] { std::cout << "Hi from async: " << i << std::endl; });
			queue->sync([i] { std::cout << "Hi from queue sync: " << i << std::endl; });
		}
	}
	for (auto i = 0; i != 1000; ++i) {
		crl::async([i] { std::cout << "Hi from crazy: " << i << std::endl; });
	}
}

constexpr auto kQueueCount = 8;

struct CacheLine {
	static constexpr auto kSize = 128; // To be sure.

	int value;
	char padding[kSize - sizeof(int)];
};

int operator+(int already, const CacheLine &a) {
	return already + a.value;
}

std::atomic<int> added = 0;
int testCounting(crl::queue (&queues)[kQueueCount]) {
	CacheLine result[kQueueCount] = { 0 };
	for (auto i = 0; i != 100000; ++i) {
		for (auto j = 0; j != kQueueCount; ++j) {
			queues[j].async([&result, j] { ++result[j].value; });
		}
		if ((i % 10000) == 9999) {
			crl::async([i] { ++added; });
//			const auto j = ((i + 1) / 10000) % kQueueCount;
//			queues[j].sync([j, &result] { ++result[j].value; });
		}
	}
	for (auto j = 0; j != kQueueCount; ++j) {
		queues[j].sync([&result, j] { ++result[j].value; });
	}
	return std::accumulate(std::begin(result), std::end(result), 0) + added;
}

struct MainRequest {
	void (*callable)(void*);
	void *argument;
};
std::deque<MainRequest> MainRequests;

void DrainMainRequests() {
	while (!MainRequests.empty()) {
		auto front = MainRequests.front();
		MainRequests.pop_front();
		front.callable(front.argument);
	}
}

void testMainQueue() {
	auto count = 0;
	auto add = [&] {
		crl::on_main([&] {
			count += 10;
			crl::on_main([&] {
				count += 20;
				crl::on_main([&] {
					count += 30;
				});
			});
		});
	};
	add();
	crl::init_main_queue([](void (*callable)(void*), void *argument) {
		MainRequests.push_back({ callable, argument });
	});
	DrainMainRequests();
	auto a = count;
	add();
	auto b = count;
	add();
	DrainMainRequests();
	auto c = count;
	std::cout << "Should be (0, 0, 120): " << a << ", " << b << ", " << c << std::endl;
}

int main() {
	crl::queue testQueue[kQueueCount];
//	testOutput(&testQueue[0]);
	for (int i = 0; i != 5; ++i) {
		auto start_time = std::chrono::high_resolution_clock::now();
		auto result = testCounting(testQueue);
		auto end_time = std::chrono::high_resolution_clock::now();
		auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time);
		std::cout << "Time: " << ms.count() / 1000. << " (" << result << ")" << std::endl;
	}
	testMainQueue();
	std::cout << "Finished." << std::endl;
	int a = 0;
	std::cin >> a;
	return 0;
}
```

## Tested Environments
- Windows
	- Case 1
		- Windows 10 x64
		- Visual C++ 2017 x64 (v15.8.9)
		- Qt 5.11.2

- Linux
	- Case 2
		- Linux 4.4.0-17134-Microsoft #345-Microsoft Wed Sep 19 17:47:00 PST 2018 x86_64 x86_64 x86_64 GNU/Linux
		- gcc (Ubuntu 7.3.0-27ubuntu1~18.04) 7.3.0
		- Qt 5.9.5

- Mac
	- I do not have a Mac. Somebody give me a test result.

## License and links
- crl has no license file now(2018). https://github.com/telegramdesktop/crl
	- Telegram is under GPL v3 license. https://github.com/telegramdesktop/tdesktop
- crt.Qt is licensed as crt. https://github.com/j2doll/crl.Qt
	- If crl is GPL v3 license, crl.Qt is GPL 3 license.
