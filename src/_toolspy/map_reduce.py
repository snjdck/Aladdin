from multiprocessing import Process
from threading import Thread, Lock

def _start_and_join(thread_list):
	for thread in thread_list: thread.start()
	for thread in thread_list: thread.join()


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
				with lock:
					done_count += 1
					print(done_count, "/", task_count)
	_start_and_join([Thread(target=callback, args=(i,)) for i in range(thread_count)])


def parallel_do(task_list, handler, thread_count=0):
	task_count = len(task_list)
	if thread_count <= 0 or thread_count > task_count:
		thread_count = task_count
	_start_and_join([Process(target=_parallel_handler, args=(task_list, handler, thread_count, i)) for i in range(thread_count)])


def _parallel_handler(task_list, handler, thread_count, index):
	while index < len(task_list):
		handler(task_list[index])
		index += thread_count
