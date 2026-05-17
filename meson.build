project('imgui', 'cpp', default_options : ['cpp_winlibs=', 'cpp_std=c++17'])

if host_machine.system() == 'darwin'
    add_languages('objcpp')
endif

cc = meson.get_compiler('cpp')
libm = cc.find_library('m', required : false)
libdl = cc.find_library('dl', required : false)

imgui_truetype = get_option('truetype')

imgui_include = include_directories('backends')

imgui_conf_data = configuration_data()

imgui_conf_data.set('IMGUI_DISABLE_OBSOLETE_FUNCTIONS', true)
if get_option('largeidx')
    imgui_conf_data.set('IMGUI_DRAWIDX_SIZE_32', true)
endif

if get_option('cimpl')
    # This option is used to build the library for cimgui
    # for MSVC it should be defined as extern "C"  __declspec(dllexport)
    imgui_conf_data.set('IMGUI_IMPL_API', 'extern "C"')
else
    imgui_conf_data.set('IMGUI_IMPL_API', '')
endif

imgui_deps = [libm, libdl]
if imgui_truetype == 'freetype'
    freetype_dep = dependency('freetype2')
    imgui_conf_data.set('IMGUI_ENABLE_FREETYPE', true)
    imgui_deps += freetype_dep
elif imgui_truetype == 'stb'
    imgui_conf_data.set('IMGUI_ENABLE_STB_TRUETYPE', true)
else
    error('unknown truetype option: ' + imgui_truetype)
endif

imconfig_h = configure_file(input : 'imconfig.h.in', output : 'imconfig.h', configuration : imgui_conf_data, install : true, install_dir : get_option('includedir'))

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

imgui_demo_lib = library('imguidemo',
    ['imgui_demo.cpp', imconfig_h],
    include_directories: imgui_include,
    link_with : imgui_lib,
    dependencies: imgui_deps,
    install: true
)

pkg = import('pkgconfig')

pkg.generate(imgui_lib,
    filebase : 'imgui',
    name : 'imgui',
    libraries : imgui_lib,
    description : 'Dear ImGui library',
    url : 'http://github.com/ocornut/imgui',
)

pkg.generate(imgui_demo_lib,
    filebase : 'imguidemo',
    name : 'imguidemo',
    libraries : [imgui_lib, imgui_demo_lib],
    description : 'Dear ImGui library Demo',
    url : 'http://github.com/ocornut/imgui',
)

if get_option('sdl')
    # With imgui 1.89.6 we have also sdl3 and sdl2/3 renderer for the implementation.
    # We may addo support for this variants but for the moments we only do sdl2.
    imgui_sdl_deps = [ dependency('sdl2', method : 'config-tool') ]
    imgui_sdl_lib = library('imguisdl', ['backends/imgui_impl_sdl2.cpp', imconfig_h],
        dependencies : imgui_sdl_deps,
        include_directories: imgui_include,
        link_with : imgui_lib,
        install : true,
    )
    install_headers('backends/imgui_impl_sdl2.h')
    pkg.generate(imgui_sdl_lib,
        filebase : 'imguisdl',
        name : 'imguisdl',
        libraries : [imgui_lib, imgui_sdl_lib],
        description : 'Dear ImGui library SDL2 support',
        url : 'http://github.com/ocornut/imgui',
    )
endif

if get_option('glfw')
    imgui_glfw_deps = [ dependency('glfw3') ]
    imgui_glfw_lib = library('imguiglfw', ['backends/imgui_impl_glfw.cpp', imconfig_h],
        dependencies : imgui_glfw_deps,
        include_directories: imgui_include,
        link_with : imgui_lib,
        install : true,
    )
    install_headers('backends/imgui_impl_glfw.h')
    pkg.generate(imgui_glfw_lib,
        filebase : 'imguiglfw',
        name : 'imguiglfw',
        libraries : [imgui_lib, imgui_glfw_lib],
        description : 'Dear ImGui library GLFW support',
        url : 'http://github.com/ocornut/imgui',
    )
endif

if get_option('win32')
    imgui_win32_deps = [ cc.find_library('gdi32'), cc.find_library('dwmapi') ]
    imgui_win32_lib = library('imguiwin32', ['backends/imgui_impl_win32.cpp', imconfig_h],
        dependencies : imgui_win32_deps,
        include_directories: imgui_include,
        link_with : imgui_lib,
        install : true,
    )
    install_headers('backends/imgui_impl_win32.h')
    pkg.generate(imgui_win32_lib,
        filebase : 'imguiwin32',
        name : 'imguiwin32',
        libraries : [imgui_lib, imgui_win32_lib],
        description : 'Dear ImGui library Win32 support',
        url : 'http://github.com/ocornut/imgui',
    )
endif

