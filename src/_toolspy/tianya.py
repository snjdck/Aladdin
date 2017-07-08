from map_reduce import *
from urllib.request import urlopen
import re
from itertools import chain

DIV_END = "</div>"

def findPairDiv(content, text):
	begin = content.index(text)
	end = begin + len(text)
	while True:
		end = content.index(DIV_END, end) + len(DIV_END)
		if content.count("<div", begin, end) == content.count(DIV_END, begin, end):
			return content[begin:end]

def queryPageCount(pageID):
	content = load(pageID)
	pageTitle = re.search(r'<title>(.*?)</title>', content).group(1)
	userID = re.search(r'_hostid="(\d+)"', content).group(1)
	indexList = re.findall(r'<a href="/post-\w+-\d+-(\d+).shtml">\1</a>', content)
	pageCount = max(map(int, indexList))
	cssList = re.findall(r'<link href="[^"]+" rel="stylesheet" type="text/css" />', content)
	return pageCount, userID, pageTitle, cssList

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
	itemList = re.findall(r'<div class="atl-item[^>]+>', content)
	itemList = [findPairDiv(content, item) for item in itemList]
	infoList = re.findall(r'<div class="atl-item[^>]+_hostid="(\d+)"[^>]*>', content)
	#textList = re.findall(r'<div class="bbs-content[^"]*">(.*?)</div>', content, re.S)
	flagList = [user == userID for user in infoList]
	for i, flag in enumerate(flagList):
		if flag: continue
		item = itemList[i]
		if '<div class="ir-list">' in item:
			text = findPairDiv(item, '<div class="ir-list">')
			if f'_userid="{userID}"' in text:
				flagList[i] = text
	
	assert len(infoList) == len(itemList)
	return [clear(text) for text, flag in zip(itemList, flagList) if flag]

def clear(content):
	content = re.sub('style="display:none"', "", content)
	sub_list = ['<div class="ir-page"', '<div class="ir-action-btn">', '<div class="atl-reply">']
	for sub in sub_list:
		if sub in content:
			content = re.sub(sub + r".*?</div>", "", content, 0, re.S)

	#content = re.sub("\u3000", "", content)
	#content = re.sub(r"@.+?<br>", "", content)
	#content = re.sub(r"^\s*|\s*$", "", content, 0, re.M)
	#content = re.sub(r"<br>", "\r\n", content)
	#content = re.sub(r"<[^>]+?>", "", content)
	return content

def fetchArticle(pageID):
	pageCount, userID, pageTitle, cssList = queryPageCount(pageID)
	taskList = [(pageID, i+1, userID) for i in range(pageCount)]
	map_reduce(taskList, loadPage, 4, True)
	return chain(*taskList), pageTitle, cssList

def loadPage(info):
	return exact(load(*info[:2]), info[2])

line = "<br><br><br><br>"

def fetchArticleAndSave(pageID):
	articleList, pageTitle, cssList = fetchArticle(pageID)
	pageData = "\n".join(cssList) + line.join(articleList)
	with open(f"{pageTitle[:-10]}_{pageID[1]}.html", "wb") as f:
		f.write(pageData.encode())

if __name__ == "__main__":
	#, ("develop", 1309480)
	taskList = [("develop", 2165689), ("develop", 2153711), ("develop", 969483), ("develop", 2212810), ("develop", 2229231), ("house", 718326), ("house", 705917)]
	taskList += [("develop", 2218199), ("develop", 2191368), ("house", 648307)]
	#taskList = [("develop", 2229231)]
	parallel_do(taskList, fetchArticleAndSave)
	input("finished")
	

