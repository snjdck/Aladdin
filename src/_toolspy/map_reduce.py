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
				with lock:
					done_count += 1
					print(done_count, "/", task_count)
	thread_list = [Thread(target=callback, args=(i,)) for i in range(thread_count)]
	for thread in thread_list: thread.start()
	for thread in thread_list: thread.join()

from urllib.request import urlopen
import re

if __name__ == "__main__":
	task_list = ["http://baidu.com", "http://sogou.com"]
	def handler(path):
		with urlopen(path) as f:
			#print(f.getcode(), f.info())
			data = f.read().decode()
			match = re.search(r'<meta http-equiv="refresh" content="\d+;url=(.+?)">', data)
			if match:
				return handler(match.group(1))
			return data

	map_reduce(task_list, handler, show_progress=True)
	print(task_list)
	input()