if get_option('osx')
    imgui_osx_lib = library('imguiosx', ['backends/imgui_impl_osx.mm', imconfig_h],
        include_directories: imgui_include,
        link_with : imgui_lib,
        link_args : ['-framework', 'AppKit', '-framework', 'GameController', '-framework', 'Foundation'],
        install : true,
    )
    install_headers('backends/imgui_impl_osx.h')
    pkg.generate(imgui_osx_lib,
        filebase : 'imguiosx',
        name : 'imguiosx',
        libraries : [imgui_lib, imgui_osx_lib],
        description : 'Dear ImGui library macOS support',
        url : 'http://github.com/ocornut/imgui',
    )
endif

imgui_3dapi_impl = []
if get_option('opengl2')
    imgui_opengl2_deps = [ dependency('gl') ]
    imgui_opengl2_lib = library('imguiopengl2', ['backends/imgui_impl_opengl2.cpp', imconfig_h],
        dependencies : imgui_opengl2_deps,
        include_directories: imgui_include,
        link_with : imgui_lib,
        install : true,
    )
    install_headers('backends/imgui_impl_opengl2.h')
    pkg.generate(imgui_opengl2_lib,
        filebase : 'imguiopengl2',
        name : 'imguiopengl2',
        libraries : [imgui_lib, imgui_opengl2_lib],
        description : 'Dear ImGui library OpenGL2 support',
        url : 'http://github.com/ocornut/imgui',
    )
endif

if get_option('opengl3')
    imgui_opengl3_deps = [ dependency('gl') ]
    imgui_opengl3_lib = library('imguiopengl3', ['backends/imgui_impl_opengl3.cpp', imconfig_h],
        dependencies : imgui_opengl3_deps,
        include_directories: imgui_include,
        link_with : imgui_lib,
        install : true,
    )
    install_headers('backends/imgui_impl_opengl3.h')
    pkg.generate(imgui_opengl3_lib,
        filebase : 'imguiopengl3',
        name : 'imguiopengl3',
        libraries : [imgui_lib, imgui_opengl3_lib],
        description : 'Dear ImGui library OpenGL3 support',
        url : 'http://github.com/ocornut/imgui',
    )
endif

if get_option('vulkan')
    imgui_vulkan_deps = [ dependency('vulkan') ]
    imgui_vulkan_lib = library('imguivulkan', ['backends/imgui_impl_vulkan.cpp', imconfig_h],
        dependencies : imgui_vulkan_deps,
        include_directories: imgui_include,
        link_with : imgui_lib,
        install : true,
    )
    install_headers('backends/imgui_impl_vulkan.h')
    pkg.generate(imgui_vulkan_lib,
        filebase : 'imguivulkan',
        name : 'imguivulkan',
        libraries : [imgui_lib, imgui_vulkan_lib],
        description : 'Dear ImGui library Vulkan support',
        url : 'http://github.com/ocornut/imgui',
    )
endif

if get_option('d3d9')
    dx9_dep = cc.find_library('d3d9')
    imgui_dx9_lib = library('imguidx9', ['backends/imgui_impl_dx9.cpp', imconfig_h],
        dependencies : dx9_dep,
        include_directories: imgui_include,
        link_with : imgui_lib,
        install : true,
    )
    install_headers('backends/imgui_impl_dx9.h')
    pkg.generate(imgui_dx9_lib,
        filebase : 'imguidx9',
        name : 'imguidx9',
        libraries : [imgui_lib, imgui_dx9_lib],
        description : 'Dear ImGui library DirectX9 support',
        url : 'http://github.com/ocornut/imgui',
    )
endif

if get_option('d3d10')
    imgui_dx10_deps = [ cc.find_library('d3d10'), cc.find_library('d3dcompiler'), cc.find_library('dxgi') ]
    imgui_dx10_lib = library('imguidx10', ['backends/imgui_impl_dx10.cpp', imconfig_h],
        dependencies : imgui_dx10_deps,
        include_directories: imgui_include,
        link_with : imgui_lib,
        install : true,
    )
    install_headers('backends/imgui_impl_dx10.h')
    pkg.generate(imgui_dx10_lib,
        filebase : 'imguidx10',
        name : 'imguidx10',
        libraries : [imgui_lib, imgui_dx10_lib],
        description : 'Dear ImGui library DirectX10 support',
        url : 'http://github.com/ocornut/imgui',
    )
endif

if get_option('d3d11')
    imgui_dx11_deps = [ cc.find_library('d3d11'), cc.find_library('d3dcompiler'), cc.find_library('dxgi') ]
    imgui_dx11_lib = library('imguidx11', ['backends/imgui_impl_dx11.cpp', imconfig_h],
        dependencies : imgui_dx11_deps,
        include_directories: imgui_include,
        link_with : imgui_lib,
        install : true,
    )
    install_headers('backends/imgui_impl_dx11.h')
    pkg.generate(imgui_dx11_lib,
        filebase : 'imguidx11',
        name : 'imguidx11',
        libraries : [imgui_lib, imgui_dx11_lib],
        description : 'Dear ImGui library DirectX11 support',
        url : 'http://github.com/ocornut/imgui',
    )
