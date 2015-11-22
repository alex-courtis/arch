local menu_gen_monkey = {}

function menu_gen_monkey.patch(menubar)

    -- sort local applications after global
    menubar.menu_gen.all_menu_dirs = { '/usr/share/applications/', '/usr/local/share/applications/', os.getenv("HOME") .. '/.local/share/applications/' }
    
    -- monkey functions
    local function get_category_name_and_usage_by_type(app_type)
        for k, v in pairs(menu_gen.all_categories) do
            if app_type == v.app_type then
                return k, v.use
            end
        end
    end
    local function trim(s)
        if not s then return end
        if string.byte(s, #s) == 13 then
            return string.sub(s, 1, #s - 1)
        end
        return s
    end
    
    -- monkey override
    menubar.menu_gen.generate = function()
        -- monkey hooks
        menu_gen = menubar.menu_gen
        utils = require("menubar.utils")
    
        -- Update icons for category entries
        menu_gen.lookup_category_icons()
    
        local result = {}
    
        for _, dir in ipairs(menu_gen.all_menu_dirs) do
            local entries = utils.parse_dir(dir)
            for _, program in ipairs(entries) do
                -- Check whether to include program in the menu
                if program.show and program.Name and program.cmdline then
                    local target_category = nil
                    -- Check if the program falls at least to one of the
                    -- usable categories. Set target_category to be the id
                    -- of the first category it finds.
                    if program.categories then
                        for _, category in pairs(program.categories) do
                            local cat_key, cat_use =
                                get_category_name_and_usage_by_type(category)
                            if cat_key and cat_use then
                                target_category = cat_key
                                break
                            end
                        end
                    end
                    --if target_category then
                        local name = trim(program.Name) or ""
                        local cmdline = trim(program.cmdline) or ""
                        local icon = utils.lookup_icon(trim(program.icon_path)) or nil
                        table.insert(result, { name = name,
                                               cmdline = cmdline,
                                               icon = icon,
                                               category = target_category })
                    --end
                end
            end
        end
        return result
    end
end

return menu_gen_monkey
