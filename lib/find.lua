--- Finds the index of a value in a table.
--- @param t table The table to search in.
--- @param value any The value to find.
--- @param start number (optional) The starting index to search from. Defaults to 1.
--- @param finish number (optional) The ending index to search until. Defaults to the length of the table.
--- @return number|nil The index of the value if found, or nil if not found.
function table.find(t, value, start, finish)
    start = start or 1
    finish = finish or #t
    for i = start, finish do
        if t[i] == value then
            return i
        end
    end
    return nil
end
