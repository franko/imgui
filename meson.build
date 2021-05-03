project('imgui', 'cpp')

cc = meson.get_compiler('cpp')
libm = cc.find_library('m', required : false)
libdl = cc.find_library('dl', required : false)

opengl_dep = dependency('gl')
glew_dep = dependency('glew')
freetype_dep = dependency('freetype2')
sdl_dep = dependency('sdl2', method: 'config-tool')

imgui_include = include_directories('backends')

# As an alternative IMGUI_ENABLE_STB_TRUETYPE can be defined to use stb_truetype
# instead.
imgui_options = ['IMGUI_IMPL_OPENGL_LOADER_GLEW', 'IMGUI_ENABLE_FREETYPE']

imgui_config_script = find_program('imgui-config.sh')

imconfig_h = custom_target(
    'imconfig.h',
    output : 'imconfig.h',
    command : [imgui_config_script, '@OUTPUT@', imgui_options],
    install_dir : 'include',
    install : true,
)

# We hard-code the SDL2 + OpenGL3 backend but ImGui supports other
# backends.
imgui_src = ['imgui.cpp', 'imgui_draw.cpp', 'imgui_tables.cpp', 'imgui_widgets.cpp']
imgui_backend_src = ['backends/imgui_impl_sdl.cpp', 'backends/imgui_impl_opengl3.cpp']

imgui_lib = static_library('imgui',
    imgui_src + imgui_backend_src + [imconfig_h],
    include_directories: imgui_include,
    dependencies: [freetype_dep, opengl_dep, glew_dep, sdl_dep],
    install: true
)

executable('imgui-demo',
    ['imgui_demo.cpp', 'examples/example_sdl_opengl3/main.cpp', imconfig_h],
    dependencies: [glew_dep, sdl_dep, opengl_dep, libm, libdl],
    include_directories: imgui_include,
    link_with: imgui_lib,
    install: true,
)

# We should not need the stb header files:
# 'imstb_rectpack.h', 'imstb_textedit.h', 'imstb_truetype.h'
#
# We don't need to install 'imgui_internal.h' either.

install_headers('imgui.h', 'backends/imgui_impl_sdl.h', 'backends/imgui_impl_opengl3.h')

pkg = import('pkgconfig')

pkg.generate(imgui_lib,
    filebase : 'imgui',
    name : 'imgui',
    libraries : imgui_lib,
    description : 'Dear ImGui library',
    url : 'http://github.com/ocornut/imgui',
)

