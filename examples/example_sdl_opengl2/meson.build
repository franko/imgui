executable('demo-sdl-opengl2',
    [imgui_demo_source, 'main.cpp'],
    cpp_args: imgui_cflags,
    include_directories: [imgui_include, imgui_examples_include],
    link_with: [libimgui, libimgui_impl],
    dependencies: [libsdl2, opengl],
    install: true,
    gui_app: true,
)
