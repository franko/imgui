project('imgui', 'cpp')

cc = meson.get_compiler('cpp')
libm = cc.find_library('m', required : false)
libdl = cc.find_library('dl', required : false)

imgui_truetype = get_option('truetype')

imgui_include = include_directories('backends')

imgui_options = ['IMGUI_IMPL_OPENGL_LOADER_GLEW', 'IMGUI_DISABLE_OBSOLETE_FUNCTIONS']
if get_option('largeidx')
    imgui_options += 'IMGUI_DRAWIDX_SIZE_32'
endif

# imgui_window_backends = {
#     'sdl':   {'example': 'sdl',   'require': ['sdl2'],  'source_ext': '.cpp'},
#     'glfw':  {'example': 'glfw',  'require': ['glfw3'], 'source_ext': '.cpp'},
#     'win32': {'example': 'win32', 'require': [],        'source_ext': '.cpp'},
#     'osx':   {'example': 'apple', 'require': [],        'source_ext': '.mm'},
# }

# imgui_render_backends = {
#     'opengl2': {'example': 'opengl2',   'require': ['gl'], 'source_ext': '.cpp'},
#     'opengl3': {'example': 'opengl3',   'require': ['gl'], 'source_ext': '.cpp'},
#     'dx9':     {'example': 'directx9',  'require': [],     'source_ext': '.cpp'},
#     'dx10':    {'example': 'directx10', 'require': [],     'source_ext': '.cpp'},
#     'dx11':    {'example': 'directx11', 'require': [],     'source_ext': '.cpp'},
#     'dx12':    {'example': 'directx12', 'require': [],     'source_ext': '.cpp'},
#     'vulkan':  {'example': 'vulkan',    'require': ['vulkan'], 'source_ext': '.cpp' },
#     'metal':   {'example': 'metal',     'require': [],     'source_ext': '.mm' },
# }

glew_dep = dependency('glew')

imgui_deps = [glew_dep, libm, libdl]
if imgui_truetype == 'freetype'
    freetype_dep = dependency('freetype2')
    imgui_options += 'IMGUI_ENABLE_FREETYPE'
    imgui_deps += freetype_dep
elif imgui_truetype == 'stb'
    imgui_options += 'IMGUI_ENABLE_STB_TRUETYPE'
else
    error('unknown truetype option: ' + imgui_truetype)
endif

imgui_config_script = find_program('imgui-config.sh')

imconfig_h = custom_target(
    'imconfig.h',
    output : 'imconfig.h',
    command : [imgui_config_script, '@OUTPUT@', files('imconfig-sample.h'), imgui_options],
    install_dir : 'include',
    install : true,
)

imgui_src = ['imgui.cpp', 'imgui_draw.cpp', 'imgui_tables.cpp', 'imgui_widgets.cpp']

if imgui_truetype == 'freetype'
    imgui_src += 'misc/freetype/imgui_freetype.cpp'
endif

imgui_lib = library('imgui',
    imgui_src + [imconfig_h],
    include_directories: imgui_include,
    dependencies: imgui_deps,
    install: true
)

if get_option('sdl')
    imgui_sdl_deps = [ dependency('sdl2', method : 'config-tool') ]
    imgui_sdl_lib = library('imguisdl', 'backends/imgui_impl_sdl.cpp',
        dependencies : imgui_sdl_deps,
        link_with : imgui_lib,
        install : true,
    )
    install_headers('backends/imgui_impl_sdl.h')
endif


if get_option('opengl3')
    imgui_opengl3_deps = [ dependency('gl') ]
    imgui_opengl3_lib = library('imguiopengl3',
        'backends/imgui_impl_opengl3.cpp',
        dependencies : imgui_opengl3_deps,
        link_with : imgui_lib,
        install : true,
    )
    install_headers('backends/imgui_impl_opengl3.h')
endif


if get_option('sdl') and get_option('opengl3')
    executable('imgui-demo',
        ['imgui_demo.cpp', 'examples/example_sdl_opengl3/main.cpp', imconfig_h],
        dependencies: imgui_deps + imgui_sdl_deps + imgui_opengl3_deps,
        include_directories: imgui_include,
        link_with: [imgui_lib, imgui_sdl_lib, imgui_opengl3_lib],
        install: true,
    )
endif

install_headers(
    'imgui.h',
    'imgui_internal.h',
    'imstb_textedit.h',
)

if imgui_truetype == 'freetype'
    install_headers('misc/freetype/imgui_freetype.h')
endif

pkg = import('pkgconfig')

pkg.generate(imgui_lib,
    filebase : 'imgui',
    name : 'imgui',
    libraries : imgui_lib,
    description : 'Dear ImGui library',
    url : 'http://github.com/ocornut/imgui',
)

if get_option('sdl')
    pkg.generate(imgui_sdl_lib,
        filebase : 'imguisdl',
        name : 'imguisdl',
        libraries : [imgui_lib, imgui_sdl_lib],
        description : 'Dear ImGui library SDL2 support',
        url : 'http://github.com/ocornut/imgui',
    )
endif

if get_option('opengl3')
    pkg.generate(imgui_opengl3_lib,
        filebase : 'imguiopengl3',
        name : 'imguiopengl3',
        libraries : [imgui_lib, imgui_opengl3_lib],
        description : 'Dear ImGui library OpenGL3 support',
        url : 'http://github.com/ocornut/imgui',
    )
endif

