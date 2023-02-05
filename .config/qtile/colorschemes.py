sonokai= [
    "#2c2e34",
    "#e2e2e3",
    "#181819",
    "#fc5d7c",
    "#9ed072",
    "#e7c664",
    "#76cce0",
    "#b39df3",
    "#f39660",
    "#e2e2e3",
    "#7f8490",
]
sonokai_shusia= [
    "#2d2a2e",
    "#e3e1e4",
    "#1a181a",
    "#f85e84",
    "#9ecd6f",
    "#e5c463",
    "#7accd7",
    "#ab9df2",
    "#ef9062",
    "#e3e1e4",
    "#848089",
]
sonokai_andromeda= [ 
    "#2b2d3a",
    "#e1e3e4",
    "#181a1c",
    "#fb617e",
    "#9ed06c",
    "#edc763",
    "#6dcae8",
    "#bb97ee",
    "#f89860",
    "#e1e3e4",
    "#7e8294",
]

sonokai_atlantis= [ 
    "#2a2f38",
    "#e1e3e4",
    "#181a1c",
    "#ff6578",
    "#9dd274",
    "#eacb64",
    "#72cce8",
    "#ba9cf3",
    "#f69c5e",
    "#e1e3e4",
    "#828a9a",
]

sonokai_maia= [
    "#273136",
    "#e1e2e3",
    "#1c1e1f",
    "#f76c7c",
    "#9cd57b",
    "#e3d367",
    "#78cee9",
    "#baa0f8",
    "#f3a96a",
    "#e1e2e3",
    "#82878b",
]

sonokai_espresso= [
    "#312c2b",
    "#e4e3e1",
    "#1f1e1c",
    "#f86882",
    "#a6cd77",
    "#f0c66f",
    "#81d0c9",
    "#9fa0e1",
    "#f08d71",
    "#e4e3e1",
    "#90817b",
]

'''
colors = [
    ["#272822", "#272822"],#0 black
    ["#f92672", "#f92672"],#1 red
    ["#a6e22e", "#a6e22e"],#2 green
    ["#f4bf75", "#f4bf75"],#3 yellow
    ["#66d9ef", "#66d9ef"],#4 blue
    ["#ae81ff", "#ae81ff"],#5 magenta
    ["#a1efe4", "#a1efe4"],#6 cyan
    ["#f8f8f2", "#f8f8f2"],#7 white
    ["#75715e", "#75715e"],#8 bright black
]
colors = [
    ["#2d2a2e", "#2d2a2e"],#0 background
    ["#fcfcfa", "#fcfcfa"],#1 foreground
    ["#403e41", "#403e41"],#2 black
    ["#ff6188", "#ff6188"],#3 red
    ["#a9dc76", "#a9dc76"],#4 green
    ["#ffd866", "#ffd866"],#5 yellow
    ["#fc9867", "#fc9867"],#6 blue
    ["#ab9df2", "#ab9df2"],#7 magenta
    ["#78dce8", "#78dce8"],#8 cyan
    ["#fcfcfa", "#fcfcfa"],#9 white
    ["#727072", "#727072"],#10 bright black
]
'''
base = sonokai
# by color picker, i.e. influenced by background
opensuse_dirty = [
    "#033434", # background
    base[1], # foreground
    base[2], # black
    "#7c6532", # kurisu orange head 50
    "#63a23f", # opensuse logo
    "#4e5b34", # kurisu yellow middle 50
    "#0c4e44", # leap symbol; dark cyan
    "#073d39", # darker cyan
    "#194e37", # less lime than logo; large circles
    "#404d33", # transparent orange
    "#1c5037", # kurisu green feet 50
]
# by selection
opensuse_pure = [
    "#033434", # background
    base[1], # foreground
    base[2], # black
    "#f89931", # orange pure
    "#80c342", # opensuse logo lime pure
    "#bcae39", # yellow between orange and logo lime
    "#7fc142", # other lime pure
    "#31b681", # darker cyan pure (same as for leap logo here)
    "#31b681", # darker cyan pure (same as for leap logo here)
    "#31b681", # darker cyan pure (same as for leap logo here)
    "#31b681", # darker cyan pure (same as for leap logo here)
]

sonokai_opensuse = [
    "#033434", # background
    base[1], # foreground
    base[2], # black
    opensuse_pure[3], # orange pure
    opensuse_pure[4], # green 
    opensuse_pure[5], # yellow
    opensuse_dirty[6], # blue
    base[7], # magenta
    opensuse_pure[8], # dark cyan pure (same as for leap logo here)
    base[9], # white
    base[10], # bright black 
]
colors = sonokai_opensuse
