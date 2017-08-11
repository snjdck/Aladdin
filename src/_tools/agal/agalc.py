import re, os, sys
from agal import run
from agalw import CodeWriter, FileWriter
from agalo import *

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
	file_name = file_name[:file_name.index(".")]
	module = __import__(file_name)

	va = run(module.vertex)
	fs = run(module.fragment)

	test(va.output_code)

	CodeWriter().compile(va, 0, 1)
	CodeWriter().compile(fs, 1, 1)

	save_path = os.path.join(os.path.dirname(file_path), "__agal__")
	if not os.path.exists(save_path): os.mkdir(save_path)
	FileWriter().write(va, fs).save(os.path.join(save_path, file_name))

if __name__ == "__main__":
	#sys.meta_path.insert(0, ModuleLoader())
	input(main(sys.argv[1]))
	#main(sys.argv[1])