from threading import Thread, Lock

def map_reduce(task_list, handler, thread_count=0, show_progress=False):
	if show_progress:
		lock = Lock()
		done_count = 0
	task_count = len(task_list)
	if thread_count <= 0 or thread_count > task_count:
		thread_count = task_count
	def callback(index):
		nonlocal done_count
		while index < task_count:
			task_list[index] = handler(task_list[index])
			index += thread_count
			if show_progress:
				with(lock):
					done_count += 1
					print(done_count, "/", task_count)
	thread_list = [Thread(target=callback, args=(i,)) for i in range(thread_count)]
	for thread in thread_list: thread.start()
	for thread in thread_list: thread.join()

if __name__ == "__main__":
	print("hello")
	task_list = [1,2,3]
	map_reduce(task_list, lambda i:i+1, show_progress=True)
	print(task_list)
	input()