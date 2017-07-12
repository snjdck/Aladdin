from map_reduce import *
from urllib.request import urlopen
import re
import os
import json
from itertools import chain, count

HOST_ID = re.compile(r'_hostid="(\d+)"')

def findPairDiv(content, tag_begin):
	begin = content.index(tag_begin)
	end = begin + len(tag_begin)
	tag = re.search(r"^<(\w+)\s", tag_begin).group(1)
	tag_begin, tag_end = f"<{tag}", f"</{tag}>"
	while True:
		end = content.index(tag_end, end) + len(tag_end)
		if content.count(tag_begin, begin, end) == content.count(tag_end, begin, end):
			return content[begin:end]

def queryPageCount(pageID):
	content = load(pageID)
	pageTitle = re.search(r'<title>(.*?)</title>', content).group(1)
	userID = HOST_ID.search(content).group(1)
	indexList = re.findall(r'<a href="/post-\w+-\d+-(\d+).shtml">\1</a>', content)
	pageCount = max(map(int, indexList))
	cssList = re.findall(r'<link href="[^"]+"\s+rel="stylesheet"\s+type="text/css"\s*/>', content)
	return pageCount, userID, pageTitle, cssList

def load(pageID, index=1):
	path = f"http://bbs.tianya.cn/post-{pageID[0]}-{pageID[1]}-{index}.shtml"
	for tryCount in range(5):
		try:
			with urlopen(path, None, 10) as f:
				assert f.getcode() == 200
				return f.read().decode()
		except Exception as error:
			print(error)

def exact(content, userID):
	itemList = re.findall(r'<div class="atl-item[^>]+>', content)
	itemList = [findPairDiv(content, item) for item in itemList]
	if not host_only_flag: return map(clear, itemList)
	flagList = [HOST_ID.search(item).group(1) == userID for item in itemList]
	userID = f'_userid="{userID}"'
	return [clear(text) for text, flag in zip(itemList, flagList) if flag or userID in text]

def clear(content):
	content = re.sub('style="display:none"', "", content)
	sub_list = ['<div class="ir-page"', '<div class="ir-action-btn">', '<div class="atl-reply">']
	for sub in sub_list:
		if sub in content:
			content = re.sub(sub + r".*?</div>", "", content, 0, re.S)
	return content

def fetchArticle(pageID):
	pageCount, userID, pageTitle, cssList = queryPageCount(pageID)
	taskList = [(pageID, i, userID) for i in range(loadPageIndex(pageID), pageCount+1)]
	map_reduce(taskList, loadPage, 4, True)
	return list(chain(*taskList)), pageTitle, cssList, pageCount

def loadPage(info):
	return exact(load(*info[:2]), info[2])

def fetchArticleAndSave(pageID):
	articleList, pageTitle, cssList, pageCount = fetchArticle(pageID)
	pageData = "\r\n".join(cssList + articleList)

	filePath = f"{pageTitle[:-10]}_{pageID[1]}.html"
	for i in count(1):
		if not os.path.exists(filePath): break
		filePath = f"{pageTitle[:-10]}_{pageID[1]}_{i}.html"

	with open(filePath, "wb") as f:
		f.write(pageData.encode())

	savePageIndex(pageID, pageCount)

def loadPageIndex(pageID):
	filePath = f"{pageID[0]}_{pageID[1]}.txt"
	if os.path.exists(filePath):
		with open(filePath) as f:
			return int(f.read())
	return 1

def savePageIndex(pageID, pageCount):
	filePath = f"{pageID[0]}_{pageID[1]}.txt"
	with open(filePath, "w")  as f:
		f.write(str(pageCount))

host_only_flag = False

if __name__ == "__main__":
	source = json.load(open("tianya.txt"))
	taskList = [(k, i)for k, v in source.items() for i in v]
	parallel_do(taskList, fetchArticleAndSave)
	input("finished")
	

