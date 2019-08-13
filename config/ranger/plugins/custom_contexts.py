import ranger.gui.context
import ranger.gui.widgets.browsercolumn


OLD_HOOK_BEFORE_DRAWING = ranger.gui.widgets.browsercolumn.hook_before_drawing


def new_hook_before_drawing(fsobject, color_list):
    if fsobject.extension == 'py' or fsobject.extension == 'ipynb':
        color_list.append('python')
    elif fsobject.basename[-2:] == 'rc':
        color_list.append('rcfile')
    elif fsobject.extension == 'pdf' or fsobject.extension == 'eps':
        color_list.append('media')
        color_list.append('vector')
    elif fsobject.extension == 'md' or fsobject.extension == 'txt':
        color_list.append('textfile')

    return OLD_HOOK_BEFORE_DRAWING(fsobject, color_list)


# Add your key names
ranger.gui.context.CONTEXT_KEYS.append('code')
ranger.gui.context.CONTEXT_KEYS.append('python')
ranger.gui.context.CONTEXT_KEYS.append('rcfile')
ranger.gui.context.CONTEXT_KEYS.append('vector')
ranger.gui.context.CONTEXT_KEYS.append('textfile')

# Set it to False (the default value)
ranger.gui.context.Context.code = False
ranger.gui.context.Context.python = False
ranger.gui.context.Context.rcfile = False
ranger.gui.context.Context.vector = False
ranger.gui.context.Context.textfile = False

ranger.gui.widgets.browsercolumn.hook_before_drawing = new_hook_before_drawing
