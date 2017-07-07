from map_reduce import *
from urllib.request import urlopen
import re
from functools import reduce
from operator import add


def queryPageCount(pageID):
	content = load(pageID)
	pageTitle = re.search(r'<title>(.*?)</title>', content).group(1)
	userID = re.search(r'_hostid="(\d+)"', content).group(1)
	indexList = re.findall(r'<a href="/post-\w+-\d+-(\d+).shtml">\1</a>', content)
	pageCount = max(int(index) for index in indexList)
	return pageCount, userID, pageTitle

def load(pageID, index=1):
	path = f"http://bbs.tianya.cn/post-{pageID[0]}-{pageID[1]}-{index}.shtml"
	tryCount = 0
	while tryCount < 5:
		try:
			with urlopen(path, None, 10) as f:
				assert f.getcode() == 200
				return f.read().decode()
		except Exception as error:
			print(error)
			tryCount += 1

def exact(content, userID):
	infoList = re.findall(r'<div class="atl-item[^>]+_hostid="(\d+)"[^>]*>', content)
	textList = re.findall(r'<div class="bbs-content[^"]*">(.*?)</div>', content, re.S)
	assert len(infoList) == len(textList)
	return [clear(textList[i]) for i in range(len(textList)) if infoList[i] == userID]

def clear(content):
	content = re.sub("\u3000", "", content)
	content = re.sub(r"@.+?<br>", "", content)
	content = re.sub(r"^\s*|\s*$", "", content, 0, re.M)
	content = re.sub(r"<br>", "\r\n", content)
	content = re.sub(r"<[^>]+?>", "", content)
	return content

def fetchArticle(pageID):
	pageCount, userID, pageTitle = queryPageCount(pageID)
	taskList = [(pageID, i+1, userID) for i in range(pageCount)]
	map_reduce(taskList, loadPage, 4, True)
	return reduce(add, taskList), pageTitle

def loadPage(info):
	return exact(load(*info[:2]), info[2])

line = "\r\n\r\n============================================\r\n\r\n"

def fetchArticleAndSave(pageID):
	articleList, pageTitle = fetchArticle(pageID)
	pageData = line.join(articleList)
	with open(f"{pageTitle[:-10]}.txt", "wb") as f:
		f.write(pageData.encode("utf-8"))

if __name__ == "__main__":
	taskList = [("develop", 2165689), ("develop", 2153711), ("develop", 969483), ("develop", 2212810), ("develop", 2229231), ("house", 718326), ("house", 705917)]
	parallel_do(taskList, fetchArticleAndSave)
	input("finished")
	

