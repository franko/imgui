project('imgui', 'cpp')

cc = meson.get_compiler('cpp')
libm = cc.find_library('m', required : false)
libdl = cc.find_library('dl', required : false)

imgui_renderer = get_option('renderer')
imgui_truetype = get_option('truetype')
imgui_window   = get_option('window')

imgui_include = include_directories('backends')

imgui_options = ['IMGUI_IMPL_OPENGL_LOADER_GLEW']

imgui_config_script = find_program('imgui-config.sh')

imconfig_h = custom_target(
    'imconfig.h',
    output : 'imconfig.h',
    command : [imgui_config_script, '@OUTPUT@', files('imconfig-sample.h'), imgui_options],
    install_dir : 'include',
    install : true,
)

imgui_window_backends = {
    'sdl':   {'example': 'sdl',   'require': ['sdl2'],  'source_ext': '.cpp'},
    'glfw':  {'example': 'glfw',  'require': ['glfw3'], 'source_ext': '.cpp'},
    'win32': {'example': 'win32', 'require': [],        'source_ext': '.cpp'},
    'osx':   {'example': 'apple', 'require': [],        'source_ext': '.mm'},
}

imgui_render_backends = {
    'opengl2': {'example': 'opengl2',   'require': ['gl'], 'source_ext': '.cpp'},
    'opengl3': {'example': 'opengl3',   'require': ['gl'], 'source_ext': '.cpp'},
    'dx9':     {'example': 'directx9',  'require': [],     'source_ext': '.cpp'},
    'dx10':    {'example': 'directx10', 'require': [],     'source_ext': '.cpp'},
    'dx11':    {'example': 'directx11', 'require': [],     'source_ext': '.cpp'},
    'dx12':    {'example': 'directx12', 'require': [],     'source_ext': '.cpp'},
    'vulkan':  {'example': 'vulkan',    'require': ['vulkan'], 'source_ext': '.cpp' },
    'metal':   {'example': 'metal',     'require': [],     'source_ext': '.mm' },
}

if imgui_window not in imgui_window_backends
    error('unknown window subsystem type: ' + imgui_window)
endif

if imgui_renderer not in imgui_render_backends
    error('unknown renderer type: ' + imgui_renderer)
endif

imgui_win_impl = 'imgui_impl_' + imgui_window
imgui_ren_impl = 'imgui_impl_' + imgui_renderer
imgui_win_ext = imgui_window_backends[imgui_window]['source_ext']
imgui_ren_ext = imgui_render_backends[imgui_renderer]['source_ext']

imgui_src = ['imgui.cpp', 'imgui_draw.cpp', 'imgui_tables.cpp', 'imgui_widgets.cpp']
if imgui_window in imgui_window_backends
    imgui_window_src = ['backends' / (imgui_win_impl + imgui_win_ext)]
endif

if imgui_renderer in imgui_render_backends
    imgui_render_src = ['backends' / (imgui_ren_impl + imgui_ren_ext)]
endif

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

foreach dep : imgui_window_backends[imgui_window]['require']
    imgui_deps += dependency(dep, method : dep == 'sdl2' ? 'config-tool' : 'auto')
endforeach

foreach dep : imgui_render_backends[imgui_renderer]['require']
    imgui_deps += dependency(dep)
endforeach

if imgui_truetype == 'freetype'
    imgui_src += 'misc/freetype/imgui_freetype.cpp'
endif

imgui_lib = static_library('imgui',
    imgui_src + imgui_window_src + imgui_render_src + [imconfig_h],
    include_directories: imgui_include,
    dependencies: imgui_deps,
    install: true
)

imgui_example_name = 'example_' + imgui_window_backends[imgui_window]['example'] + '_' + imgui_render_backends[imgui_renderer]['example']
imgui_example_src = 'examples' / imgui_example_name / ('main' + imgui_win_ext)

executable('imgui-demo',
    ['imgui_demo.cpp', imgui_example_src, imconfig_h],
    dependencies: imgui_deps,
    include_directories: imgui_include,
    link_with: imgui_lib,
    install: true,
)

install_headers(
    'imgui.h',
    'imgui_internal.h',
    'imstb_textedit.h',
    'backends' / (imgui_win_impl + '.h'),
    'backends' / (imgui_ren_impl + '.h'),
)

pkg = import('pkgconfig')

pkg.generate(imgui_lib,
    filebase : 'imgui',
    name : 'imgui',
    libraries : imgui_lib,
    description : 'Dear ImGui library',
    url : 'http://github.com/ocornut/imgui',
)

