
# The config-tool method should not be needed but SDL2 2.10.2
# provide a pkg-config file that is inaccurate as it does not include
# the libraries -lm -ldl -lrt (on linux).
# By using the config-tool method we require the sdl2-config tool instead
# of pkg-config.
libsdl2 = dependency('sdl2', method: 'config-tool')
opengl = dependency('GL')

imgui_graphics = get_option('graphics')

# SDL2 in needed below with opengl, threads, joystick and timer support.
# FIXME: handle case where SDL2 is not available
imgui_impl_sources = ['imgui_impl_sdl.cpp']
if imgui_graphics == 'opengl2'
    imgui_impl_sources += 'imgui_impl_opengl2.cpp'
elif imgui_graphics == 'opengl3'
    imgui_impl_sources += ['imgui_impl_opengl3.cpp', 'libs/gl3w/GL/gl3w.c']
    imgui_cflags += '-DIMGUI_IMPL_OPENGL_LOADER_GL3W'
else
    error('Unsupported graphics option: ' + get_option('graphics'))
endif

# gl3w below is only really needd for opengl3
imgui_examples_include = include_directories('.', 'libs/gl3w')

libimgui_impl = library('imgui_impl',
    imgui_impl_sources,
    cpp_args: imgui_cflags,
    include_directories: [imgui_include, imgui_examples_include],
    dependencies: [libsdl2, opengl],
    install: true
)

pkg = import('pkgconfig')

# FIXME: add libimgui impl
pkg.generate(libimgui,
    filebase : 'imgui',
    name : 'imgui',
    description : 'Dear ImGui, immediate mode GUI interface for C++',
    url : 'github.com/ocornut/imgui',
)

subdir('example_sdl_' + imgui_graphics)
