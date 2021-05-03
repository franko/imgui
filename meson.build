project('imgui', 'cpp')

imgui_src = ['imgui.cpp', 'imgui_draw.cpp', 'imgui_tables.cpp', 'imgui_widgets.cpp']
imgui_backend_src = ['backends/imgui_impl_sdl.cpp', 'backends/imgui_impl_opengl3.cpp']

cc = meson.get_compiler('cpp')
libm = cc.find_library('m', required : false)
libdl = cc.find_library('dl', required : false)
opengl_dep = dependency('gl')
glew_dep = dependency('glew')
freetype_dep = dependency('freetype2')
sdl_dep = dependency('sdl2', method: 'config-tool')

imgui_include = include_directories('backends')
imgui_cargs = ['-DIMGUI_IMPL_OPENGL_LOADER_GLEW', '-DIMGUI_ENABLE_FREETYPE']

imgui_lib = static_library('imgui',
    imgui_src + imgui_backend_src,
    include_directories: imgui_include,
    dependencies: [freetype_dep, glew_dep, sdl_dep],
    c_args: imgui_cargs,
    install: true
)

executable('imgui-demo',
    ['imgui_demo.cpp', 'examples/example_sdl_opengl3/main.cpp'],
    dependencies: [glew_dep, sdl_dep, opengl_dep, libm, libdl],
    include_directories: imgui_include,
    c_args: imgui_cargs,
    link_with: imgui_lib
)
