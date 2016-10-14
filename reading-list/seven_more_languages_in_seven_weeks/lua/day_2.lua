function concatenate(a1, a2)
  local result = {}
  for i = 1, #a1 do
    result[#result + 1] = a1[i]
  end
  for i = 1, #a2 do
    result[#result + 1] = a2[i]
  end
  return result
end

print(#concatenate({1,2,3}, {4,5,6}))

function newindex(table, key, value)
  rawset(table, key, value)
  if type(value) == "table" then
    setmetatable(table[key], { __add = concatenate })
  end
end

local mt = { __newindex = newindex }
setmetatable(_G, mt)

table1 = {1,2,3}
table2 = {1,2,3}

result = table1 + table2
print(#result)

function retry(count, inner)
  local errMsg = nil
  for i=1,count do
    local f = coroutine.create(inner)
    _, errMsg = coroutine.resume(f)
    if not errMsg then
      return
    end
  end
  if errMsg then
    print(errMsg)
  end
end
