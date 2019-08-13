import ranger.gui.context
import ranger.gui.widgets.browsercolumn

# Add your key names
ranger.gui.context.CONTEXT_KEYS.append('python')
ranger.gui.context.CONTEXT_KEYS.append('rcfile')

# Set it to False (the default value)
ranger.gui.context.Context.python = False
ranger.gui.context.Context.rcfile = False

OLD_HOOK_BEFORE_DRAWING = ranger.gui.widgets.browsercolumn.hook_before_drawing


def new_hook_before_drawing(fsobject, color_list):
    if fsobject.extension == 'py' or fsobject.extension == 'ipynb':
        color_list.append('python')
    elif fsobject.basename[-2:] == 'rc':
        color_list.append('rcfile')

    return OLD_HOOK_BEFORE_DRAWING(fsobject, color_list)


ranger.gui.widgets.browsercolumn.hook_before_drawing = new_hook_before_drawing
