import re, os, sys
from agal import run

class Module: pass
class ModuleLoader():
	def find_module(self, name, path=None):
		self.path = os.path.join(os.path.dirname(__file__), name + ".py")
		if os.path.exists(self.path):
			return self

	def load_module(self, name):
		with open(self.path) as f:
			data = f.read()
			data = re.sub(r"(?<!\w)(op|oc)(?!\w|\[)", r"\1[0]",  data)
			data = re.sub(r"(?<!\w)(op|oc|v)(\d+)",   r"\1[\2]", data)
		module = Module()
		exec(compile(data, self.path, "exec"), module.__dict__)
		sys.modules[name] = module
		return module

def main(file_path):
	file_name = os.path.basename(file_path)
	module = __import__(file_name[:file_name.index(".")])

	va = run(module.vertex)
	fs = run(module.fragment)

	for k, v in va.items():
		print(k, v)
	print()
	for k, v in fs.items():
		print(k, v)
	return ""

if __name__ == "__main__":
	#sys.meta_path.insert(0, ModuleLoader())
	input(main(sys.argv[1]))