# here be dragons: 
# a quick and dirty script to search 
# contents of files in a folder and return results in 
# a formatted list for alfred

arr = ARGV
query = arr.join(" ")
cmd = "grep -ri --exclude-dir .git . -e #{query}"
fcmd = "find . -name \"*#{query}*\""

dir = "~/notes"
val = `cd #{dir};#{cmd}`
fval = `cd #{dir};#{fcmd}`

out = val.split(/\n+/)
fout = fval.split(/\n+/)
# puts out.length
results = []

for i in fout
	item = []

	split = i.split(/:/)
	path = "#{dir}/#{split[0][2..i.length]}"

	fp = path.split(/\//)
	file = fp[fp.length-1]

	item.push(file)
	item.push(file)
	item.push(path)

	results.push(item)
end

for i in out
	item = []

	split = i.split(/:/)
	path = "#{dir}/#{split[0][2..i.length]}"
	found = split[1]

	fp = path.split(/\//)
	file = fp[fp.length-1]

	item.push(found)
	item.push(file)
	item.push(path)

	results.push(item)
end
# puts results.to_s

response = "{\"items\": ["
c=0
for i in results
	response += "{\"uid\": \"item#{c}\",\"type\": \"file\",\"title\": \"#{i[0]}\",\"subtitle\": \"#{i[1]}\",\"arg\": \"#{i[2]}\",\"autocomplete\": \"\",\"icon\": {\"type\": \"fileicon\",\"path\": \"#{i[2]}\"}},"
	c=c+1
end
if results.length > 1
	response = response[0..response.length-2]
end
response += "]}"

puts response