endif

if get_option('d3d12')
    imgui_dx12_deps = [ cc.find_library('d3d12'), cc.find_library('d3dcompiler'), cc.find_library('dxgi') ]
    imgui_dx12_lib = library('imguidx12', ['backends/imgui_impl_dx12.cpp', imconfig_h],
        dependencies : imgui_dx12_deps,
        include_directories: imgui_include,
        link_with : imgui_lib,
        install : true,
    )
    install_headers('backends/imgui_impl_dx12.h')
    pkg.generate(imgui_dx12_lib,
        filebase : 'imguidx12',
        name : 'imguidx12',
        libraries : [imgui_lib, imgui_dx12_lib],
        description : 'Dear ImGui library DirectX12 support',
        url : 'http://github.com/ocornut/imgui',
    )
endif

if get_option('metal')
    imgui_metal_lib = library('imguimetal', ['backends/imgui_impl_metal.mm', imconfig_h],
        include_directories: imgui_include,
        link_with : imgui_lib,
        link_args : ['-framework', 'Metal', '-framework', 'Foundation'],
        install : true,
    )
    install_headers('backends/imgui_impl_metal.h')
    pkg.generate(imgui_metal_lib,
        filebase : 'imguimetal',
        name : 'imguimetal',
        libraries : [imgui_lib, imgui_metal_lib],
        description : 'Dear ImGui library Metal support',
        url : 'http://github.com/ocornut/imgui',
    )
endif

if get_option('osx')
    if get_option('metal')
        # Af of 1.89.6 the following compiles but doesn't work, the window
        # never shows up.
        executable('imgui-demo-macos-metal',
            ['examples/example_apple_metal/main.mm', imconfig_h],
            dependencies: imgui_deps,
            include_directories: imgui_include,
            link_with: [imgui_lib, imgui_demo_lib, imgui_osx_lib, imgui_metal_lib],
            link_args : ['-framework', 'GameController', '-framework', 'AppKit', '-framework', 'MetalKit', '-framework', 'Foundation', '-framework', 'Metal'],
            objcpp_args : ['-DTARGET_OS_OSX'],
            install: true,
        )
    endif
endif

if get_option('sdl')
    if get_option('opengl3')
        executable('imgui-demo-sdl2-opengl3',
            ['examples/example_sdl2_opengl3/main.cpp', imconfig_h],
            dependencies: imgui_deps + imgui_sdl_deps + imgui_opengl3_deps,
            include_directories: imgui_include,
            link_with: [imgui_lib, imgui_demo_lib, imgui_sdl_lib, imgui_opengl3_lib],
            install: true,
        )
    endif
    if get_option('d3d11')
        executable('imgui-demo-sdl2-dx11',
            ['examples/example_sdl2_directx11/main.cpp', imconfig_h],
            dependencies: imgui_deps + imgui_sdl_deps,
            include_directories: imgui_include,
            link_with: [imgui_lib, imgui_demo_lib, imgui_sdl_lib, imgui_dx11_lib],
            install: true,
        )
    endif
endif
if get_option('glfw')
    if get_option('opengl3')
        executable('imgui-demo-glfw-opengl3',
            ['examples/example_glfw_opengl3/main.cpp', imconfig_h],
            dependencies: imgui_deps + imgui_glfw_deps + imgui_opengl3_deps,
            include_directories: imgui_include,
            link_with: [imgui_lib, imgui_demo_lib, imgui_glfw_lib, imgui_opengl3_lib],
            install: true,
        )
    endif
endif
if get_option('win32')
    if get_option('d3d11')
        executable('imgui-demo-win32-dx11',
            ['examples/example_win32_directx11/main.cpp', imconfig_h],
            dependencies: imgui_deps + imgui_win32_deps + imgui_dx11_deps,
            include_directories: imgui_include,
            link_with: [imgui_lib, imgui_demo_lib, imgui_win32_lib, imgui_dx11_lib],
            install: true,
        )
    endif
endif

install_headers(
    'imgui.h',
    'imgui_internal.h',
    'imstb_textedit.h',
)

if imgui_truetype == 'freetype'
    install_headers('misc/freetype/imgui_freetype.h')
endif

if get_option('stdlib')
    imgui_stdlib_include = include_directories('misc/cpp')
    imgui_stdlib_lib = library('imguistdlib', 'misc/cpp/imgui_stdlib.cpp',
        include_directories: [imgui_include, imgui_stdlib_include],
        link_with : imgui_lib,
        install : true,
    )
    install_headers('misc/cpp/imgui_stdlib.h')
    pkg.generate(imgui_stdlib_lib,
        filebase : 'imguistdlib',
        name : 'imguistdlib',
        libraries : [imgui_lib, imgui_stdlib_lib],
        description : 'Dear ImGui library C++ stdlib support',
        url : 'http://github.com/ocornut/imgui',
    )
endif
