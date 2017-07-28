import re, os, sys
from agal import *

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

	run(module.vertex)
	run(module.fragment)

	for k, v in enumerate(vc.const):
		if v is None: continue
		print(k, v)
	for k, v in enumerate(fc.const):
		if v is None: continue
		print(k, v)

	print("va usage", va.usage)
	print("fs usage", fs.usage)

if __name__ == "__main__":
	sys.meta_path.insert(0, ModuleLoader())
	input(main(sys.argv[1]))