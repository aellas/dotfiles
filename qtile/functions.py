# ~/.config/qtile/my_qtile_functions.py

def smart_swap(qtile):
    layout = qtile.current_layout
    window = qtile.current_window

    if hasattr(layout, "clients") and window in layout.clients:
        index = layout.clients.index(window)
        
        if index == 0:
            layout.swap_right()
        else:
            layout.swap_main()