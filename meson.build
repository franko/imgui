project('dear-imgui', 'c', 'cpp', version: '1.76', default_options : [
    'cpp_std=c++11', # the project does not even require C++11
    'default_library=static',
])

imgui_cflags = []
imgui_include = include_directories('.')
imgui_sources = ['imgui.cpp', 'imgui_draw.cpp', 'imgui_widgets.cpp']

libimgui = library('imgui',
    imgui_sources,
    cpp_args: imgui_cflags,
    include_directories: imgui_include,
    # dependencies: [],
    install: true
)

imgui_demo_source = files('imgui_demo.cpp')

subdir('examples')
