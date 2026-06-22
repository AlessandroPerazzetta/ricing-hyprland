---@module 'hl'

-- TODO: manual review: max-gamma = 150

hl.config({
    profile = {
        time = "7:30",
        identity = true,
    },
})
-- NOTE: Section 'profile' may be a plugin or custom section; verify the output

hl.config({
    profile = {
        time = "20:00",
        temperature = 5896,
        gamma = 0.8,
    },
})
-- NOTE: Section 'profile' may be a plugin or custom section; verify the output
