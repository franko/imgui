project('imgui', 'cpp')

cc = meson.get_compiler('cpp')
libm = cc.find_library('m', required : false)
libdl = cc.find_library('dl', required : false)

opengl_dep = dependency('gl')
glew_dep = dependency('glew')
sdl_dep = dependency('sdl2', method: 'config-tool')

imgui_include = include_directories('backends')
imgui_deps = [opengl_dep, glew_dep, sdl_dep, libm, libdl]

imgui_options = ['IMGUI_IMPL_OPENGL_LOADER_GLEW']

if get_option('truetype') == 'freetype'
    freetype_dep = dependency('freetype2')
    imgui_options += 'IMGUI_ENABLE_FREETYPE'
    imgui_deps += freetype_dep
else
    imgui_options += 'IMGUI_ENABLE_STB_TRUETYPE'
endif

imgui_config_script = find_program('imgui-config.sh')

imconfig_h = custom_target(
    'imconfig.h',
    output : 'imconfig.h',
    command : [imgui_config_script, '@OUTPUT@', files('imconfig-sample.h'), imgui_options],
    install_dir : 'include',
    install : true,
)

# We hard-code the SDL2 + OpenGL3 backend but ImGui supports other backends.
imgui_src = ['imgui.cpp', 'imgui_draw.cpp', 'imgui_tables.cpp', 'imgui_widgets.cpp']
imgui_backend_src = ['backends/imgui_impl_sdl.cpp', 'backends/imgui_impl_opengl3.cpp']

if get_option('truetype') == 'freetype'
    imgui_src += 'misc/freetype/imgui_freetype.cpp'
endif

imgui_lib = static_library('imgui',
    imgui_src + imgui_backend_src + [imconfig_h],
    include_directories: imgui_include,
    dependencies: imgui_deps,
    install: true
)

executable('imgui-demo',
    ['imgui_demo.cpp', 'examples/example_sdl_opengl3/main.cpp', imconfig_h],
    dependencies: imgui_deps,
    include_directories: imgui_include,
    link_with: imgui_lib,
    install: true,
)

install_headers(
    'imgui.h',
    'imgui_internal.h',
    'imstb_textedit.h',
    'backends/imgui_impl_sdl.h',
    'backends/imgui_impl_opengl3.h',
)

pkg = import('pkgconfig')

pkg.generate(imgui_lib,
    filebase : 'imgui',
    name : 'imgui',
    libraries : imgui_lib,
    description : 'Dear ImGui library',
    url : 'http://github.com/ocornut/imgui',
)

